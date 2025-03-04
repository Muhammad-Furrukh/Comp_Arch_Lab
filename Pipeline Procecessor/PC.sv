module PC(input logic reset, clk, [31:0] d, output logic [31:0] q);
  always_ff @(posedge clk) begin
    if (reset) begin
      q <= 0;
    end
    else begin
      q <= d;
    end
  end
endmodule
