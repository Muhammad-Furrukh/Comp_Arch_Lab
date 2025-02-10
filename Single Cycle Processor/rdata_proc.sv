module rdata_proc(
    input logic [31:0] rdata, [2:0] size,
    output logic [31:0] proc_data
);
always_comb begin
  case(size)
    3'b000: begin
      if (rdata[7]) begin
        proc_data = {24'hFFFFFF, rdata[7:0]};
      end
      else begin
        proc_data = {24'h000000, rdata[7:0]};
      end
    end
    3'b001: begin
      if (rdata[15]) begin
        proc_data = {16'hFFFF, rdata[15:0]};
      end
      else begin
        proc_data = {16'h0000, rdata[15:0]};
      end
    end
    3'b100: proc_data = {24'h000000, rdata[7:0]};
    3'b101: proc_data = {16'h0000, rdata[15:0]};
    default: proc_data = rdata;
  endcase
end
endmodule