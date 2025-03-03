module register(input logic clk, reset, 
input logic signed [31:0] D,
output logic signed [31:0] Q);

always_ff @(posedge clk) begin
    if (reset) begin
        Q <= 32'b0;
    end
    else begin
        Q <= D;
    end
end
endmodule