// ============================================================================
// aes128Pkg.vh -- Verilog-2001 replacement for the SystemVerilog package
// aes128Pkg (aes128Pkg.sv). Verilog-2001 has no packages, so the shared types
// and functions are provided as an include file. Every module that used
// "import aes128Pkg::*;" must instead contain:  `include "aes128Pkg.vh"
//
// Type mapping used throughout the Verilog version (identical bit layout):
//   Byte   (logic [7:0])          -> [7:0]
//   Word   (Byte [0:3])           -> [31:0]   byte0=[31:24] byte1=[23:16]
//                                            byte2=[15:8]  byte3=[7:0]
//   Matrix (Word [0:3])           -> [127:0]  word0=[127:96] word1=[95:64]
//                                            word2=[63:32]  word3=[31:0]
//   roundkeyArrayType             -> packed [11*128-1:0] or reg [127:0] [0:10]
//
// Byte (r,c) of a 128-bit state/matrix lives at bits [127-32*r-8*c -: 8].
// ============================================================================

// ---------------------------------------------------------------------------
// Function: to_word
// Converts a 32-bit vector to a "Word". Identity in the flat representation.
// ---------------------------------------------------------------------------
function [31:0] to_word;
  input [31:0] inp;
  begin
    to_word = inp;
  end
endfunction

// ---------------------------------------------------------------------------
// Function: shift_rows
// Shifts the rows of a 128-bit state matrix as defined for AES.
// (Verbatim port of the original SystemVerilog function, expressed with
// flat bit-selects.)
// ---------------------------------------------------------------------------
function [127:0] shift_rows;
  input [127:0] inp;
  reg [127:0] result;
  begin
    // First row
    result[127 -: 8] = inp[127 -: 8];
    result[95  -: 8] = inp[95  -: 8];
    result[63  -: 8] = inp[63  -: 8];
    result[31  -: 8] = inp[31  -: 8];

    // Second row
    result[119 -: 8] = inp[87  -: 8];
    result[87  -: 8] = inp[55  -: 8];
    result[55  -: 8] = inp[23  -: 8];
    result[23  -: 8] = inp[119 -: 8];

    // Third row
    result[111 -: 8] = inp[47  -: 8];
    result[79  -: 8] = inp[15  -: 8];
    result[47  -: 8] = inp[111 -: 8];
    result[15  -: 8] = inp[79  -: 8];

    // Fourth row
    result[103 -: 8] = inp[7   -: 8];
    result[71  -: 8] = inp[103 -: 8];
    result[39  -: 8] = inp[71  -: 8];
    result[7   -: 8] = inp[39  -: 8];

    shift_rows = result;
  end
endfunction

// ---------------------------------------------------------------------------
// Function: xor_matrix_logic
// Perform an XOR operation given a 128-bit matrix and a 128-bit vector
// (i.e., the AddRoundKey step).
// ---------------------------------------------------------------------------
function [127:0] xor_matrix_logic;
  input [127:0] left;
  input [127:0] right;
  reg [127:0] result;
  begin
    result[127 -: 8] = left[127 -: 8] ^ right[127 -: 8];
    result[119 -: 8] = left[119 -: 8] ^ right[119 -: 8];
    result[111 -: 8] = left[111 -: 8] ^ right[111 -: 8];
    result[103 -: 8] = left[103 -: 8] ^ right[103 -: 8];
    result[95  -: 8] = left[95  -: 8] ^ right[95  -: 8];
    result[87  -: 8] = left[87  -: 8] ^ right[87  -: 8];
    result[79  -: 8] = left[79  -: 8] ^ right[79  -: 8];
    result[71  -: 8] = left[71  -: 8] ^ right[71  -: 8];
    result[63  -: 8] = left[63  -: 8] ^ right[63  -: 8];
    result[55  -: 8] = left[55  -: 8] ^ right[55  -: 8];
    result[47  -: 8] = left[47  -: 8] ^ right[47  -: 8];
    result[39  -: 8] = left[39  -: 8] ^ right[39  -: 8];
    result[31  -: 8] = left[31  -: 8] ^ right[31  -: 8];
    result[23  -: 8] = left[23  -: 8] ^ right[23  -: 8];
    result[15  -: 8] = left[15  -: 8] ^ right[15  -: 8];
    result[7   -: 8] = left[7   -: 8] ^ right[7   -: 8];

    xor_matrix_logic = result;
  end
endfunction
