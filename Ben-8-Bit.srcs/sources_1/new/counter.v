module counter #(
    parameter WIDTH = 4
) (
    input CLK,
    input RST,
    input ZERO,
    input COUNT,
    input LOAD,
    input ENABLE,
    input [WIDTH-1:0] MASK_IN,
    input [WIDTH-1:0] MASK_OUT,
    inout [WIDTH-1:0] DATA_BUS
);

    reg [WIDTH-1:0] counter;

    assign DATA_BUS = ENABLE ? counter & MASK_OUT : {WIDTH{1'bz}};

    always @(posedge CLK or posedge RST) begin
        if (RST) counter <= {WIDTH{1'b0}};
        else if (ZERO) counter <= {WIDTH{1'b0}};
        else if (LOAD) counter <= DATA_BUS & MASK_IN;
        else if (COUNT) counter <= counter + {{(WIDTH - 1) {1'b0}}, 1'b1};
    end

endmodule
