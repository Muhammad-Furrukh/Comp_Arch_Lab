module Tx_Baud_Counter(
    input logic  [13:0]  baud_count,
    input logic          count_en,
    input logic          clk,
    input logic          reset,
    output logic [13:0]  baud_count_r
);

always_ff @(posedge clk) begin
    if (reset) begin 
      baud_count_r <= 14'h0000; end
    else if (count_en) begin
      baud_count_r <= baud_count; end
end
endmodule