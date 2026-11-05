// ============================================================================
// Module: subWord  (Verilog-2001 conversion of subWord.sv)
// Substitutes a 32-bit word byte-by-byte using four AES S-boxes.
// ============================================================================
module subWord (
  input  [31:0] In_DI,
  output [31:0] Out_DO );

  // ------------------------------------------------------------------
  // Component instantiations
  // ------------------------------------------------------------------
  sbox sbox_0 (.In_DI(In_DI[31:24]), .Out_DO(Out_DO[31:24]));
  sbox sbox_1 (.In_DI(In_DI[23:16]), .Out_DO(Out_DO[23:16]));
  sbox sbox_2 (.In_DI(In_DI[15:8]),  .Out_DO(Out_DO[15:8]));
  sbox sbox_3 (.In_DI(In_DI[7:0]),   .Out_DO(Out_DO[7:0]));

endmodule
