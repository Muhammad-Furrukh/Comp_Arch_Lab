module UART_Tx(input logic clk, rst_n, Tx_en, Two_stop, Odd_parity, [7:0] raw_data,
output logic Tx_out);

parameter BAUD_DIVISOR = 868;
parameter INIT = 3'b000, FIFO_LOAD = 3'b001, READY = 3'b010, TX_START = 3'b011, 
CHANGE_BIT = 3'b100, CONT_BIT = 3'b101;

// Signal Lines
logic [7:0] data, fifo_data;
logic [13:0] baud_divisor_r, baud_count;
logic fifo_load, parity_bit, shift_en, load_en, Tx_sel, bit_count, Odd_parity_r, count_en,
Tx_en_r, baud_eq, fifo_status, Two_stop_r, bit_eq, Tx_status, shift_rst, serial_out;

logic [2:0] c_state, n_state;

// Registers
logic [13:0] Baud_Reg, Baud_Counter;
logic [10:0] Shift_Reg;
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

// Controller Output Logic
always_comb begin
  case(c_state)
    INIT: begin
        if (fifo_status) begin
            fifo_load = 1; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
        else begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
    end
    FIFO_LOAD: begin
        if (Tx_status) begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
        else begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 1; Tx_sel = 0; shift_rst = 0;
        end
    end
    READY: begin
        if (Tx_en_r) begin
            fifo_load = 0; count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; shift_rst = 0;
        end
        else begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
    end
    TX_START: begin
        if (baud_eq) begin
            fifo_load = 0; count_en = 1; shift_en = 1; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
        else begin
            fifo_load = 0; count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
    end
    CHANGE_BIT: begin
        if (bit_eq && fifo_status) begin
            fifo_load = 1; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 1;
        end
        else if (bit_eq && (!fifo_status)) begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 1;
        end
        else begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
    end
    CONT_BIT: begin
        if (bit_eq && fifo_status) begin
            fifo_load = 1; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 1;
        end
        else if (bit_eq && (!fifo_status)) begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 1;
        end
        else if ((!bit_eq) && baud_eq) begin
            fifo_load = 0; count_en = 0; shift_en = 1; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
        else begin
            fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
        end
    end
    default: fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0;
  endcase
end

// Data Register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      Data_Reg <= 8'h00;
    else
      Data_Reg <= raw_data;
end

// Transmission FIFO
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || load_en)
      Tx_FIFO <= 8'h00;
    else if (fifo_load)
      Tx_FIFO <= data;
end

// FIFO Status Register
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || load_en)
      FIFO_EMPTY <= 1;
    else if (fifo_load)
      FIFO_EMPTY <= 0;
end

// Shift Register
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || shift_rst)
      Shift_Reg <= 11'b11111111110;
    else if (shift_en && (!load_en))
      Shift_Reg <= (Shift_Reg>>1) 
    else if (load_en)
      Shift[0] = 1'b0;
      Shift[1] = fifo_data[0];
      Shift[2] = fifo_data[1];
      Shift[3] = fifo_data[2];
      Shift[4] = fifo_data[3];
      Shift[5] = fifo_data[4];
      Shift[6] = fifo_data[5];
      Shift[7] = fifo_data[6];
      Shift[8] = fifo_data[7];
      Shift[9] = parity_bit;
      Shift[10] = 1'b1;
end

always_comb begin
    // Parity Generator
    case(Odd_parity_r)
      1'b0: parity_bit = ^fifo_data;
      1'b1: parity_bit = ~(^fifo_data);
    endcase
end
endmodule