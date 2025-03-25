module UART_Tx(
  input logic [31:0] addr,
  input logic [13:0] baud_divisor,
  input logic [7:0]  raw_data;
  input logic        wr_en;
  input logic        rd_en;
  input logic        clk,
  input logic        rst_n,
  input logic        Tx_en,
  input logic        Two_stop,
  input logic        Odd_parity,
  output logic       Tx_out);

parameter BAUD_DIVISOR = 868; // baud_divisor = 100,000,000/115,200
parameter INIT = 3'b000, CONFIGURED = 3'b001, FIFO_LOAD = 3'b010, TX_START = 3'b011, 
CHANGE_BIT = 3'b100, CONT_BIT = 3'b101;


// Controller Output Signals
logic Tx_sel;
logic shift_rst;
logic load_en;
logic shift_en;
logic count_en;
logic fifo_load;
logic data_status;

// Controller Input Signals
logic Tx_en_r;
logic fifo_full;
logic baud_eq;
logic fifo_empty;
logic bit_eq;
logic control_status;
logic config_en;

// Controller States
logic [2:0] c_state;
logic [2:0] n_state;

// Signal Lines
logic [13:0] baud_divisor_r;
logic [13:0] baud_count;
logic [7:0]  data; 
logic [7:0]  fifo_data;
logic [3:0]  fifo_count_r;
logic [3:0]  fifo_count_plus;
logic [3:0]  fifo_count_sub;
logic [1:0]  fifo_count_sel;
logic        parity_bit;
logic        bit_count;
logic        Odd_parity_r;
logic        Two_stop_r;
logic        serial_out;
logic        baud_configured

// Registers
logic [13:0] Baud_Reg;
logic [13:0] Baud_Counter;
logic [10:0] Shift_Reg;
logic [7:0]  Data_Reg;
logic [7:0]  Tx_FIFO;
logic [3:0]  Bit_Counter;
logic [3:0]  FIFO_Count;
logic [2:0]  Control_Reg;
logic        Status_Reg;

// Controller State Register
always_ff @(posedge clk or posedge rst_n) begin
  if (rst_n)
    begin c_state <= INIT; end
  else
    begin c_state <= n_state; end
end

// Controller next state logic
always_comb begin
  case(c_state)
    INIT: begin 
        if ((control_status) && (baud_configured)) begin         // Are control and baud registers configured?
          n_state = CONFIGURED; end
        else begin 
          n_state = INIT; end
    end
    CONFIGURED: begin
        if ((Tx_en_r) && (wr_en) && (addr == 32'b0)) begin        // Is data available? Tx enabled? FIFO is empty(assumed)
          n_state = FIFO_LOAD; end
        else begin 
          n_state = CONFIGURED; end
    end
    FIFO_LOAD: begin
        if ((Tx_en_r) && (!fifo_empty)) begin                   // Is the tranmitter enabled?
          n_state = TX_START; end
        else begin 
          n_state = FIFO_LOAD; end
    end
    TX_START: begin
        if (baud_eq) begin                                      // One baud cycle has passed?
          n_state = CHANGE_BIT; end
        else begin 
          n_state = TX_START; end
    end
    CHANGE_BIT: begin
        n_state = CONT_BIT;
    end
    CONT_BIT: begin
        if ((!bit_eq) && (baud_eq)) begin 
          n_state = CHANGE_BIT; end
        else if ((bit_eq) && (!fifo_empty)) begin 
          n_state = TX_START; end
        else if ((bit_eq) && (fifo_empty) && (!Tx_en)) begin 
          n_state = INIT; end
        else if ((bit_eq) && (fifo_empty) && (Tx_en)) begin 
          n_state = FIFO_LOAD; end
        else begin 
          n_state = CONT_BIT; end
    end
    default: n_state = INIT;
  endcase
end

// Controller Output Logic
always_comb begin
  case(c_state)
    INIT: begin
        fifo_load = 0; count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0; data_status = 0;
        if ((control_status) && (baud_configured)) begin
          config_en = 0; end
        else begin
          config_en = 1; end
    end
    CONFIGURED: begin
        count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 0; config_en = 0;
        if ((Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 1; data_status = 0;
        end
        else if ((!Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 0; data_status = 1;
        end
        else begin
            fifo_load = 0; data_status = 0;
        end
    end
    FIFO_LOAD: begin 
        shift_en = 0; shift_rst = 0; config_en = 0;
        if ((!Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 0; count_en = 0; load_en = 0; Tx_sel = 0; data_status = 1;
        end
        else if ((!Tx_en_r)) begin
            fifo_load = 0; count_en = 0; load_en = 0; Tx_sel = 0; data_status = 0;
        end
        else if ((!fifo_empty) && (((wr_en) && (addr == 32'b0)) || data_status)) begin          // Even if FIFO is full, 8 bits will be removed, so fifo can load data
            fifo_load = 1; count_en = 1; load_en = 1; Tx_sel = 1; data_status = 0;
        end
        else if ((!fifo_empty)) begin
            fifo_load = 0; count_en = 1; load_en = 1; Tx_sel = 1; data_status = 0;
        end
        else if ((((wr_en) && (addr == 32'b0)) || data_status)) begin
            fifo_load = 1; count_en = 0; load_en = 0; Tx_sel = 0; data_status = 0;
        end
        else begin
            fifo_load = 0; count_en = 0; load_en = 0; Tx_sel = 0; data_status = 0;
        end
    end
    TX_START: begin
        count_en = 1; load_en = 0; Tx_sel = 1; shift_rst = 0; config_en = 0;
        if (baud_eq) begin
            shift_en = 1; 
        end
        else begin
            shift_en = 0;
        end

        // FIFO LOADING LOGIC
        if ((!Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 0; data_status = 1;
        end
        else if ((!Tx_en_r)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((!fifo_empty) && (((wr_en) && (addr == 32'b0)) || data_status)) begin          // Even if FIFO is full, 8 bits will be removed, so fifo can load data
            fifo_load = 1; data_status = 0;
        end
        else if ((!fifo_empty)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((((wr_en) && (addr == 32'b0)) || data_status)) begin
            fifo_load = 1; data_status = 0;
        end
        else begin
            fifo_load = 0; data_status = 0;
        end
    end
    CHANGE_BIT: begin
        count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; shift_rst = 0; config_en = 0;
        
        // FIFO LOADING LOGIC
        if ((!Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 0; data_status = 1;
        end
        else if ((!Tx_en_r)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((!fifo_empty) && (((wr_en) && (addr == 32'b0)) || data_status)) begin          // Even if FIFO is full, 8 bits will be removed, so fifo can load data
            fifo_load = 1; data_status = 0;
        end
        else if ((!fifo_empty)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((((wr_en) && (addr == 32'b0)) || data_status)) begin
            fifo_load = 1; data_status = 0;
        end
        else begin
            fifo_load = 0; data_status = 0;
        end
    end
    CONT_BIT: begin
        config_en = 0;
        if ((bit_eq) && (!fifo_empty)) begin
            count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; shift_rst = 1;
        end
        else if (baud_eq) begin
            count_en = 1; shift_en = 1; load_en = 0; Tx_sel = 1; shift_rst = 0;
        end
        else begin
            count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; shift_rst = 0;
        end

        // FIFO LOADING LOGIC
        if ((!Tx_en_r) && (wr_en) && (addr == 32'b0)) begin
            fifo_load = 0; data_status = 1;
        end
        else if ((!Tx_en_r)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((!fifo_empty) && (((wr_en) && (addr == 32'b0)) || data_status)) begin          // Even if FIFO is full, 8 bits will be removed, so fifo can load data
            fifo_load = 1; data_status = 0;
        end
        else if ((!fifo_empty)) begin
            fifo_load = 0; data_status = 0;
        end
        else if ((((wr_en) && (addr == 32'b0)) || data_status)) begin
            fifo_load = 1; data_status = 0;
        end
        else begin
            fifo_load = 0; data_status = 0;
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