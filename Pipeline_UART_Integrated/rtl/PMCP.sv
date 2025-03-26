import header_pkg::*;

module PMCP(
  input  logic clk, 
  input  logic reset,
  output logic Tx_out;
);

logic signed [31:0] rdata1;
logic signed [31:0] rdata2;
logic signed [31:0] rdata2_MW;
logic signed [31:0] wdata;
logic signed [31:0] rdata;
logic signed [31:0] imm; 
logic signed [31:0] A; 
logic signed [31:0] B;
logic signed [31:0] ALU_out; 
logic signed [31:0] ALU_out_MW;
logic signed [31:0] proc_data;
logic        [31:0] instr_addr_off;
logic        [31:0] data_addr_off;
logic        [31:0] uart_addr_off;
logic        [31:0] instr;
logic        [31:0] instr_DE;
logic        [31:0] instr_MW;
logic        [31:0] new_addr;
logic        [31:0] curr_addr;
logic        [31:0] curr_addr_DE;
logic        [31:0] curr_addr_MW;
logic        [31:0] PC_4;
logic        [31:0] rdata1_prime;
logic        [31:0] rdata2_prime;
logic signed [20:0] immediate;
logic        [6:0]  func7; 
logic        [6:0]  op_code;
logic        [4:0]  raddr1; 
logic        [4:0]  raddr2; 
logic        [4:0]  waddr;
logic        [2:0]  br_type_DE;
logic        [2:0]  size_DE;
logic        [2:0]  size_MW; 
logic        [2:0]  func3;
logic        [1:0]  wb_sel_DE;
logic        [1:0]  wb_sel_MW;
logic               reg_wr_DE;
logic               reg_wr_MW;
logic               u_DE;
logic               sel_A_DE;
logic               sel_B_DE;
logic               b_or_j;
logic               wr_en_DE;
logic               wr_en_MW;
logic               rd_en_DE; 
logic               rd_en_MW;
logic               jump_DE;
logic               br_taken;
logic               r1_sel;
logic               r2_sel;
alu_ops_t           alu_op_DE;

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

data_memory data_memory(.clk(clk), .reset(reset), .wr_en(wr_en_MW), .rd_en(rd_en_MW), .addr(data_addr_off), 
.wdata(rdata2_MW), .size(size_MW), .rdata(rdata));

rdata_proc rdata_proc(.rdata(rdata), .size(size_MW), .proc_data(proc_data));

hazard_unit hazard_unit(.instr_DE(instr_DE), .instr_MW(instr_MW), .r1_sel(r1_sel), .r2_sel(r2_sel));

UART_Tx UART_Tx(.clk(clk), .reset(reset), .addr(uart_addr_off), .baud_divisor(rdata2_MW[13:0]), .raw_data(rdata2_MW[7:0]),
.wr_en(wr_en_MW), .rd_en(rd_en_MW), .Tx_en(rdata2_MW[0]), .Two_stop(rdata2_MW[1]), .Odd_parity(rdata2_MW[2]),
.Tx_out(Tx_out));

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
  // Detecting Memory Region and address offset
  if ((ALU_out_MW >= 32'h0) && (ALU_out_MW < 32'h3E8)) begin // instruction region
    instr_addr_off = ALU_out_MW;
    data_addr_off = 32'hx;
    uart_addr_off = 32'hx;
  end
  else if ((ALU_out_MW >= 32'h80000000) && (ALU_out_MW < 32'h80000100)) begin // data memory region
    instr_addr_off = 32'hx;
    data_addr_off = ALU_out_MW - 32'h80000000;
    uart_addr_off = 32'hx;
  end
  else if ((ALU_out_MW >= 32'h80000200) && (ALU_out_MW < 32'h80000300)) begin // uart region
    instr_addr_off = 32'hx;
    data_addr_off = 32'hx;
    uart_addr_off = ALU_out_MW - 32'h80000200;
  end
  
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