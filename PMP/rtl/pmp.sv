module pmp (
    input  logic                 clock, reset, wr_en,
    input  logic          [1:0]  oper, size, priv_mode,
    input  logic unsigned [31:0] addr, rw_addr,
    input  logic          [31:0] wdata,
    output logic          [31:0] rdata,
    output logic          [1:0]  permission
);
    logic unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,  pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,   pmpaddr5_data,
                          pmpaddr6_data,  pmpaddr7_data,  pmpaddr8_data,  pmpaddr9_data,  pmpaddr10_data,  pmpaddr11_data,
                          pmpaddr12_data, pmpaddr13_data, pmpaddr14_data, pmpaddr15_data;
    logic          [31:0] pmpcfg0_data, pmpcfg1_data, pmpcfg2_data, pmpcfg3_data;

    pmp_registers PMP_REG(.*);
    pmp_check PMP_CHECK(.*);
endmodule