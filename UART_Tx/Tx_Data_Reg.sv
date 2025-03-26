module Tx_Data_Reg(
    input logic  [31:0] addr,
    input logic  [7:0]  raw_data,
    input logic         wr_en,
    input logic         clk,
    input logic         reset,
    output logic [7:0]  data
);

always_ff @(posedge clk) begin
    if (reset) begin 
      data <= 8'h00; end
    else if ((wr_en) && (addr == 32'b0)) begin
      data <= raw_data; end
end
endmodule