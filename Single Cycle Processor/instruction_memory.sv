module instruction_memory#(
  parameter mem_size = 256
 )
  (input logic [31:0] addr,
  output logic [31:0] instr);
  logic [31:0] mem [0:mem_size-1]; 
  initial begin
    mem[0] = 32'h00000000;
    mem[1] = 32'h00200413;
    mem[2] = 32'h008404b3;
    mem[3] = 32'h40940433;
    mem[4] = 32'h00940433;
    mem[5] = 32'h00941433;
    mem[6] = 32'h00945433;
  end
  
  //Converting byte address into word address
  always_comb begin
    instr = mem[addr >> 2];
  end
endmodule
