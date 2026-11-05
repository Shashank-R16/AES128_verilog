// ============================================================================
// Module: mixColumn  (Verilog-2001 conversion of mixColumn.sv)
// MixColumns operation of AES on a single 32-bit column.
// A Word byte0 = [31:24], byte1 = [23:16], byte2 = [15:8], byte3 = [7:0].
// ============================================================================
module mixColumn (
  input  [31:0] In_DI,
  output [31:0] Out_DO );

  // ------------------------------------------------------------------
  // Signals
  // ------------------------------------------------------------------
  wire [7:0] Byte0_D, Byte0Doubled_D, Byte0Tripled_D;
  wire [7:0] Byte1_D, Byte1Doubled_D, Byte1Tripled_D;
  wire [7:0] Byte2_D, Byte2Doubled_D, Byte2Tripled_D;
  wire [7:0] Byte3_D, Byte3Doubled_D, Byte3Tripled_D;

  // ------------------------------------------------------------------
  // First Byte
  // ------------------------------------------------------------------
  assign Byte0_D        = In_DI[31:24];
  assign Byte0Doubled_D = (In_DI[31] == 1'b1) ? ({In_DI[30:24], 1'b0} ^ 8'h1B) : ({In_DI[30:24], 1'b0});
  assign Byte0Tripled_D = Byte0Doubled_D ^ Byte0_D;

  // ------------------------------------------------------------------
  // Second Byte
  // ------------------------------------------------------------------
  assign Byte1_D        = In_DI[23:16];
  assign Byte1Doubled_D = (In_DI[23] == 1'b1) ? ({In_DI[22:16], 1'b0} ^ 8'h1B) : ({In_DI[22:16], 1'b0});
  assign Byte1Tripled_D = Byte1Doubled_D ^ Byte1_D;

  // ------------------------------------------------------------------
  // Third Byte
  // ------------------------------------------------------------------
  assign Byte2_D        = In_DI[15:8];
  assign Byte2Doubled_D = (In_DI[15] == 1'b1) ? ({In_DI[14:8], 1'b0} ^ 8'h1B) : ({In_DI[14:8], 1'b0});
  assign Byte2Tripled_D = Byte2Doubled_D ^ Byte2_D;

  // ------------------------------------------------------------------
  // Fourth Byte
  // ------------------------------------------------------------------
  assign Byte3_D        = In_DI[7:0];
  assign Byte3Doubled_D = (In_DI[7] == 1'b1) ? ({In_DI[6:0], 1'b0} ^ 8'h1B) : ({In_DI[6:0], 1'b0});
  assign Byte3Tripled_D = Byte3Doubled_D ^ Byte3_D;

  // ------------------------------------------------------------------
  // Output Assignment
  // ------------------------------------------------------------------
  assign Out_DO[31:24] = Byte0Doubled_D ^ Byte1Tripled_D ^ Byte2_D ^ Byte3_D;
  assign Out_DO[23:16] = Byte0_D ^ Byte1Doubled_D ^ Byte2Tripled_D ^ Byte3_D;
  assign Out_DO[15:8]  = Byte0_D ^ Byte1_D ^ Byte2Doubled_D ^ Byte3Tripled_D;
  assign Out_DO[7:0]   = Byte0Tripled_D ^ Byte1_D ^ Byte2_D ^ Byte3Doubled_D;

endmodule
