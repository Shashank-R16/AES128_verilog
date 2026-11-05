// ============================================================================
// Testbench for the Verilog-2001 AES-128 conversion.
// Runs two known-answer vectors and checks Ciphertext_DO once Busy_SO falls.
//   1) FIPS-197 Appendix C.1
//   2) all-zero key / plaintext (NIST known answer)
// ============================================================================
`timescale 1ns/1ps

module tb_aes128;

  reg  Clk_CI, Reset_RBI, Start_SI, NewCipherkey_SI;
  reg  [127:0] Plaintext_DI, Cipherkey_DI;
  wire Busy_SO;
  wire [127:0] Ciphertext_DO;

  aes128 dut (
    .Clk_CI(Clk_CI),
    .Reset_RBI(Reset_RBI),
    .Start_SI(Start_SI),
    .NewCipherkey_SI(NewCipherkey_SI),
    .Busy_SO(Busy_SO),
    .Plaintext_DI(Plaintext_DI),
    .Cipherkey_DI(Cipherkey_DI),
    .Ciphertext_DO(Ciphertext_DO));

  always #5 Clk_CI = ~Clk_CI;

  task run_vector;
    input [127:0] key;
    input [127:0] pt;
    input [127:0] expected;
    begin
      @(negedge Clk_CI);
      Cipherkey_DI     = key;
      Plaintext_DI     = pt;
      NewCipherkey_SI  = 1'b1;
      Start_SI         = 1'b1;
      @(negedge Clk_CI);
      NewCipherkey_SI  = 1'b0;
      Start_SI         = 1'b0;
      while (Busy_SO === 1'b1) @(negedge Clk_CI);
      if (Ciphertext_DO === expected)
        $display("PASS  key=%h pt=%h -> ct=%h", key, pt, Ciphertext_DO);
      else
        $display("FAIL  key=%h pt=%h -> ct=%h (expected %h)", key, pt, Ciphertext_DO, expected);
    end
  endtask

  initial begin
    Clk_CI = 0; Reset_RBI = 0; Start_SI = 0; NewCipherkey_SI = 0;
    Plaintext_DI = 0; Cipherkey_DI = 0;
    repeat (4) @(negedge Clk_CI);
    Reset_RBI = 1;
    repeat (2) @(negedge Clk_CI);

    run_vector(128'h000102030405060708090a0b0c0d0e0f,
               128'h00112233445566778899aabbccddeeff,
               128'h69c4e0d86a7b0430d8cdb78070b4c55a);

    run_vector(128'h00000000000000000000000000000000,
               128'h00000000000000000000000000000000,
               128'h66e94bd4ef8a2c3b884cfa59ca342b2e);

    $finish;
  end

endmodule
