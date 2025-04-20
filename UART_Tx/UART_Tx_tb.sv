module UART_Tx_tb();
logic [31:0]  addr;
logic [13:0]  baud_divisor;
logic [7:0]   raw_data;
logic         wr_en;
logic         rd_en;
logic         clk;
logic         reset;
logic         Tx_en;
logic         Two_stop;
logic         Odd_parity;
logic [31:0]  rdata;
logic         Tx_out;

UART_Tx DUT(
    .addr(.addr),
    .baud_divisor(baud_divisor),
    .raw_data(raw_data),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .clk(clk),
    .reset(reset),
    .Tx_en(Tx_en),
    .Two_stop(Two_stop),
    .Odd_parity(Odd_parity),
    .rdata(rdata),
    .Tx_out(Tx_out)
);

initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1'b1;
end
endmodule