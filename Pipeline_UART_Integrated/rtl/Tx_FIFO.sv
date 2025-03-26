module Tx_FIFO(
    input logic  [7:0] data,
    input logic  [3:0] pointer,
    input logic        clk,
    input logic        reset,
    input logic        fifo_load,
    input logic        load_en,
    output logic [7:0] fifo_data
);

logic [7:0] fifo [7:0];
always_ff @(posedge clk) begin
    if (reset) begin
        fifo <= '{ 8{8'hxx} };
    end
    else if (load_en) begin
        fifo[pointer] <= 8'hxx;
    end
    else if (fifo_load) begin
        fifo[7] <= fifo[6];
        fifo[6] <= fifo[5];
        fifo[5] <= fifo[4];
        fifo[4] <= fifo[3];
        fifo[3] <= fifo[2];
        fifo[2] <= fifo[1];
        fifo[1] <= fifo[0];
        fifo[0] <= data;
    end
end

always_comb begin
    fifo_data = fifo[pointer];
end
endmodule