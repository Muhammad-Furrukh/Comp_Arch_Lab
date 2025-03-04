module register_file(
input logic clk, reset, reg_wr, [4:0] raddr1, raddr2, waddr, 
input logic signed [31:0] wdata,
output logic signed [31:0] rdata1, rdata2);
logic signed [31:0] registers [30:0];
logic [31:0] x0 = 32'b0;
int i;
always_ff @(negedge clk) begin
    if (reset) begin
      registers <= '{ 31{32'bx} };
    end
    else if (reg_wr) begin
      registers[waddr - 1] <= wdata;
    end
end

always_comb begin
  case(raddr1)
    5'd0: rdata1 = x0;
    5'd1: rdata1 = registers[0];
    5'd2: rdata1 = registers[1];
    5'd3: rdata1 = registers[2];
    5'd4: rdata1 = registers[3];
    5'd5: rdata1 = registers[4];
    5'd6: rdata1 = registers[5];
    5'd7: rdata1 = registers[6];
    5'd8: rdata1 = registers[7];
    5'd9: rdata1 = registers[8];
    5'd10: rdata1 = registers[9];
    5'd11: rdata1 = registers[10];
    5'd12: rdata1 = registers[11];
    5'd13: rdata1 = registers[12];
    5'd14: rdata1 = registers[13];
    5'd15: rdata1 = registers[14];
    5'd16: rdata1 = registers[15];
    5'd17: rdata1 = registers[16];
    5'd18: rdata1 = registers[17];
    5'd19: rdata1 = registers[18];
    5'd20: rdata1 = registers[19];
    5'd21: rdata1 = registers[20];
    5'd22: rdata1 = registers[21];
    5'd23: rdata1 = registers[22];
    5'd24: rdata1 = registers[23];
    5'd25: rdata1 = registers[24];
    5'd26: rdata1 = registers[25];
    5'd27: rdata1 = registers[26];
    5'd28: rdata1 = registers[27];
    5'd29: rdata1 = registers[28];
    5'd30: rdata1 = registers[29];
    5'd31: rdata1 = registers[30];
    default: rdata1 = 32'b0;
  endcase
  case(raddr2)
    5'd0: rdata2 = x0;
    5'd1: rdata2 = registers[0];
    5'd2: rdata2 = registers[1];
    5'd3: rdata2 = registers[2];
    5'd4: rdata2 = registers[3];
    5'd5: rdata2 = registers[4];
    5'd6: rdata2 = registers[5];
    5'd7: rdata2 = registers[6];
    5'd8: rdata2 = registers[7];
    5'd9: rdata2 = registers[8];
    5'd10: rdata2 = registers[9];
    5'd11: rdata2 = registers[10];
    5'd12: rdata2 = registers[11];
    5'd13: rdata2 = registers[12];
    5'd14: rdata2 = registers[13];
    5'd15: rdata2 = registers[14];
    5'd16: rdata2 = registers[15];
    5'd17: rdata2 = registers[16];
    5'd18: rdata2 = registers[17];
    5'd19: rdata2 = registers[18];
    5'd20: rdata2 = registers[19];
    5'd21: rdata2 = registers[20];
    5'd22: rdata2 = registers[21];
    5'd23: rdata2 = registers[22];
    5'd24: rdata2 = registers[23];
    5'd25: rdata2 = registers[24];
    5'd26: rdata2 = registers[25];
    5'd27: rdata2 = registers[26];
    5'd28: rdata2 = registers[27];
    5'd29: rdata2 = registers[28];
    5'd30: rdata2 = registers[29];
    5'd31: rdata2 = registers[30];
    default: rdata2 = 32'd0;
  endcase
end
endmodule
