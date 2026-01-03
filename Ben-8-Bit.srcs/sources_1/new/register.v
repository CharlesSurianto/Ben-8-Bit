module register #(
    parameter WIDTH = 8
) (
    input CLK,
    input CLR,
    input LOAD,
    input ENABLE,
    input [WIDTH-1:0] MASK_IN,
    input [WIDTH-1:0] MASK_OUT,
    inout [WIDTH-1:0] DATA_BUS,
    output reg [WIDTH-1:0] DATA
);

    assign DATA_BUS = ENABLE ? DATA & MASK_OUT : {WIDTH{1'bz}};

    always @(posedge CLK or posedge CLR) begin
        if (CLR) DATA <= {WIDTH{1'b0}};
        else if (LOAD) DATA <= DATA_BUS & MASK_IN;
    end

endmodule
