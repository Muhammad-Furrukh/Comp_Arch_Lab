module Tx_Baud_Reg(
    input logic  [31:0]  addr,
    input logic  [13:0]  baud_divisor,
    input logic          wr_en,
    input logic          clk,
    input logic          reset,
    output logic [13:0]  baud_divisor_r
);
parameter BAUD_DIVISOR = 868; // baud_divisor = 100,000,000/115,200

always_ff @(posedge clk) begin
    if (reset)
      begin baud_divisor_r <= BAUD_DIVISOR; end
    else if ((wr_en) && (addr == 32'hc))
      begin baud_divisor_r <= baud_divisor; end
end
endmodule