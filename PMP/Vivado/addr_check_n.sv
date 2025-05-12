import cep_define ::*;
module addr_check_n (
    input logic unsigned [31:0]addr,addr_n,addr_n_1,
    input logic [1:0]size,
    input logic [1:0]a_n,
    output logic out
);
logic na4_out,napot_out,tor_out;
tor TOR(.*);
na4 NA4(.*);
napot NAPOT(.*);
always_comb begin
    case (a_n)
       2'b00:out = 1'b0;
       2'b01:out = tor_out;
       2'b10:out = na4_out;
       2'b11:out = napot_out;
       default: out= 1'b0;
    endcase
end

endmodule