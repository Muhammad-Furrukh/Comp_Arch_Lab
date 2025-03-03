module control_MW(
input logic clk, reset, reg_wr_DE, rd_en_DE, wr_en_DE, [2:0] size_DE, [1:0] wb_sel_DE,
output logic reg_wr_MW, rd_en_MW, wr_en_MW, [2:0] size_MW, [1:0] wb_sel_MW);

always_ff @(posedge clk) begin
    if (reset) begin
        reg_wr_MW <= 0;
        rd_en_MW <= 0; 
        wr_en_MW <= 0; 
        size_MW <= 3'b0; 
        wb_sel_MW <= 2'b0;
    end
    else begin
        reg_wr_MW <= reg_wr_DE;
        rd_en_MW <= rd_en_DE; 
        wr_en_MW <= wr_en_DE; 
        size_MW <= size_DE; 
        wb_sel_MW <= wb_sel_DE;
    end
end
endmodule