module UART_Tx(
  input logic [31:0]  addr,
  input logic [13:0]  baud_divisor,
  input logic [7:0]   raw_data,
  input logic         wr_en,
  input logic         rd_en,
  input logic         clk,
  input logic         reset,
  input logic         Tx_en,
  input logic         Two_stop,
  input logic         Odd_parity,
  output logic [31:0] rdata, 
  output logic        Tx_out);

parameter INIT = 3'b000, CONFIGURED = 3'b001, SHIFT_LOAD = 3'b010, TX_START = 3'b011, 
CHANGE_BIT = 3'b100, CONT_BIT = 3'b101, TX_STOP = 3'b110;


// Controller Output Signals
logic Tx_sel;
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

// Controller States
logic [2:0] c_state;
logic [2:0] n_state;

// Signal Lines
logic [31:0] mem [5:0];
logic [13:0] baud_divisor_r;
logic [13:0] baud_count;
logic [13:0] baud_count_r;
logic [7:0]  data; 
logic [7:0]  fifo_data;
logic [3:0]  fifo_count_r;
logic [3:0]  fifo_count_plus;
logic [3:0]  fifo_count_sub;
logic [3:0]  fifo_count;
logic [3:0]  bit_count;
logic [3:0]  bit_count_r;
logic [1:0]  fifo_count_sel;
logic        parity_bit;
logic        Odd_parity_r;
logic        Two_stop_r;
logic        serial_out;
logic        baud_configured;
logic        baud_eq_or_reset;
logic        bit_eq_or_reset;
logic        data_status_delay;

// Data Register
Tx_Data_Reg Tx_Data_Reg(.clk(clk), .reset(reset), .raw_data(raw_data), .data(data), .addr(addr), .wr_en(wr_en));

// Baud Divisor Register
Tx_Baud_Reg Tx_Baud_Reg(.clk(clk), .reset(reset), .baud_divisor(baud_divisor), .baud_divisor_r(baud_divisor_r), 
.addr(addr), .wr_en(wr_en));

// Transmission FIFO
Tx_FIFO Tx_FIFO(.clk(clk), .reset(reset), .data(data), .pointer(fifo_count_sub), .fifo_load(fifo_load),
.load_en(load_en), .fifo_data(fifo_data));

// FIFO Count Register
Tx_FIFO_Count_Reg Tx_FIFO_Count_Reg(.clk(clk), .reset(reset), .fifo_count(fifo_count),
.fifo_count_r(fifo_count_r));

// Control and Status Register
Tx_Cont_Stat_Reg Tx_Cont_Stat_Reg(.clk(clk), .reset(reset), .addr(addr), .wr_en(wr_en), .Tx_en(Tx_en),
.Two_stop(Two_stop), .Odd_parity(Odd_parity), .Tx_en_r(Tx_en_r), .Two_stop_r(Two_stop_r),
.Odd_parity_r(Odd_parity_r), .control_status(control_status));

// Baud Counter
Tx_Baud_Counter Tx_Baud_Counter(.clk(clk), .reset(baud_eq_or_reset), .baud_count(baud_count), .count_en(count_en), 
.baud_count_r(baud_count_r));

// Bit Counter
Tx_Bit_Counter Tx_Bit_Counter(.clk(clk), .reset(bit_eq_or_reset), .bit_count(bit_count), .count_en(baud_eq), 
.bit_count_r(bit_count_r));

// Shift Register
Tx_Shift_Reg Tx_Shift_Reg(.clk(clk), .reset(reset), .fifo_data(fifo_data), .parity_bit(parity_bit), 
.shift_en(shift_en), .load_en(load_en), .serial_out(serial_out));


// Controller State Register
always_ff @(posedge clk) begin
  if (reset) begin
    c_state <= INIT;
    end
  else begin 
    c_state <= n_state; 
    data_status_delay <= data_status;
  end
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
        if ((Tx_en_r) && (data_status)) begin                   // Is data available? Tx enabled? FIFO is empty(assumed)
          n_state = SHIFT_LOAD; end
        else begin 
          n_state = CONFIGURED; end
    end
    SHIFT_LOAD: begin
        if ((Tx_en_r) && (!fifo_empty)) begin                    // Is the tranmitter enabled?
          n_state = TX_START; end
        else begin 
          n_state = SHIFT_LOAD; end
    end
    TX_START: begin
        if (baud_eq) begin                                       // One baud cycle has passed?
          n_state = CHANGE_BIT; end
        else begin 
          n_state = TX_START; end
    end
    CHANGE_BIT: begin
      if (bit_eq) begin
        n_state = TX_STOP; end
      else begin
          n_state = CONT_BIT; end
    end
    CONT_BIT: begin
        if ((!bit_eq) && (baud_eq)) begin 
          n_state = CHANGE_BIT; end
        else if (bit_eq) begin 
          n_state = TX_STOP; end
        else begin 
          n_state = CONT_BIT; end
    end
    TX_STOP: begin
        if ((baud_eq) && (!fifo_empty)) begin 
          n_state = TX_START; end
        else if ((baud_eq) && (fifo_empty) && (!Tx_en)) begin 
          n_state = INIT; end
        else if ((baud_eq) && (fifo_empty) && (Tx_en)) begin 
          n_state = SHIFT_LOAD; end
        else begin
          n_state = TX_STOP; end
    end
    default: n_state = INIT;
  endcase
end

// Controller Output Logic
always_comb begin
  case(c_state)
    INIT: begin
        count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0;
    end
    CONFIGURED: begin
        count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0;
    end
    SHIFT_LOAD: begin 
        shift_en = 0;
        if ((!Tx_en_r)) begin
            count_en = 0; load_en = 0; Tx_sel = 0;
        end
        else if ((!fifo_empty)) begin
            count_en = 0; load_en = 1; Tx_sel = 0;
        end
        else begin
            count_en = 0; load_en = 0; Tx_sel = 0;
        end
    end
    TX_START: begin
        count_en = 1; load_en = 0; Tx_sel = 1;
        if (baud_eq) begin
            shift_en = 1; 
        end
        else begin
            shift_en = 0;
        end
    end

    CHANGE_BIT: begin
        count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1;
    end
    CONT_BIT: begin
        if (bit_eq) begin
            count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; 
        end 
        else if ((!bit_eq) && (baud_eq)) begin
            count_en = 1; shift_en = 1; load_en = 0; Tx_sel = 1; 
        end
        else begin
            count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; 
        end
    end
    TX_STOP: begin
        if ((baud_eq) && (!fifo_empty)) begin 
            count_en = 0; shift_en = 0; load_en = 1; Tx_sel = 0; end
        else if ((baud_eq) && (fifo_empty)) begin
            count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; end
        else begin
            count_en = 1; shift_en = 0; load_en = 0; Tx_sel = 1; end
    end 
    default: begin count_en = 0; shift_en = 0; load_en = 0; Tx_sel = 0; end
  endcase

    // Data Status LOGIC
    if ((wr_en) && (addr == 32'b0)) begin
        data_status = 1;
    end
    else if (fifo_load) begin
        data_status = 0;
    end

    // FIFO LOADING LOGIC
    if (!Tx_en_r) begin
        fifo_load = 0;
    end
    else if ((!fifo_full) && (data_status_delay)) begin          // Even if FIFO is full, 8 bits will be removed, so fifo can load data
        fifo_load = 1;
    end
    else begin
        fifo_load = 0;
    end
end


always_comb begin
    // Parity Generator
    case(Odd_parity_r)
      1'b0: parity_bit = ^fifo_data;
      1'b1: parity_bit = ~(^fifo_data);
    endcase

    // FIFO Counts
    fifo_count_plus = fifo_count_r + 1;
    fifo_count_sub = fifo_count_r - 1;
    fifo_count_sel = {load_en, fifo_load};
    case(fifo_count_sel)
    2'b00: fifo_count = fifo_count_r;
    2'b01: fifo_count = fifo_count_plus;
    2'b10: fifo_count = fifo_count_sub;
    default: fifo_count = fifo_count_r;
    endcase

    fifo_empty = (fifo_count_r == 0);
    fifo_full = (fifo_count_r == 8);

    // Baud Counts
    baud_configured = (baud_divisor_r != 0);

    baud_count = baud_count_r + 1;

    baud_eq = (baud_count_r == (baud_divisor_r - 1)); 

    baud_eq_or_reset = baud_eq | reset;
    // Bit Counter Output
    bit_count = bit_count_r + 1;

    // Bit equal to comparator
    if (Two_stop_r)
      begin bit_eq = (bit_count == 12); end
    else
      begin bit_eq = (bit_count == 11); end

    bit_eq_or_reset = bit_eq || reset;

    // Tx Output
    if (Tx_sel) begin
      Tx_out = serial_out;
    end
    else begin
      Tx_out = 1'b1;
    end

end

always_comb begin
    // Reading Registers
    mem [0] = {24'b0, data};
    mem [1] = {29'b0, Odd_parity_r, Two_stop_r, Tx_en_r};
    mem [2] = {31'b0, control_status};
    mem [3] = {18'b0, baud_divisor_r};
    mem [4] = {18'b0, baud_count_r};
    mem [5] = {28'b0, bit_count_r};
    if (rd_en) begin
      rdata = mem[addr/4];
    end
end
endmodule