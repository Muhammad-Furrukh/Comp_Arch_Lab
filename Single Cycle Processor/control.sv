import header_pkg::*;

module control(
input logic [6:0] op_code, [2:0] func3, [6:0] func7,
output logic reg_wr, rd_en, wr_en, u, sel_A, sel_B, jump, [2:0] size, br_type, [1:0] wb_sel,
output alu_ops_t alu_op);
always_comb begin
  reg_wr = 1'b0; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
  sel_B = 1'b0; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  //Signals for R-type instructions
  if (op_code == 51) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b0; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  end
  //Signals for I-type arithematic/logical instructions
  else if (op_code == 19) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  end
  //Signals for I-type load instructions
  else if (op_code == 3) begin
    reg_wr = 1'b1; rd_en = 1'b1; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b0; br_type = 3'b111; wb_sel = 2'b01;
  end
  //Signals for JALR
  else if (op_code == 103) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b1; size = 3'b011; br_type = 3'b111; wb_sel = 2'b10;
  end
  //Signals for S-type instructions
  else if (op_code == 35) begin
    reg_wr = 1'b0; rd_en = 1'b0; wr_en = 1'b1; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b0; br_type = 3'b111; wb_sel = 2'b00;
  end
  //Signals for B-type instructions
  else if (op_code == 99) begin
    reg_wr = 1'b0; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b1; 
    sel_B = 1'b1; jump = 1'b0; size = 3'b011; wb_sel = 2'b00;
  end
  //Signals for JAL
  else if (op_code == 111) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b1; 
    sel_B = 1'b1; jump = 1'b1; size = 3'b011; br_type = 3'b111; wb_sel = 2'b10;
  end
  //Signals for AUIPC
  else if (op_code == 23) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b1; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  end
  //Signals for LUI
  else if (op_code == 55) begin
    reg_wr = 1'b1; rd_en = 1'b0; wr_en = 1'b0; u = 1'b1; sel_A = 1'b0; 
    sel_B = 1'b1; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  end
  //Default signal values
  else begin
    reg_wr = 1'b0; rd_en = 1'b0; wr_en = 1'b0; u = 1'b0; sel_A = 1'b0; 
    sel_B = 1'b0; jump = 1'b0; size = 3'b011; br_type = 3'b111; wb_sel = 2'b00;
  end
  case(op_code)
    //R type instructions
    7'h33: begin
      case(func7)
        7'h00: alu_op = ALU_ADD; 
        7'h20: alu_op = ALU_SUB;
      endcase
      case(func3)
        3'h1: alu_op = ALU_SLL;
        3'h2: alu_op =ALU_SLT;
        3'h3: alu_op = ALU_SLTU;
        3'h4: alu_op = ALU_XOR;
        3'h5: begin
          case(func7)
            7'h00: alu_op = ALU_SRL;
            7'h20: alu_op = ALU_SRA;
          endcase
        end
        3'h6: alu_op = ALU_OR;
        3'h7: alu_op = ALU_AND;
      endcase
    end
    //I type AL instructions
    7'h13: begin
      case(func3)
        3'h0: alu_op = ALU_ADD;
        3'h1: alu_op = ALU_SLL;
        3'h2: alu_op = ALU_SLT;
        3'h3: alu_op = ALU_SLTU;
        3'h4: alu_op = ALU_XOR;
        3'h5: begin
          case(func7)
            7'h00: alu_op = ALU_SRL;
            7'h20: alu_op = ALU_SRA;
          endcase
        end
        3'h6: alu_op = ALU_OR;
        3'h7: alu_op = ALU_AND;
      endcase
    end
    //I type Load instructions
    7'h03: begin
      case(func3)
        3'h0: begin alu_op = ALU_ADD; size = 3'b000; end
        3'h1: begin alu_op = ALU_ADD; size = 3'b001; end
        3'h2: begin alu_op = ALU_ADD; size = 3'b010; end
        3'h4: begin alu_op = ALU_ADD; size = 3'b100; end
        3'h5: begin alu_op = ALU_ADD; size = 3'b101; end
      endcase
    end
    //I type Jump instruction 
    7'h67: alu_op = ALU_ADD; 
    //Store instructions
    7'h23: begin
      case(func3)
        3'h0: begin alu_op = ALU_ADD; size = 3'b000; end
        3'h1: begin alu_op = ALU_ADD; size = 3'b001; end
        3'h2: begin alu_op = ALU_ADD; size = 3'b010; end
      endcase
    end
    //Branch instructions
    7'h63: begin
      case(func3)
        3'h0: begin alu_op = ALU_ADD; br_type = 3'b000; end
        3'h1: begin alu_op = ALU_ADD; br_type = 3'b001; end
        3'h4: begin alu_op = ALU_ADD; br_type = 3'b010; end
        3'h5: begin alu_op = ALU_ADD; br_type = 3'b011; end
        3'h6: begin alu_op = ALU_ADD; br_type = 3'b100; end
        3'h7: begin alu_op = ALU_ADD; br_type = 3'b101; end
      endcase
    end
    //Jump instructions
    7'h6F: alu_op = ALU_ADD; 
    //Upper Immediate type
    7'h17: alu_op = ALU_ADD; 
    7'h37: alu_op = ALU_LUI; 
  endcase
end
endmodule
