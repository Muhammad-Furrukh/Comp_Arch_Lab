module na4 (
    input logic unsigned [31:0] addr,addr_n,
    input logic [1:0]size,
    output logic na4_out
    );
always_comb begin
    if ((addr + size) < addr) begin
        na4_out = 1'b0;
    end 
    else begin
        na4_out=(addr>=(addr_n))  && ((addr+size) <= (addr_n+3));
    end
end
endmodule