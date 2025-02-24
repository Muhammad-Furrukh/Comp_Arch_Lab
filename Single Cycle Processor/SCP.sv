import header_pkg::*;

module SCP(
  input logic clk, reset, 
  output logic signed [31:0] rdata1, rdata2, wdata, rdata, imm, A, B, ALU_out, proc_data,
  output reg_wr, u, sel_A, sel_B, wr_en, rd_en, jump, br_taken,
  output logic [31:0] instr, new_addr, curr_addr, PC_4,
  output logic [4:0] raddr1, raddr2, waddr,
  output logic [6:0] func7, op_code,
  output logic [2:0] br_type, size, func3,
  output logic [1:0] wb_sel, 
  output alu_ops_t alu_op

);

logic signed [20:0] immediate;

PC PC(.reset(reset), .clk(clk), .d(new_addr), .q(curr_addr));

instruction_memory instr_mem(.addr(curr_addr), .instr(instr));

register_file register_file(.clk(clk), .reset(reset), .reg_wr(reg_wr), .raddr1(raddr1),
.raddr2(raddr2), .waddr(waddr), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

immediate_gen immediate_gen (.u(u), .imm(immediate), .out(imm));

control control(.op_code(op_code), .func3(func3), .func7(func7), .reg_wr(reg_wr),
.rd_en(rd_en), .wr_en(wr_en), .u(u), .sel_A(sel_A), .sel_B(sel_B), .jump(jump), .size(size), .br_type(br_type),
.wb_sel(wb_sel), .alu_op(alu_op));

branch_cond branch_cond(.rdata1(rdata1), .rdata2(rdata2), .br_type(br_type), .br_taken(br_taken));

ALU ALU(.A(A), .B(B), .alu_op(alu_op), .out(ALU_out));

data_memory data_memory(.clk(clk), .reset(reset), .wr_en(wr_en), .rd_en(rd_en), .addr(ALU_out), .wdata(rdata2),
.size(size), .rdata(rdata));

rdata_proc rdata_proc(.rdata(rdata), .size(size), .proc_data(proc_data));

always_comb begin
  case(instr[6:0])
    7'd51: begin
      func7 = instr[31:25]; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = instr[11:7]; op_code = instr[6:0]; immediate = 21'b0;
    end
    7'd3: begin
      func7 = 7'b0; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {9'b0, instr[31:20]};
    end
    7'd19: begin
      func7 = instr[31:25]; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {9'b0, instr[31:20]};
    end
    7'd103: begin
      func7 = instr[31:25]; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {9'b0, instr[31:20]};
    end
    7'd35: begin
      func7 = 7'b0; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = 5'b0; op_code = instr[6:0]; immediate = {9'b0, instr[31:25], instr[11:7]};
    end
    7'd99: begin
      func7 = 7'b0; raddr2 = instr[24:20]; raddr1 = instr[19:15];
      func3 = instr[14:12]; waddr = 5'b0; op_code = instr[6:0]; immediate = {8'b0, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    end
    7'd23: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {1'b0, instr[31:12]};
    end
    7'd55: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {1'b0, instr[31:12]};
    end
    7'd111: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; waddr = instr[11:7]; op_code = instr[6:0]; immediate = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    end
    default: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; waddr = 5'b0; op_code = 7'b0; immediate = 21'b0;
    end
  endcase
end

always_comb begin
  //Mux for input A to ALU
  if (sel_A) begin
    A = curr_addr;
  end
  else begin
    A = rdata1;
  end

  //Mux for input B to ALU
  if (sel_B) begin
    B = imm;
  end
  else begin
    B = rdata2;
  end

  //Writing address of next line
  PC_4 = curr_addr + 32'd4;

  //Write back to register file
  case(wb_sel)
    2'b00: wdata = ALU_out;
    2'b01: wdata = proc_data;
    2'b10: wdata = PC_4;
    default: wdata = 32'b0;
  endcase
  
  //Mux for PC Jump
  if (br_taken | jump) begin
    new_addr = ALU_out;
  end
  else  begin
    new_addr = curr_addr + 4;
  end
end

endmodule