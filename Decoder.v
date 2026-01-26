`timescale 1ns / 1ps
module Decoder(
    input  wire [15:0] instr,
    output wire [3:0]  op_type,
    output wire [3:0]  RS1,
    output wire [3:0]  RS2,
    output wire [3:0]  RA,
    output wire [7:0]  imm,
    output wire        reg_imm,
    output wire        is_load,
    output wire        is_store,
    output wire        mode //1 = check if equal, 0= check if not equal
);

    assign op_type  = instr[15:12];
    assign RS1      = instr[11:8];
    assign RS2      = instr[7:4];
    assign RA       = instr[3:0];
    assign imm      = instr[7:0];

    assign reg_imm  = (op_type == 4'd5) || (op_type == 4'd7) || (op_type == 4'd8);
    assign is_load  = (op_type == 4'd9);
    assign is_store = (op_type == 4'd10);
    assign mode = instr[7];

endmodule
