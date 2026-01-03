module control_rom (
    input [8:0] ADDR,
    output reg [15:0] DATA
);

    always @(*) begin
        casex (ADDR)
            // fetch
            9'bxxxx_000_xx: DATA = 16'h4004;
            9'bxxxx_001_xx: DATA = 16'h1408;
            // nop - covered in default case
            // lda
            9'b0001_010_xx: DATA = 16'h4800;
            9'b0001_011_xx: DATA = 16'h1200;
            // add
            9'b0010_010_xx: DATA = 16'h4800;
            9'b0010_011_xx: DATA = 16'h1020;
            9'b0010_100_xx: DATA = 16'h0281;
            // sub
            9'b0011_010_xx: DATA = 16'h4800;
            9'b0011_011_xx: DATA = 16'h1020;
            9'b0011_100_xx: DATA = 16'h02c1;
            // sta
            9'b0100_010_xx: DATA = 16'h4800;
            9'b0100_011_xx: DATA = 16'h2100;
            // ldi
            9'b0101_010_xx: DATA = 16'h0a00;
            // jmp
            9'b0110_010_xx: DATA = 16'h0802;
            // jc
            9'b0111_010_1x: DATA = 16'h0802;
            // jz
            9'b1000_010_x1: DATA = 16'h0802;
            // out
            9'b1110_010_xx: DATA = 16'h0110;
            // halt
            9'b1111_010_xx: DATA = 16'h8000;
            default: DATA = 16'h0000;
        endcase
    end

endmodule
