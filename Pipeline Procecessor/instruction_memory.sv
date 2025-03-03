module instruction_memory#(
  parameter mem_size = 1024
 )
  (input logic [31:0] addr,
  output logic [31:0] instr);
  reg [31:0] mem [0:mem_size-1]; 
  initial begin
    $readmemh("./Code_accessories/build/main.txt", mem);
    
  end
  
  //Converting byte address into word address
  always_comb begin
    instr = mem[addr >> 2];
  end
endmodule
