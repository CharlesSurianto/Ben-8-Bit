`timescale 1ns / 1ps

module tb_alu ();

    integer i, j;

    reg [7:0] INPUT_A;
    reg [7:0] INPUT_B;
    reg SUB;
    reg ENABLE;
    wire [7:0] DATA_BUS;
    wire CARRY;
    wire ZERO;

    alu alu_dut (
        .INPUT_A(INPUT_A),
        .INPUT_B(INPUT_B),
        .SUB(SUB),
        .ENABLE(ENABLE),
        .DATA_BUS(DATA_BUS),
        .CARRY(CARRY),
        .ZERO(ZERO)
    );

    initial begin
        INPUT_A = 0;
        INPUT_B = 0;
        SUB = 0;
        ENABLE = 1;

        for (i = 0; i < 256; i = i + 16) begin
            INPUT_A = i;
            for (j = 0; j < 256; j = j + 16) begin
                INPUT_B = j;
                #10;
            end
        end

        SUB = 1;
        for (i = 0; i < 256; i = i + 16) begin
            INPUT_A = i;
            for (j = 0; j < 256; j = j + 16) begin
                INPUT_B = j;
                #10;
            end
        end

        $stop;
    end

endmodule
