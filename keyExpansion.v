// ============================================================================
// Module: keyExpansion  (Verilog-2001 conversion of keyExpansion.sv)
// Pipelined AES-128 key expansion. Structurally identical to the original:
// same enable shift register, same pipeline behavior. Arrays of Words are
// mapped to Verilog memories (ExpKey) / packed vectors (SubWord/Rcon buses).
// ============================================================================
module keyExpansion (
  input  Clk_CI,
  input  Reset_RBI,
  input  Start_SI,
  input  [127:0]   Cipherkey_DI,
  output [1407:0]  Roundkeys_DO );   // 11 round keys of 128 bits, packed

  `include "aes128Pkg.vh"

  // ------------------------------------------------------------------
  // Constants: round constants RCON[0..9], as a combinational case-based
  // lookup function (synthesizable ROM; replaces a memory + initial block)
  // ------------------------------------------------------------------
  function [7:0] rcon;
    input [3:0] idx;
    begin
      case (idx)
        4'd0: rcon = 8'h01;
        4'd1: rcon = 8'h02;
        4'd2: rcon = 8'h04;
        4'd3: rcon = 8'h08;
        4'd4: rcon = 8'h10;
        4'd5: rcon = 8'h20;
        4'd6: rcon = 8'h40;
        4'd7: rcon = 8'h80;
        4'd8: rcon = 8'h1B;
        4'd9: rcon = 8'h36;
        default: rcon = 8'h00;
      endcase
    end
  endfunction

  // ------------------------------------------------------------------
  // Functions
  // ------------------------------------------------------------------
  // to_logic4: packs four 32-bit words (columns) into one 128-bit round key.
  function [127:0] to_logic4;
    input [31:0] column0;
    input [31:0] column1;
    input [31:0] column2;
    input [31:0] column3;
    begin
      to_logic4 = {column0, column1, column2, column3};
    end
  endfunction

  // xor_words: XOR of two 32-bit words.
  function [31:0] xor_words;
    input [31:0] left;
    input [31:0] right;
    begin
      xor_words = left ^ right;
    end
  endfunction

  // ------------------------------------------------------------------
  // Signals
  // ------------------------------------------------------------------
  reg  [31:0]  ExpKey_DN [0:43];   // expanded key, next state (44 words)
  reg  [31:0]  ExpKey_DP [0:43];   // expanded key, current state
  wire [319:0] SubWordIn_D;        // 10 words packed, S-box inputs
  wire [319:0] SubWordOut_D;       // 10 words packed, S-box outputs
  wire [319:0] Rcon_D;             // 10 words packed, after Rcon XOR/rotation
  wire [1407:0] Roundkeys_D;       // 11 round keys packed
  reg  [0:9]   EnRndKeys_SN, EnRndKeys_SP;
  wire         AllEnRndKeysOred_S;
  wire         AllRndKeysDisabled_S;

  genvar i;
  integer j, k;

  // ------------------------------------------------------------------
  // Component instantiations: ten SubWord instances
  // ------------------------------------------------------------------
  generate for (i=0; i<10; i=i+1) begin : gen_subWords
    subWord subWords (.In_DI(SubWordIn_D[32*i +: 32]), .Out_DO(SubWordOut_D[32*i +: 32]));
  end endgenerate

  // ------------------------------------------------------------------
  // Output assignments: connect expanded-key columns to round key outputs
  // ------------------------------------------------------------------
  generate for (i=0; i<11; i=i+1) begin : gen_outputKeys
    assign Roundkeys_D[128*i +: 128] =
      to_logic4(ExpKey_DP[4*i], ExpKey_DP[4*i+1], ExpKey_DP[4*i+2], ExpKey_DP[4*i+3]);
  end endgenerate
  assign Roundkeys_DO = Roundkeys_D;

  // ------------------------------------------------------------------
  // Calculation of further round key words. Since "RotWord" only rotates
  // bytes of a word, it is done after the "SubWord" substitution here.
  // ------------------------------------------------------------------
  generate for (i=0; i<10; i=i+1) begin : gen_roundKeysFirst
    assign SubWordIn_D[32*i +: 32] = ExpKey_DP[4*i+3];

    assign Rcon_D[32*i+31 -: 8] = SubWordOut_D[32*i+23 -: 8] ^ rcon(i);
    assign Rcon_D[32*i+23 -: 8] = SubWordOut_D[32*i+15 -: 8];
    assign Rcon_D[32*i+15 -: 8] = SubWordOut_D[32*i+7  -: 8];
    assign Rcon_D[32*i+7  -: 8] = SubWordOut_D[32*i+31 -: 8];
  end endgenerate

  // ------------------------------------------------------------------
  // Next state computation of the expanded key (column-wise)
  // ------------------------------------------------------------------
  always @* begin
    // Defaults
    for (j=0; j<44; j=j+1) ExpKey_DN[j] = ExpKey_DP[j];

    // First round key = the cipherkey itself
    if (Start_SI == 1'b1) begin
      ExpKey_DN[0] = to_word(Cipherkey_DI[127:96]);
      ExpKey_DN[1] = to_word(Cipherkey_DI[95:64]);
      ExpKey_DN[2] = to_word(Cipherkey_DI[63:32]);
      ExpKey_DN[3] = to_word(Cipherkey_DI[31:0]);
    end

    // Calculate the next expanded key only when the enable is set
    for (j=0; j<10; j=j+1) begin
      if (EnRndKeys_SP[j] == 1'b1) begin
        ExpKey_DN[4*(j+1)+0] = xor_words(Rcon_D[32*j +: 32], ExpKey_DP[4*j]);
        ExpKey_DN[4*(j+1)+1] = xor_words(Rcon_D[32*j +: 32], xor_words(ExpKey_DP[4*j], ExpKey_DP[4*j+1]));
        ExpKey_DN[4*(j+1)+2] = xor_words(Rcon_D[32*j +: 32], xor_words(ExpKey_DP[4*j], xor_words(ExpKey_DP[4*j+1], ExpKey_DP[4*j+2])));
        ExpKey_DN[4*(j+1)+3] = xor_words(Rcon_D[32*j +: 32], xor_words(ExpKey_DP[4*j], xor_words(ExpKey_DP[4*j+1], xor_words(ExpKey_DP[4*j+2], ExpKey_DP[4*j+3]))));
      end
    end
  end

  // ------------------------------------------------------------------
  // Next state of the enable shift register
  // ------------------------------------------------------------------
  always @* begin
    EnRndKeys_SN = {1'b0, EnRndKeys_SP[0:8]};
    if (Start_SI == 1'b1) begin
      EnRndKeys_SN = {1'b1, EnRndKeys_SP[0:8]};
    end else if (AllRndKeysDisabled_S == 1'b1) begin
      EnRndKeys_SN = EnRndKeys_SP;
    end
  end

  assign AllEnRndKeysOred_S   = |EnRndKeys_SP;
  assign AllRndKeysDisabled_S = ~AllEnRndKeysOred_S;

  // ------------------------------------------------------------------
  // Flip flops
  // ------------------------------------------------------------------
  always @(posedge Clk_CI or negedge Reset_RBI) begin
    if (~Reset_RBI) begin
      for (k=0; k<44; k=k+1) ExpKey_DP[k] <= 32'h0;
      EnRndKeys_SP <= 0;
    end else begin
      for (k=0; k<44; k=k+1) ExpKey_DP[k] <= ExpKey_DN[k];
      EnRndKeys_SP <= EnRndKeys_SN;
    end
  end

endmodule
