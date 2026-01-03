module alu (
    input [7:0] INPUT_A,
    input [7:0] INPUT_B,
    input SUB,
    input ENABLE,
    output [7:0] DATA_BUS,
    output CARRY,
    output ZERO
);

    wire [7:0] operand = SUB ? (~INPUT_B + 8'd1) : INPUT_B;
    wire [8:0] sum = {1'b0, INPUT_A} + {1'b0, operand};

    assign CARRY = sum[8];
    assign ZERO = sum[7:0] == 8'd0;
    assign DATA_BUS = ENABLE ? sum[7:0] : {8{1'bz}};

endmodule
