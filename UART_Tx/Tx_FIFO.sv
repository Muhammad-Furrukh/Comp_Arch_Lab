module Tx_FIFO(
    input logic  [7:0] data,
    input logic  [3:0] pointer,
    input logic        clk,
    input logic        reset,
    input logic        fifo_load,
    output logic [7:0] fifo_data
);

logic [7:0] fifo [7:0];
endmodule