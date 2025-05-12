module tor (
    input logic unsigned [31:0] addr,addr_n_1,addr_n,
    input logic [1:0]size,
    output logic tor_out
    );
always_comb begin
    if ((addr + size) < addr) begin
        tor_out = 1'b0;
    end 
    else begin
        tor_out = (addr>=addr_n_1) && ((addr+size)< (addr_n));
    end
end
endmodule