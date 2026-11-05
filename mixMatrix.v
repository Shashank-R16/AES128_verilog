// ============================================================================
// Module: mixMatrix  
// Applies MixColumns to all four 32-bit words (columns) of the 128-bit state.
// ============================================================================
module mixMatrix (
  input  [127:0] In_DI,
  output [127:0] Out_DO );

  // ------------------------------------------------------------------
  // Component instantiations
  // ------------------------------------------------------------------
  mixColumn mixColumn_0 (.In_DI(In_DI[127:96]), .Out_DO(Out_DO[127:96]));
  mixColumn mixColumn_1 (.In_DI(In_DI[95:64]),  .Out_DO(Out_DO[95:64]));
  mixColumn mixColumn_2 (.In_DI(In_DI[63:32]),  .Out_DO(Out_DO[63:32]));
  mixColumn mixColumn_3 (.In_DI(In_DI[31:0]),   .Out_DO(Out_DO[31:0]));

endmodule

