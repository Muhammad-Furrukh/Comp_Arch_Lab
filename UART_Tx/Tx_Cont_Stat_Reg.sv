module Tx_Cont_Stat_Reg(
    input logic        clk,
    input logic        reset,
    input logic        Tx_en,
    input logic        Two_stop,
    input logic        Odd_parity, 
    input logic        wr_en,
    input logic [31:0] addr,
    output logic       Tx_en_r,
    output logic       Two_stop_r,
    output logic       Odd_parity_r,
    output logic       control_status
);

logic [7:0] CS_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        CS_reg <= 8'h00;
    end
    else if ((wr_en) && (addr == 32'h4)) begin
        CS_reg[0] <= Tx_en;
        CS_reg[1] <= Two_stop;
        CS_reg[2] <= Odd_parity;
    end
    if ((wr_en) && (addr == 32'h4)) begin
        CS_reg[4] <= 1'b1;
    end
end

always_comb begin
    Tx_en_r = CS_reg[0];
    Two_stop_r = CS_reg[1];
    Odd_parity_r = CS_reg[2];
    control_status = CS_reg[4];
end

endmodule