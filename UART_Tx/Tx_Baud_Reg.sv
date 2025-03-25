module Tx_Baud_Reg(
    input logic  [14:0]  baud_divisor,
    input logic          clk,
    input logic          reset,
    output logic [14:0]  baud_divisor_r
);
parameter BAUD_DIVISOR = 868; // baud_divisor = 100,000,000/115,200

always_ff @(posedge clk) begin
    if (reset)
      begin baud_divisor_r <= BAUD_DIVISOR; end
    else
      begin baud_divisor_r <= baud_divisor; end
end
endmodule