`timescale 1ns / 1ps

module tb_top ();

    reg CLK;
    reg RST;
    wire [63:0] GPIO;
    // wire [15:0] control_word = GPIO[47:32];
    // wire carry_flag = GPIO[61];
    // wire zero_flag = GPIO[62];
    wire halt = GPIO[63];
    wire [7:0] REG_O = GPIO[7:0];
    // wire [7:0] REG_A = GPIO[15:8];
    // wire [7:0] REG_B = GPIO[23:16];
    // wire [7:0] BUS = GPIO[31:24];

    top top_dut (
        .CLK50M(CLK),
        .KEY(RST),
        .GPIO(GPIO)
    );

    initial begin
        CLK = 1;
        forever #10 CLK = ~CLK;
    end

    initial begin
        RST = 1;
        #21;
        RST = 0;

        #250000;
        $stop;
    end

    initial begin
        wait (halt == 1);
        #10;
        $stop;
    end

endmodule
