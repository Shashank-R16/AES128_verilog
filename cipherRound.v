// ============================================================================
// Module: cipherRound  (Verilog-2001 conversion of cipherRound.sv)
// A single AES-128 cipher round: SubBytes -> ShiftRows -> MixColumns ->
// AddRoundKey. Instantiated 9 times in the pipelined top level.
// ============================================================================
module cipherRound (
  input  [127:0] StateIn_DI,
  input  [127:0] Roundkey_DI,
  output [127:0] StateOut_DO );

  `include "aes128Pkg.vh"

  // ------------------------------------------------------------------
  // Signals
  // ------------------------------------------------------------------
  wire [127:0] SubMatrixOut_D;  // State after "SubMatrix".
  wire [127:0] ShiftRowsOut_D;  // State after "ShiftRows".
  wire [127:0] MixMatrixOut_D;  // State after "MixColumns".

  // ------------------------------------------------------------------
  // Component instantiations
  // ------------------------------------------------------------------
  subMatrix subMatrix_1 (.In_DI(StateIn_DI),     .Out_DO(SubMatrixOut_D));
  mixMatrix mixMatrix_1 (.In_DI(ShiftRowsOut_D), .Out_DO(MixMatrixOut_D));

  assign ShiftRowsOut_D = shift_rows(SubMatrixOut_D);
  assign StateOut_DO    = xor_matrix_logic(MixMatrixOut_D, Roundkey_DI);

endmodule
