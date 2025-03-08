module instr_fetch_reg(input logic clk, reset, b_or_j,
input logic signed [31:0] D,
output logic signed [31:0] Q);

always_ff @(posedge clk) begin
    if (reset) begin
        Q <= 32'b0;
    end
    else if (b_or_j) begin
        Q <= 32'h00000013;
    end
    else begin
        Q <= D;
    end
end
endmodule