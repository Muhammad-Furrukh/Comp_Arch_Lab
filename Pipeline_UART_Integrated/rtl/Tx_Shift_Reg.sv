module Tx_Shift_Reg(
    input logic [7:0] fifo_data,
    input logic       parity_bit,
    input logic       shift_en,
    input logic       load_en,
    input logic       clk,
    input logic       reset,
    output logic      serial_out
);

logic [10:0] Shift_reg;
always_ff @(posedge clk) begin
    if (reset)
      begin Shift_reg <= 11'b11111111110; end
    else if (shift_en && (!load_en)) begin 
      Shift_reg[0] <= Shift_reg[1];
      Shift_reg[1] <= Shift_reg[2];
      Shift_reg[2] <= Shift_reg[3];
      Shift_reg[3] <= Shift_reg[4];
      Shift_reg[4] <= Shift_reg[5];
      Shift_reg[5] <= Shift_reg[6];
      Shift_reg[6] <= Shift_reg[7];
      Shift_reg[7] <= Shift_reg[8];
      Shift_reg[8] <= Shift_reg[9];
      Shift_reg[9] <= Shift_reg[10];
    end
    else if (load_en) begin
      Shift_reg[0] <= 1'b0;
      Shift_reg[1] <= fifo_data[0];
      Shift_reg[2] <= fifo_data[1];
      Shift_reg[3] <= fifo_data[2];
      Shift_reg[4] <= fifo_data[3];
      Shift_reg[5] <= fifo_data[4];
      Shift_reg[6] <= fifo_data[5];
      Shift_reg[7] <= fifo_data[6];
      Shift_reg[8] <= fifo_data[7];
      Shift_reg[9] <= parity_bit;
      Shift_reg[10] <= 1'b1;
    end
end

assign serial_out = Shift_reg[0];
endmodule