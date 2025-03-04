import header_pkg::*;

module tb();
logic clk, reset;

PMCP DUT(
    .clk(clk), .reset(reset)
);

initial begin
$dumpfile("SCP.vcd");
$dumpvars(0, tb);
end
initial begin
clk = 1'b1;
forever #5 clk = ~clk;
end

initial begin
reset = 1'b1;
@(posedge clk)
reset = 1'b0;
end
endmodule