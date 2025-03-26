module Tx_Bit_Counter(
    input logic  [3:0]  bit_count,
    input logic         count_en,
    input logic         clk,
    input logic         reset,
    output logic [3:0]  bit_count_r
);

always_ff @(posedge clk) begin
    if (reset) begin 
      bit_count_r <= 4'h0; end
    else if (count_en) begin
      bit_count_r <= bit_count; end
end
endmodule