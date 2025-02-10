`include "header.sv"

module ALU(
    input alu_ops_t alu_op, 
    input logic signed [31:0] A, B,
    output logic signed [31:0] out
);

logic [31:0] uA, uB;
always_comb begin
  if (A < 0) begin
      uA = (A ^ 32'hFFFFFFFF) + 1;
    end
    else begin
      uA = A;
    end
    if (B < 0) begin
      uB = (B ^ 32'hFFFFFFFF) + 1;
    end
    else begin
      uB = B;
    end
  case(alu_op)
    ALU_ADD: out = A + B;
    ALU_SUB: out = A - B; 
    ALU_AND: out = A & B; 
    ALU_OR: out = A | B; 
    ALU_XOR: out = A ^ B; 
    ALU_SLT: out = (A < B)? 32'b1: 32'b0;
    ALU_SLL: out = A << B[4:0];
    ALU_SRL: out = A >> B[4:0]; 
    ALU_SRA: out = A >>> B[4:0];
    ALU_SLTU: out = (uA < uB)? 32'b1: 32'b0; 
    ALU_LUI: out = B;
  endcase
end
endmodule