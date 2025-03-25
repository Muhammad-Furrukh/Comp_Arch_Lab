module Tx_Data_Reg(
    input logic  [7:0]  raw_data,
    input logic         clk,
    input logic         reset,
    output logic [7:0]  data
);

always_ff @(posedge clk) begin
    if (reset)
      begin data <= 8'h00; end
    else
      begin data <= raw_data; end
end
endmodule