module instruction_memory#(
  parameter mem_size = 256
 )
  (input logic [31:0] addr,
  output logic [31:0] instr);
  logic [31:0] mem [0:mem_size-1]; 
  initial begin
    mem[0] = 32'h00000000;
    mem[1] = 32'h80000117;
    mem[2] = 32'h40010113;
    mem[3] = 32'h00000513;
    mem[4] = 32'h00000593;
    mem[5] = 32'h004000ef;
    mem[6] = 32'hfd010113;
    mem[7] = 32'h02812623;
    mem[8] = 32'h03010413;
    mem[9] = 32'h80000117;
    mem[10] = 32'h3e010113;
    mem[11] = 32'h00500793;
    mem[12] = 32'hfef42023;
    mem[13] = 32'h00a00793;
    mem[14] = 32'hfcf42e23;
    mem[15] = 32'hfe042703;
    mem[16] = 32'hfdc42783;
    mem[17] = 32'h00f707b3;
    mem[18] = 32'hfcf42c23;
    mem[19] = 32'hfd842703;
    mem[20] = 32'hfe042783;
    mem[21] = 32'h40f707b3;
    mem[22] = 32'hfcf42a23;
    mem[23] = 32'hfe042623;
    mem[24] = 32'hfe042423;
    mem[25] = 32'hfe042223;
    mem[26] = 32'h0200006f;
    mem[27] = 32'hfec42703;
    mem[28] = 32'hfd442783;
    mem[29] = 32'h00f707b3;
    mem[30] = 32'hfef42623;
    mem[31] = 32'hfe442783;
    mem[32] = 32'h00178793;
    mem[33] = 32'hfef42223;
    mem[34] = 32'hfe442703;
    mem[35] = 32'hfdc42783;
    mem[36] = 32'hfcf74ee3;
    mem[37] = 32'h0200006f;
    mem[38] = 32'hfec42703;
    mem[39] = 32'hfe042783;
    mem[40] = 32'h40f707b3;
    mem[41] = 32'hfef42623;
    mem[42] = 32'hfe842783;
    mem[43] = 32'h00178793;
    mem[44] = 32'hfef42423;
    mem[45] = 32'hfec42703;
    mem[46] = 32'hfe042783;
    mem[47] = 32'hfcf75ee3;
    mem[48] = 32'h0000006f;
  end
  
  //Converting byte address into word address
  always_comb begin
    instr = mem[addr >> 2];
  end
endmodule
