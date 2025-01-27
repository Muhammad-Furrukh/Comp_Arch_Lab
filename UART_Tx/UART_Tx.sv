module UART_Tx(input logic clk, rst_n, Tx_en, Two_stop, Odd_parity, [7:0] raw_data,
output logic Tx_out);

parameter BAUD_DIVISOR = 868;
parameter INIT = 3'b000, FIFO_LOAD = 3'b001, READY = 3'b010, TX_START = 3'b011, 
CHANGE_BIT = 3'b100, CONT_BIT = 3'b101;

// Data Lines
logic [7:0] data, fifo_data;
logic [13:0] baud_divisor_r, baud_count;
logic fifo_load, parity_bit, shift_en, load_en, Tx_sel, bit_count, Odd_parity_r, count_en,
Tx_en_r, baud_eq, fifo_status, Two_stop_r, bit_eq, Tx_status;

logic [2:0] c_state, n_state;

// Registers
logic [13:0] Baud_Reg, Baud_Counter;
logic [8:0] Shift_Reg;
logic [7:0] Data_Reg, Tx_FIFO;
logic [3:0] Bit_Counter;
logic [2:0] Control_Reg;
logic FIFO_EMPTY;

// Controller State Register
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    c_state <= INIT;
  else
    c_state <= n_state; 
end

// Controller next state logic
always_comb begin
  case(c_state)
    INIT: begin 
        if (fifo_status)
          n_state = FIFO_LOAD;
        else
          n_state = INIT;
    end
    FIFO_LOAD: begin
        if (Tx_status)
          n_state = FIFO_LOAD;
        else 
          n_state = READY;
    end
    READY: begin
        if (Tx_en_r)
          n_state = TX_START;
        else
          n_state = READY;
    end
    TX_START: begin
        if (baud_eq)
          n_state = CHANGE_BIT;
        else
          n_state = TX_START;
    end
    CHANGE_BIT: begin
        if (bit_eq && fifo_status)
          n_state = FIFO_LOAD;
        else if (bit_eq && (!fifo_status))
          n_state = INIT;
        else
          n_state = CONT_BIT;
    end
    CONT_BIT: begin
        if (bit_eq && fifo_status)
          n_state = FIFO_LOAD;
        else if (bit_eq && (!fifo_status))
          n_state = INIT;
        else if ((!bit_eq) && baud_eq)
          n_state = CHANGE_BIT;
        else
          n_state = CONT_BIT;
    end
    default: n_state = INIT;
  endcase
end

endmodule