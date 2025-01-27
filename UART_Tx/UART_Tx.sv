module UART_Tx(input logic clk, rst_n, Tx_en, Two_stop, Odd_parity, [7:0] raw_data,
output logic Tx_out);

parameter BAUD_DIVISOR = 868;
parameter INIT = 3'b000, FIFO_LOAD = 3'b001, READY = 3'b010, TX_START = 3'b011, 
CHANGE_BIT = 3'b100, CONT_BIT = 3'b101;

logic [7:0] data, fifo_data;
logic [13:0] baud_divisor_r, baud_count;
logic fifo_load, parity_bit, shift_en, load_en, Tx_sel, bit_count;

endmodule