module DFF(input logic clk, reset, D, output logic Q);
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 0;
    end
    else begin
        Q <= D;
    end
end
endmodule

module pmp (
    input  logic                 clock, reset, wr_en,
    input  logic          [1:0]  oper, size, priv_mode,
    input  logic          [31:0] wdata,
    output logic          [6:0]  segments,
    output logic          [7:0]  an,
    output logic          [1:0]  permission
);
    logic unsigned [31:0] addr, rw_addr;
    logic          [31:0] rdata;
    logic unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,  pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,   pmpaddr5_data,
                          pmpaddr6_data,  pmpaddr7_data,  pmpaddr8_data,  pmpaddr9_data,  pmpaddr10_data,  pmpaddr11_data,
                          pmpaddr12_data, pmpaddr13_data, pmpaddr14_data, pmpaddr15_data;
    logic          [31:0] pmpcfg0_data, pmpcfg1_data, pmpcfg2_data, pmpcfg3_data;
    logic          [3:0]  segment_enc;
    logic          [25:0] clkdiv;
    logic          [25:0] din;

    pmp_registers PMP_REG(.*);
    pmp_check PMP_CHECK(.*);

    //Generating 26 bit clock
    DFF UUT (
        .clk(clock),
        .reset(reset),
        .D(din[0]),
        .Q(clkdiv[0])
    );
    genvar i;
    generate
    for (i = 1; i < 26; i=i+1) begin
        DFF UUT2 (
            .clk(clkdiv[i-1]),
            .reset(reset),
            .D(din[i]),
            .Q(clkdiv[i])
        );
    end
    endgenerate;
    assign din = ~clkdiv;

    always_comb begin
        addr = 32'h00002FFF;
        rw_addr = 32'h00002FFF;

        case(clkdiv[17:15])
            3'b000:  begin an = 8'b11111110; segment_enc = rdata[3:0];   end
            3'b001:  begin an = 8'b11111101; segment_enc = rdata[7:4];   end
            3'b010:  begin an = 8'b11111011; segment_enc = rdata[11:8];  end
            3'b011:  begin an = 8'b11110111; segment_enc = rdata[15:12]; end
            3'b100:  begin an = 8'b11101111; segment_enc = rdata[19:16]; end
            3'b101:  begin an = 8'b11011111; segment_enc = rdata[23:20]; end
            3'b110:  begin an = 8'b10111111; segment_enc = rdata[27:24]; end
            3'b111:  begin an = 8'b01111111; segment_enc = rdata[31:28]; end
            default: begin an = 8'b11111110; segment_enc = 4'b1111;      end
        endcase

        case(segment_enc)
            4'b0000: segments = 7'b0000001;
            4'b0001: segments = 7'b1001111; 
            4'b0010: segments = 7'b0010010;
            4'b0011: segments = 7'b0000110; 
            4'b0100: segments = 7'b1001100; 
            4'b0101: segments = 7'b0100100;
            4'b0110: segments = 7'b0100000;
            4'b0111: segments = 7'b0001111;
            4'b1000: segments = 7'b0000000;
            4'b1001: segments = 7'b0000100;
            4'b1010: segments = 7'b0001000;
            4'b1011: segments = 7'b1100000;
            4'b1100: segments = 7'b0110001;
            4'b1101: segments = 7'b1000010;
            4'b1110: segments = 7'b0110000;
            4'b1111: segments = 7'b0111000;
        endcase
    end
endmodule