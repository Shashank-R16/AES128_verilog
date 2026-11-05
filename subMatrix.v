// ============================================================================
// Module: subMatrix  (Verilog-2001 conversion of subMatrix.sv)
// Substitutes a 128-bit state matrix word-by-word using four SubWord units.
// ============================================================================
module subMatrix (
  input  [127:0] In_DI,
  output [127:0] Out_DO );

  // ------------------------------------------------------------------
  // Component instantiations
  // ------------------------------------------------------------------
  subWord subWord_0 (.In_DI(In_DI[127:96]), .Out_DO(Out_DO[127:96]));
  subWord subWord_1 (.In_DI(In_DI[95:64]),  .Out_DO(Out_DO[95:64]));
  subWord subWord_2 (.In_DI(In_DI[63:32]),  .Out_DO(Out_DO[63:32]));
  subWord subWord_3 (.In_DI(In_DI[31:0]),   .Out_DO(Out_DO[31:0]));

endmodule
