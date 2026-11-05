// ============================================================================
// Module: sbox  (Verilog-2001 conversion of sbox.sv)
// AES S-box, LUT-based, one byte in / one byte out. SBOX table identical to
// the original SystemVerilog version.
// ============================================================================
module sbox (
  input  [7:0] In_DI,
  output [7:0] Out_DO );

  // ------------------------------------------------------------------
  // Constants: AES S-box lookup table (256 entries)
  // ------------------------------------------------------------------
  reg [7:0] SBOX [0:255];
  initial begin
    SBOX[0] = 8'd99; SBOX[1] = 8'd124; SBOX[2] = 8'd119; SBOX[3] = 8'd123; SBOX[4] = 8'd242; SBOX[5] = 8'd107; SBOX[6] = 8'd111; SBOX[7] = 8'd197;
    SBOX[8] = 8'd48; SBOX[9] = 8'd1; SBOX[10] = 8'd103; SBOX[11] = 8'd43; SBOX[12] = 8'd254; SBOX[13] = 8'd215; SBOX[14] = 8'd171; SBOX[15] = 8'd118;
    SBOX[16] = 8'd202; SBOX[17] = 8'd130; SBOX[18] = 8'd201; SBOX[19] = 8'd125; SBOX[20] = 8'd250; SBOX[21] = 8'd89; SBOX[22] = 8'd71; SBOX[23] = 8'd240;
    SBOX[24] = 8'd173; SBOX[25] = 8'd212; SBOX[26] = 8'd162; SBOX[27] = 8'd175; SBOX[28] = 8'd156; SBOX[29] = 8'd164; SBOX[30] = 8'd114; SBOX[31] = 8'd192;
    SBOX[32] = 8'd183; SBOX[33] = 8'd253; SBOX[34] = 8'd147; SBOX[35] = 8'd38; SBOX[36] = 8'd54; SBOX[37] = 8'd63; SBOX[38] = 8'd247; SBOX[39] = 8'd204;
    SBOX[40] = 8'd52; SBOX[41] = 8'd165; SBOX[42] = 8'd229; SBOX[43] = 8'd241; SBOX[44] = 8'd113; SBOX[45] = 8'd216; SBOX[46] = 8'd49; SBOX[47] = 8'd21;
    SBOX[48] = 8'd4; SBOX[49] = 8'd199; SBOX[50] = 8'd35; SBOX[51] = 8'd195; SBOX[52] = 8'd24; SBOX[53] = 8'd150; SBOX[54] = 8'd5; SBOX[55] = 8'd154;
    SBOX[56] = 8'd7; SBOX[57] = 8'd18; SBOX[58] = 8'd128; SBOX[59] = 8'd226; SBOX[60] = 8'd235; SBOX[61] = 8'd39; SBOX[62] = 8'd178; SBOX[63] = 8'd117;
    SBOX[64] = 8'd9; SBOX[65] = 8'd131; SBOX[66] = 8'd44; SBOX[67] = 8'd26; SBOX[68] = 8'd27; SBOX[69] = 8'd110; SBOX[70] = 8'd90; SBOX[71] = 8'd160;
    SBOX[72] = 8'd82; SBOX[73] = 8'd59; SBOX[74] = 8'd214; SBOX[75] = 8'd179; SBOX[76] = 8'd41; SBOX[77] = 8'd227; SBOX[78] = 8'd47; SBOX[79] = 8'd132;
    SBOX[80] = 8'd83; SBOX[81] = 8'd209; SBOX[82] = 8'd0; SBOX[83] = 8'd237; SBOX[84] = 8'd32; SBOX[85] = 8'd252; SBOX[86] = 8'd177; SBOX[87] = 8'd91;
    SBOX[88] = 8'd106; SBOX[89] = 8'd203; SBOX[90] = 8'd190; SBOX[91] = 8'd57; SBOX[92] = 8'd74; SBOX[93] = 8'd76; SBOX[94] = 8'd88; SBOX[95] = 8'd207;
    SBOX[96] = 8'd208; SBOX[97] = 8'd239; SBOX[98] = 8'd170; SBOX[99] = 8'd251; SBOX[100] = 8'd67; SBOX[101] = 8'd77; SBOX[102] = 8'd51; SBOX[103] = 8'd133;
    SBOX[104] = 8'd69; SBOX[105] = 8'd249; SBOX[106] = 8'd2; SBOX[107] = 8'd127; SBOX[108] = 8'd80; SBOX[109] = 8'd60; SBOX[110] = 8'd159; SBOX[111] = 8'd168;
    SBOX[112] = 8'd81; SBOX[113] = 8'd163; SBOX[114] = 8'd64; SBOX[115] = 8'd143; SBOX[116] = 8'd146; SBOX[117] = 8'd157; SBOX[118] = 8'd56; SBOX[119] = 8'd245;
    SBOX[120] = 8'd188; SBOX[121] = 8'd182; SBOX[122] = 8'd218; SBOX[123] = 8'd33; SBOX[124] = 8'd16; SBOX[125] = 8'd255; SBOX[126] = 8'd243; SBOX[127] = 8'd210;
    SBOX[128] = 8'd205; SBOX[129] = 8'd12; SBOX[130] = 8'd19; SBOX[131] = 8'd236; SBOX[132] = 8'd95; SBOX[133] = 8'd151; SBOX[134] = 8'd68; SBOX[135] = 8'd23;
    SBOX[136] = 8'd196; SBOX[137] = 8'd167; SBOX[138] = 8'd126; SBOX[139] = 8'd61; SBOX[140] = 8'd100; SBOX[141] = 8'd93; SBOX[142] = 8'd25; SBOX[143] = 8'd115;
    SBOX[144] = 8'd96; SBOX[145] = 8'd129; SBOX[146] = 8'd79; SBOX[147] = 8'd220; SBOX[148] = 8'd34; SBOX[149] = 8'd42; SBOX[150] = 8'd144; SBOX[151] = 8'd136;
    SBOX[152] = 8'd70; SBOX[153] = 8'd238; SBOX[154] = 8'd184; SBOX[155] = 8'd20; SBOX[156] = 8'd222; SBOX[157] = 8'd94; SBOX[158] = 8'd11; SBOX[159] = 8'd219;
    SBOX[160] = 8'd224; SBOX[161] = 8'd50; SBOX[162] = 8'd58; SBOX[163] = 8'd10; SBOX[164] = 8'd73; SBOX[165] = 8'd6; SBOX[166] = 8'd36; SBOX[167] = 8'd92;
    SBOX[168] = 8'd194; SBOX[169] = 8'd211; SBOX[170] = 8'd172; SBOX[171] = 8'd98; SBOX[172] = 8'd145; SBOX[173] = 8'd149; SBOX[174] = 8'd228; SBOX[175] = 8'd121;
    SBOX[176] = 8'd231; SBOX[177] = 8'd200; SBOX[178] = 8'd55; SBOX[179] = 8'd109; SBOX[180] = 8'd141; SBOX[181] = 8'd213; SBOX[182] = 8'd78; SBOX[183] = 8'd169;
    SBOX[184] = 8'd108; SBOX[185] = 8'd86; SBOX[186] = 8'd244; SBOX[187] = 8'd234; SBOX[188] = 8'd101; SBOX[189] = 8'd122; SBOX[190] = 8'd174; SBOX[191] = 8'd8;
    SBOX[192] = 8'd186; SBOX[193] = 8'd120; SBOX[194] = 8'd37; SBOX[195] = 8'd46; SBOX[196] = 8'd28; SBOX[197] = 8'd166; SBOX[198] = 8'd180; SBOX[199] = 8'd198;
    SBOX[200] = 8'd232; SBOX[201] = 8'd221; SBOX[202] = 8'd116; SBOX[203] = 8'd31; SBOX[204] = 8'd75; SBOX[205] = 8'd189; SBOX[206] = 8'd139; SBOX[207] = 8'd138;
    SBOX[208] = 8'd112; SBOX[209] = 8'd62; SBOX[210] = 8'd181; SBOX[211] = 8'd102; SBOX[212] = 8'd72; SBOX[213] = 8'd3; SBOX[214] = 8'd246; SBOX[215] = 8'd14;
    SBOX[216] = 8'd97; SBOX[217] = 8'd53; SBOX[218] = 8'd87; SBOX[219] = 8'd185; SBOX[220] = 8'd134; SBOX[221] = 8'd193; SBOX[222] = 8'd29; SBOX[223] = 8'd158;
    SBOX[224] = 8'd225; SBOX[225] = 8'd248; SBOX[226] = 8'd152; SBOX[227] = 8'd17; SBOX[228] = 8'd105; SBOX[229] = 8'd217; SBOX[230] = 8'd142; SBOX[231] = 8'd148;
    SBOX[232] = 8'd155; SBOX[233] = 8'd30; SBOX[234] = 8'd135; SBOX[235] = 8'd233; SBOX[236] = 8'd206; SBOX[237] = 8'd85; SBOX[238] = 8'd40; SBOX[239] = 8'd223;
    SBOX[240] = 8'd140; SBOX[241] = 8'd161; SBOX[242] = 8'd137; SBOX[243] = 8'd13; SBOX[244] = 8'd191; SBOX[245] = 8'd230; SBOX[246] = 8'd66; SBOX[247] = 8'd104;
    SBOX[248] = 8'd65; SBOX[249] = 8'd153; SBOX[250] = 8'd45; SBOX[251] = 8'd15; SBOX[252] = 8'd176; SBOX[253] = 8'd84; SBOX[254] = 8'd187; SBOX[255] = 8'd22;
  end

  assign Out_DO = SBOX[In_DI];

endmodule
