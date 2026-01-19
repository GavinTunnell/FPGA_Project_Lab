`timescale 1ns / 1ps

module Decoder(
    input wire [15:0] instr,
    output wire [3:0] op_type,
    output wire [3:0] RS1,
    output wire [3:0] RS2,
    output wire [3:0] RA, //Register Action when I type acts as immediate value, when r-type acts as regsiter destination
    output wire reg_imm
);

    assign op_type = instr[15:12]; //operations
    assign RS1 = instr[11:8]; //source register 1
    assign RS2 = instr[7:4]; //source register 2
    assign RA = instr[3:0]; //destination register
    assign reg_imm = (op_type == 4'd5) || (op_type == 4'd6) || (op_type == 4'd7) || (op_type == 4'd8);
endmodule
