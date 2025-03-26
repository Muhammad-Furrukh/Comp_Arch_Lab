module Tx_FIFO_Count_Reg(
    input logic  [3:0]  fifo_count,
    input logic         clk,
    input logic         reset,
    output logic [3:0]  fifo_count_r
);

always_ff @(posedge clk) begin
    if (reset)
      begin fifo_count_r <= 4'h0; end
    else
      begin fifo_count_r <= fifo_count; end
end
endmodule