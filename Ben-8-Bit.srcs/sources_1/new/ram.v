module ram #(
    parameter WIDTH = 8,
    parameter SIZE  = 16
) (
    input CLK,
    input LOAD,
    input ENABLE,
    input [$clog2(SIZE)-1:0] ADDR,
    inout [WIDTH-1:0] DATA_BUS
);

    wire [WIDTH-1:0] mem;

    ram_ip ram_ip_inst (
        .a  (ADDR),
        .d  (DATA_BUS),
        .clk(CLK),
        .we (LOAD),
        .spo(mem)
    );

    assign DATA_BUS = ENABLE ? mem : {WIDTH{1'bz}};

endmodule
