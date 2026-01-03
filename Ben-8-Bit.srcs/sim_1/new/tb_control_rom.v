`timescale 1ns / 1ps

module tb_control_rom ();

    integer i;

    reg [8:0] control_addr;
    wire [15:0] control_word;

    control_rom control_rom_inst (
        .ADDR(control_addr),
        .DATA(control_word)
    );

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            control_addr = i;
            #10;
        end

        $stop;
    end

endmodule
