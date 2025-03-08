import header_pkg::*;

module PMCP(
  input logic clk, reset
);

logic signed [20:0] immediate;
logic signed [31:0] rdata1, rdata2, rdata2_MW, wdata, rdata, imm, 
A, B, ALU_out, ALU_out_MW, proc_data;
logic reg_wr_DE, reg_wr_MW, u_DE, sel_A_DE, sel_B_DE, b_or_j,
wr_en_DE, wr_en_MW, rd_en_DE, rd_en_MW, jump_DE, br_taken, r1_sel, r2_sel;
logic [31:0] instr, instr_DE, instr_MW, new_addr, curr_addr, curr_addr_DE,
curr_addr_MW, PC_4, rdata1_prime, rdata2_prime;
logic [4:0] raddr1, raddr2, waddr;
logic [6:0] func7, op_code;
logic [2:0] br_type_DE, size_DE, size_MW, func3;
logic [1:0] wb_sel_DE, wb_sel_MW;
alu_ops_t alu_op_DE;

PC PC(.reset(reset), .clk(clk), .d(new_addr), .q(curr_addr));

instruction_memory instr_mem(.addr(curr_addr), .instr(instr));

register PC_DE(.clk(clk), .reset(reset), .D(curr_addr), .Q(curr_addr_DE));

instr_fetch_reg IR_DE(.clk(clk), .reset(reset), .D(instr), .Q(instr_DE), .b_or_j(b_or_j));

register_file register_file(.clk(clk), .reset(reset), .reg_wr(reg_wr_MW), .raddr1(raddr1),
.raddr2(raddr2), .waddr(waddr), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

immediate_gen immediate_gen (.u(u_DE), .imm(immediate), .out(imm));

control_DE control_DE(.op_code(op_code), .func3(func3), .func7(func7), .reg_wr(reg_wr_DE),
.rd_en(rd_en_DE), .wr_en(wr_en_DE), .u(u_DE), .sel_A(sel_A_DE), .sel_B(sel_B_DE), .jump(jump_DE), 
.size(size_DE), .br_type(br_type_DE),.wb_sel(wb_sel_DE), .alu_op(alu_op_DE));

control_MW control_MW(.clk(clk), .reset(reset), .reg_wr_DE(reg_wr_DE), .rd_en_DE(rd_en_DE), 
.wr_en_DE(wr_en_DE), .size_DE(size_DE), .wb_sel_DE(wb_sel_DE), .reg_wr_MW(reg_wr_MW), 
.rd_en_MW(rd_en_MW), .wr_en_MW(wr_en_MW), .size_MW(size_MW), .wb_sel_MW(wb_sel_MW));

branch_cond branch_cond(.rdata1(rdata1), .rdata2(rdata2), .br_type(br_type_DE), .br_taken(br_taken));

ALU ALU(.A(A), .B(B), .alu_op(alu_op_DE), .out(ALU_out));

register PC_MW(.clk(clk), .reset(reset), .D(curr_addr_DE), .Q(curr_addr_MW));

register ALU_MW(.clk(clk), .reset(reset), .D(ALU_out), .Q(ALU_out_MW));

register WD_MW(.clk(clk), .reset(reset), .D(rdata2), .Q(rdata2_MW));

register IR_MW(.clk(clk), .reset(reset), .D(instr_DE), .Q(instr_MW));

data_memory data_memory(.clk(clk), .reset(reset), .wr_en(wr_en_MW), .rd_en(rd_en_MW), .addr(ALU_out_MW), 
.wdata(rdata2_MW), .size(size_MW), .rdata(rdata));

rdata_proc rdata_proc(.rdata(rdata), .size(size_MW), .proc_data(proc_data));

hazard_unit hazard_unit(.instr_DE(instr_DE), .instr_MW(instr_MW), .r1_sel(r1_sel), .r2_sel(r2_sel));

// Decoder
always_comb begin
  case(instr_DE[6:0])
    7'd51: begin
      func7 = instr_DE[31:25]; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = 21'b0;
    end
    7'd3: begin
      func7 = 7'b0; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = {9'b0, instr_DE[31:20]};
    end
    7'd19: begin
      func7 = instr_DE[31:25]; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = {9'b0, instr_DE[31:20]};
    end
    7'd103: begin
      func7 = instr_DE[31:25]; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = {9'b0, instr_DE[31:20]};
    end
    7'd35: begin
      func7 = 7'b0; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = {9'b0, instr_DE[31:25], instr_DE[11:7]};
    end
    7'd99: begin
      func7 = 7'b0; raddr2 = instr_DE[24:20]; raddr1 = instr_DE[19:15];
      func3 = instr_DE[14:12]; op_code = instr_DE[6:0]; immediate = {8'b0, instr_DE[31], instr_DE[7], instr_DE[30:25], instr_DE[11:8], 1'b0};
    end
    7'd23: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; op_code = instr_DE[6:0]; immediate = {1'b0, instr_DE[31:12]};
    end
    7'd55: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; op_code = instr_DE[6:0]; immediate = {1'b0, instr_DE[31:12]};
    end
    7'd111: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; op_code = instr_DE[6:0]; immediate = {instr_DE[31], instr_DE[19:12], instr_DE[20], instr_DE[30:21], 1'b0};
    end
    default: begin
      func7 = 7'b0; raddr2 = 5'b0; raddr1 = 5'b0;
      func3 = 3'b0; waddr = 5'b0; op_code = 7'b0; immediate = 21'b0;
    end
  endcase
  waddr = instr_MW[11:7];
end

always_comb begin
  b_or_j = jump_DE | br_taken;
  // Muxes for forwarding
  if (r1_sel) begin
    rdata1_prime = wdata;
  end
  else begin
    rdata1_prime = rdata1;
  end

  if (r2_sel) begin
    rdata2_prime = wdata;
  end
  else begin
    rdata2_prime = rdata2;
  end

  //Mux for input A to ALU
  if (sel_A_DE) begin
    A = curr_addr_DE;
  end
  else begin
    A = rdata1_prime;
  end

  //Mux for input B to ALU
  if (sel_B_DE) begin
    B = imm;
  end
  else begin
    B = rdata2_prime;
  end

  //Writing address of next line
  PC_4 = curr_addr_MW + 32'd4;

  //Write back to register file
  case(wb_sel_MW)
    2'b00: wdata = ALU_out_MW;
    2'b01: wdata = proc_data;
    2'b10: wdata = PC_4;
    default: wdata = 32'b0;
  endcase
  
  //Mux for PC Jump
  if (br_taken | jump_DE) begin
    new_addr = ALU_out;
  end
  else  begin
    new_addr = curr_addr + 4;
  end
end

endmodule