`timescale 1ns / 1ps

module Registers(
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  RS1,
    input  wire [3:0]  RS2,
    input  wire [3:0]  RA,
    input  wire [15:0] write_data,
    input  wire        reg_write,
    output wire [15:0] SR1_OUT,
    output wire [15:0] SR2_OUT
);

    reg [15:0] Register [15:0];

    // Optional sim init (ignored in synthesis for FFs-FPGA power-on zeros)
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) Register[i] = 16'd0;
    end

    // Clocked write (no reset loop-rely on power-on zero or external rst if needed)
    always @(posedge clk) begin
        if (reg_write && (RA != 4'd0)) begin
            Register[RA] <= write_data;
        end
    end

    assign SR1_OUT = (RS1 == 4'd0) ? 16'd0 : Register[RS1];
    assign SR2_OUT = (RS2 == 4'd0) ? 16'd0 : Register[RS2];

endmodule