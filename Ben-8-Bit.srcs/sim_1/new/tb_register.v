`timescale 1ns / 1ps

module tb_register ();

    localparam WIDTH = 8;

    reg [WIDTH-1:0] test_data;

    reg CLK;
    reg CLR;
    reg LOAD;
    reg ENABLE;
    wire [WIDTH-1:0] MASK = 8'hff;
    wire [WIDTH-1:0] DATA_BUS = LOAD ? test_data : {WIDTH{1'bz}};
    wire [WIDTH-1:0] DATA;

    register #(
        .WIDTH(8)
    ) register_dut (
        .CLK(CLK),
        .CLR(CLR),
        .LOAD(LOAD),
        .ENABLE(ENABLE),
        .MASK_IN(MASK),
        .MASK_OUT(MASK),
        .DATA_BUS(DATA_BUS),
        .DATA(DATA)
    );

    initial begin
        CLK = 1;
        forever #10 CLK = ~CLK;
    end

    initial begin
        CLR = 1;
        test_data = 8'h55;
        LOAD = 0;
        ENABLE = 0;

        #1;
        #20;

        CLR = 0;
        #20;

        test_data = 8'haa;
        LOAD = 1;
        #20;
        LOAD = 0;
        #20;
        #20;

        ENABLE = 1;
        #40;
        ENABLE = 0;
        #20;

        test_data = 8'h69;
        LOAD = 0;
        #20;
        LOAD = 1;
        #20;

        ENABLE = 1;
        #20;
        ENABLE = 0;
        #20;

        CLR = 1;
        #20;
        CLR = 0;
        #20;

        $stop;

    end

endmodule
