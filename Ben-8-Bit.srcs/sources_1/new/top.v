module top (
    input CLK50M,
    // input CLK27M,
    // input CLK50M1V5,

    // input [2:0] SW,
    input KEY,
    // output [1:0] LED,
    // output RGB_DAT,

    inout [63:0] GPIO

    // input  UART_RX,
    // output UART_TX,
    // input  UART_RTS_N,
    // output UART_CTS_N,

    // output [2:0] HDMI_D_P,
    // output [2:0] HDMI_D_N,
    // output HDMI_CK_P,
    // output HDMI_CK_N,
    // output HDMI_SCL,
    // inout  HDMI_SDA,
    // input  HDMI_HPD_N,

    // inout [31:0] DDR3_DQ,
    // output [3:0] DDR3_DM,
    // inout [3:0] DDR3_DQS_P,
    // inout [3:0] DDR3_DQS_N,
    // output [14:0] DDR3_ADDR,
    // output [2:0] DDR3_BA,
    // output DDR3_CK_P,
    // output DDR3_CK_N,
    // output DDR3_RAS_N,
    // output DDR3_CAS_N,
    // output DDR3_WE_N,
    // output DDR3_RST_N,
    // output DDR3_CKE,
    // output DDR3_ODT,
    // output DDR3_CS_N,

    // inout [3:0] QSPI_DQ,
    // output QSPI_CS_N
);

    // control lines
    wire [15:0] control_word;
    wire halt = control_word[15];
    wire ram_addr_load = control_word[14];
    wire ram_load = control_word[13];
    wire ram_enable = control_word[12];
    wire instruction_enable = control_word[11];
    wire instruction_load = control_word[10];
    wire a_load = control_word[9];
    wire a_enable = control_word[8];
    wire alu_enable = control_word[7];
    wire alu_sub = control_word[6];
    wire b_load = control_word[5];
    wire out_load = control_word[4];
    wire pc_increment = control_word[3];
    wire pc_enable = control_word[2];
    wire pc_load = control_word[1];
    wire flags_load = control_word[0];

    wire clk = CLK50M || halt;
    wire rst = KEY;
    wire [7:0] data_bus;
    wire [2:0] control_counter;
    wire [7:0] instruction_byte;
    wire [7:0] ram_addr;
    wire [7:0] data_a;
    wire [7:0] data_b;
    wire [7:0] data_out;
    wire alu_carry;
    wire alu_zero;
    wire carry_flag;
    wire zero_flag;

    assign GPIO[7:0] = data_out;
    // assign GPIO[15:8] = data_a;
    // assign GPIO[23:16] = data_b;
    // assign GPIO[31:24] = data_bus;
    // assign GPIO[47:32] = control_word;
    // assign GPIO[61] = carry_flag;
    // assign GPIO[62] = zero_flag;
    assign GPIO[63]  = halt;

    // A register
    register #(
        .WIDTH(8)
    ) register_a (
        .CLK(clk),
        .CLR(rst),
        .LOAD(a_load),
        .ENABLE(a_enable),
        .MASK_IN(8'hff),
        .MASK_OUT(8'hff),
        .DATA_BUS(data_bus),
        .DATA(data_a)
    );

    // B register
    register #(
        .WIDTH(8)
    ) register_b (
        .CLK(clk),
        .CLR(rst),
        .LOAD(b_load),
        .ENABLE(1'b0),
        .MASK_IN(8'hff),
        .MASK_OUT(8'hff),
        .DATA_BUS(data_bus),
        .DATA(data_b)
    );

    // output register
    register #(
        .WIDTH(8)
    ) register_out (
        .CLK(clk),
        .CLR(rst),
        .LOAD(out_load),
        .ENABLE(1'b0),
        .MASK_IN(8'hff),
        .MASK_OUT(8'hff),
        .DATA_BUS(data_bus),
        .DATA(data_out)
    );

    // ram address register
    register #(
        .WIDTH(8)
    ) register_addr (
        .CLK(clk),
        .CLR(rst),
        .LOAD(ram_addr_load),
        .ENABLE(1'b0),
        .MASK_IN(8'h0f),
        .MASK_OUT(8'h0f),
        .DATA_BUS(data_bus),
        .DATA(ram_addr)
    );

    // ram
    ram #(
        .WIDTH(8),
        .SIZE (16)
    ) ram_inst (
        .CLK(clk),
        .LOAD(ram_load),
        .ENABLE(ram_enable),
        .ADDR(ram_addr[3:0]),
        .DATA_BUS(data_bus)
    );

    // alu
    alu alu_inst (
        .INPUT_A(data_a),
        .INPUT_B(data_b),
        .SUB(alu_sub),
        .ENABLE(alu_enable),
        .DATA_BUS(data_bus),
        .CARRY(alu_carry),
        .ZERO(alu_zero)
    );

    // flags register
    register #(
        .WIDTH(2)
    ) register_flags (
        .CLK(clk),
        .CLR(rst),
        .LOAD(flags_load),
        .ENABLE(1'b0),
        .MASK_IN(2'b11),
        .MASK_OUT(2'b11),
        .DATA_BUS({alu_carry, alu_zero}),
        .DATA({carry_flag, zero_flag})
    );

    // program counter
    counter #(
        .WIDTH(8)
    ) counter_program (
        .CLK(clk),
        .RST(rst),
        .ZERO(1'b0),
        .COUNT(pc_increment),
        .LOAD(pc_load),
        .ENABLE(pc_enable),
        .MASK_IN(8'h0f),
        .MASK_OUT(8'h0f),
        .DATA_BUS(data_bus)
    );

    // instruction register
    register #(
        .WIDTH(8)
    ) register_instruction (
        .CLK(clk),
        .CLR(rst),
        .LOAD(instruction_load),
        .ENABLE(instruction_enable),
        .MASK_IN(8'hff),
        .MASK_OUT(8'h0f),
        .DATA_BUS(data_bus),
        .DATA(instruction_byte)
    );

    // control counter
    counter #(
        .WIDTH(3)
    ) counter_control (
        .CLK(clk),
        .RST(rst),
        .ZERO(control_counter[2]),
        .COUNT(1'b1),
        .LOAD(1'b0),
        .ENABLE(1'b1),
        .MASK_IN(3'b111),
        .MASK_OUT(3'b111),
        .DATA_BUS(control_counter)
    );

    // control rom
    control_rom control_rom_inst (
        .ADDR({instruction_byte[7:4], control_counter, carry_flag, zero_flag}),
        .DATA(control_word)
    );

endmodule
