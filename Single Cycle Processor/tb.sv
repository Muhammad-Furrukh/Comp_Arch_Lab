import header_pkg::*;

module tb();
logic clk, reset, reg_wr, u, sel_A, sel_B, wr_en, rd_en, jump, br_taken;
logic signed [31:0] rdata1, rdata2, rdata, wdata, imm, A, B, ALU_out, proc_data;
logic [31:0] instr, new_addr, curr_addr, PC_4;
logic [4:0] raddr1, raddr2, waddr;
logic [6:0] func7, op_code;
logic [2:0] br_type, size, func3;
logic [1:0] wb_sel;
alu_ops_t alu_op;

SCP DUT(
    .clk(clk), .reset(reset), .reg_wr(reg_wr), .u(u), .sel_A(sel_A), .sel_B(sel_B), .wr_en(wr_en),
    .rd_en(rd_en), .jump(jump), .br_taken(br_taken), .instr(instr), .waddr(waddr), .raddr1(raddr1), .raddr2(raddr2),
    .A(A), .B(B), .ALU_out(ALU_out), .proc_data(proc_data), .new_addr(new_addr), .curr_addr(curr_addr), .PC_4(PC_4),
    .rdata1(rdata1), .rdata2(rdata2), .rdata(rdata), .wdata(wdata), .imm(imm), .op_code(op_code), .func3(func3), .func7(func7), 
    .br_type(br_type), .size(size), .wb_sel(wb_sel), .alu_op(alu_op)
);

initial begin
$dumpfile("SCP.vcd");
$dumpvars(0, tb);
end
initial begin
clk = 1'b1;
forever #5 clk = ~clk;
end

initial begin
reset = 1'b1;
@(posedge clk)
reset = 1'b0;
end
endmodule