module UART_Tx(input logic clk, rst_n, Tx_en, Two_stop, Odd_parity, [7:0] raw_data, //[13:0] baud_divisor,
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
    begin c_state <= INIT; end
  else
    begin c_state <= n_state; end
end

// Controller next state logic
always_comb begin
  case(c_state)
    INIT: begin 
        if (fifo_status)
          begin n_state = FIFO_LOAD; end
        else
          begin n_state = INIT; end
    end
    FIFO_LOAD: begin
        if (Tx_status)
          begin n_state = FIFO_LOAD; end
        else 
          begin n_state = READY; end
    end
    READY: begin
        if (Tx_en_r)
          begin n_state = TX_START; end
        else
          begin n_state = READY; end
    end
    TX_START: begin
        if (baud_eq)
          begin n_state = CHANGE_BIT; end
        else
          begin n_state = TX_START; end
    end
    CHANGE_BIT: begin
        if (bit_eq && fifo_status)
          begin n_state = FIFO_LOAD; end
        else if (bit_eq && (!fifo_status))
          begin n_state = INIT; end
        else
          begin n_state = CONT_BIT; end
    end
    CONT_BIT: begin
        if (bit_eq && fifo_status)
          begin n_state = FIFO_LOAD; end
        else if (bit_eq && (!fifo_status))
          begin n_state = INIT; end
        else if ((!bit_eq) && baud_eq)
          begin n_state = CHANGE_BIT; end
        else
          begin n_state = CONT_BIT; end
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
    default: begin fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0; end
  endcase
end

// Data Register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      begin Data_Reg <= 8'h00; end
    else
      begin Data_Reg <= raw_data; end
end

// Transmission FIFO
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || load_en)
      begin Tx_FIFO <= 8'h00; end
    else if (fifo_load)
      begin Tx_FIFO <= data; end
end

// FIFO Status Register
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || load_en)
      begin FIFO_EMPTY <= 1; end
    else if (fifo_load)
      begin FIFO_EMPTY <= 0; end
end

// Shift Register
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || shift_rst)
      begin Shift_Reg <= 11'b11111111110; end
    else if (shift_en && (!load_en))
      begin Shift_Reg <= (Shift_Reg>>1); end
    else if (load_en) begin
      Shift_Reg[0] <= 1'b0;
      Shift_Reg[1] <= fifo_data[0];
      Shift_Reg[2] <= fifo_data[1];
      Shift_Reg[3] <= fifo_data[2];
      Shift_Reg[4] <= fifo_data[3];
      Shift_Reg[5] <= fifo_data[4];
      Shift_Reg[6] <= fifo_data[5];
      Shift_Reg[7] <= fifo_data[6];
      Shift_Reg[8] <= fifo_data[7];
      Shift_Reg[9] <= parity_bit;
      Shift_Reg[10] <= 1'b1;
    end
end

// Control Register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      begin Control_Reg <= 3'b000; end
    else if (!Tx_sel) begin
        Control_Reg[0] <= Tx_en;
        Control_Reg[1] <= Two_stop;
        Control_Reg[2] <= Odd_parity;
    end
      
end

// Baud Divisor Register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      begin Baud_Reg = 867; end // Default Baudrate of 115200
    else if (!Tx_sel)
      // Baud_Reg = baud_divisor;
      begin Baud_Reg = 867; end
end

// Baud Counter
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || baud_eq)
      begin Baud_Counter = 14'b00000000000000; end
    else if (count_en)
      begin Baud_Counter = Baud_Counter + 1; end
end

// Bit Counter
always_ff @(posedge clk or negedge rst_n) begin
    if ((!rst_n) || bit_eq)
      begin Bit_Counter = 4'h0; end
    else if (baud_eq)
      begin Bit_Counter = Bit_Counter + 1; end
end

always_comb begin
    // Data register Output
    data = Data_Reg;

    // Tx FIFO Output
    fifo_data = Tx_FIFO;

    // Parity Generator
    case(Odd_parity_r)
      1'b0: parity_bit = ^fifo_data;
      1'b1: parity_bit = ~(^fifo_data);
    endcase

    // Shift register Output
    serial_out = Shift_Reg[0];

    //FIFO_EMPTY Output
    fifo_status = FIFO_EMPTY;

    // Control Register outputs
    Tx_en_r = Control_Reg[0];
    Two_stop_r = Control_Reg[1];
    Odd_parity_r = Control_Reg[2];

    // Baud Divisor Register output
    baud_divisor_r = Baud_Reg;

    // Baud Counter output
    baud_count = Baud_Counter;

    // Baud equal to comparator output
    baud_eq = (baud_count == baud_divisor_r); 

    // Bit Counter Output
    bit_count = Bit_Counter;

    // Bit equal to comparator
    if (Two_stop_r)
      begin bit_eq = (bit_count == 12); end
    else
      begin bit_eq = (bit_count == 11); end

    Tx_status = (bit_count != 0);

end
endmodule