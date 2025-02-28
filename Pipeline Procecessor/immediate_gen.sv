module immediate_gen(
    input logic u,
    input logic signed [20:0] imm, 
    output logic signed [31:0] out  
);
logic [31:0] li, ui;
always_comb begin
  if ((imm[11]) | (imm[12])) begin
    li = {20'hFFFFF, imm[11:0]};
  end
  else begin
    li = {20'h00000, imm[11:0]};
  end
  ui = {imm[19:0], 12'b0};
  if (u) begin
    out = ui;
  end
  else begin
    out = li;
  end
end
endmodule