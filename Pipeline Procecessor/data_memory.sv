module data_memory(
    input logic clk, reset, wr_en, rd_en, [31:0] addr, wdata, [2:0] size,
    output logic [31:0] rdata
);
logic [7:0] mem [255:0];
logic [31:0] addr_data;
logic [31:0] addr_off;
always_comb begin
  addr_off = addr - 32'h80000000;
  addr_data = {mem[addr_off + 3], mem[addr_off + 2], mem[addr_off + 1], mem[addr_off]};
  if (rd_en) begin
    rdata = addr_data;
  end
  else begin
    rdata = 32'b0;
  end
end

always_ff @(negedge clk) begin
  if (reset) begin
    mem <= '{ 256{8'h0} };
  end
  else if (wr_en) begin
    case(size)
      3'b000: mem [addr_off] <= wdata [7:0];
      3'b001: begin
             mem [addr_off] <= wdata [7:0];
             mem [addr_off + 1] <= wdata [15:8];
      end
      3'b010: begin
             mem [addr_off] <= wdata [7:0];
             mem [addr_off + 1] <= wdata [15:8];
             mem [addr_off + 2] <= wdata [23:16];
             mem [addr_off + 3] <= wdata [31:24];
      end
    endcase
  end
end
endmodule