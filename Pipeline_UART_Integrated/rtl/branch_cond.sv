module branch_cond(
    input logic signed [31:0] rdata1, rdata2, 
    input logic [2:0] br_type,
    output logic br_taken
);
logic [31:0] urdata1, urdata2;
always_comb begin
  if (rdata1 < 0)
    urdata1 = (rdata1 ^ 32'hFFFFFF) + 1;
  else
    urdata1 = rdata1;
  if (rdata2 < 0)
    urdata2 = (rdata2 ^ 32'hFFFFFF) + 1;
  else
    urdata2 = rdata2;
  case(br_type)
    3'b000: begin
      if (rdata1 == rdata2)
        br_taken = 1'b1;
      else
        br_taken = 1'b0;
    end
    3'b001: begin
      if (rdata1 != rdata2)
        br_taken = 1'b1;
      else
        br_taken = 1'b0;
    end
    3'b010: begin
      if (rdata1 < rdata2)
        br_taken = 1'b1;
      else
        br_taken = 1'b0;
    end
    3'b011: begin
      if (rdata1 >= rdata2)
        br_taken = 1'b1;
      else
        br_taken = 1'b0;
    end
    3'b100: begin
      if (urdata1 < urdata2)
        br_taken = 1'b1;
      else 
        br_taken = 1'b0;
    end
    3'b101: begin
      if (urdata1 >= urdata2)
        br_taken = 1'b1;
      else 
        br_taken = 1'b0;
    end
    default: br_taken = 1'b0;
  endcase
end
endmodule