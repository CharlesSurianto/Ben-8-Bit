`timescale 1ns / 1ps

module tb_counter ();

    localparam WIDTH = 4;

    reg [WIDTH-1:0] test_data;

    reg CLK;
    reg RST;
    reg ZERO;
    reg COUNT;
    reg LOAD;
    reg ENABLE;
    wire [WIDTH-1:0] MASK = 8'hff;
    wire [WIDTH-1:0] DATA_BUS = LOAD ? test_data : {WIDTH{1'bz}};

    counter #(
        .WIDTH(WIDTH)
    ) counter_dut (
        .CLK(CLK),
        .RST(RST),
        .ZERO(ZERO),
        .COUNT(COUNT),
        .LOAD(LOAD),
        .ENABLE(ENABLE),
        .MASK_IN(MASK),
        .MASK_OUT(MASK),
        .DATA_BUS(DATA_BUS)
    );

    initial begin
        CLK = 1;
        forever #10 CLK = ~CLK;
    end

    initial begin
        RST = 1;
        ZERO = 0;
        COUNT = 0;
        LOAD = 0;
        ENABLE = 1;
        test_data = 0;

        #1;
        #20;

        RST = 0;
        #20;

        COUNT = 1;
        #100;

        COUNT = 0;
        ZERO  = 1;
        #20;

        ZERO = 0;
        #20;

        COUNT = 1;
        #200;

        ENABLE = 0;
        #40;

        COUNT = 0;
        LOAD = 1;
        test_data = 4'h3;
        #20;

        LOAD = 0;
        #20;

        ENABLE = 1;
        COUNT  = 1;
        #320;

        $stop;
    end

endmodule
