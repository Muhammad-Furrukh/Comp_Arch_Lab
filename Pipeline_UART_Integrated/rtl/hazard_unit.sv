module hazard_unit(
    input logic [31:0] instr_DE, instr_MW,
    output logic r1_sel, r2_sel
);

logic [4:0] rs1, rs2, rd;

always_comb begin
    // Extracting operand addresses from decoded instruction
    if ((instr_DE[6:0] == 51) || (instr_DE[6:0] == 35)  || (instr_DE[6:0] == 99)) begin
        rs1 = instr_DE[19:15];
        rs2 = instr_DE[24:20];
    end
    else if ((instr_DE[6:0] == 3) || (instr_DE[6:0] == 19) || (instr_DE[6:0] == 103)) begin
        rs1 = instr_DE[19:15];
        rs2 = 5'bx;
    end
    else begin
        rs1 = 5'bx;
        rs2 = 5'bx;
    end
    // Extracting operand address, which is to be written or loaded from Memory-Writeback phase
    if ((instr_MW[6:0] == 35) || (instr_MW[6:0] == 99)) begin
        rd = 5'bx;
    end
    else begin
        rd = instr_MW[11:7];
    end

    // Generating selection signals
    if (rs1 == rd) begin
        r1_sel = 1'b1;
    end
    else begin
        r1_sel = 1'b0;
    end

    if (rs2 == rd) begin
        r2_sel = 1'b1;
    end
    else begin
        r2_sel = 1'b0;
    end
end
endmodule