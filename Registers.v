`timescale 1ns / 1ps

module Registers(
    input wire clk,
    input wire rst,
    input wire [3:0] RS1, //Register Source 1
    input wire [3:0] RS2, //Register Source 2
    input wire [3:0] RA, //Register Destination
    input wire [15:0] write_data, //16-bit data to write into register
    input wire reg_write, //writing is active when reg_write == 1
    input wire IType,
    output wire [15:0] SR1_OUT, //output Data from Source Register 1
    output wire [15:0] SR2_OUT //Output Data from Source Register 2
);

    reg [15:0] Register [15:0]; //Define 16 16-bit Registers
    reg [3:0] i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Register[0] <= 16'd0;
            Register[1] <= 16'd0;
            Register[2] <= 16'd0;
            Register[3] <= 16'd0;
            Register[4] <= 16'd0;
            Register[5] <= 16'd0;
            Register[6] <= 16'd0;
            Register[7] <= 16'd0;
            Register[8] <= 16'd0;
            Register[9] <= 16'd0;
            Register[10] <= 16'd0;
            Register[11] <= 16'd0;
            Register[12] <= 16'd0;
            Register[13] <= 16'd0;
            Register[14] <= 16'd0;
            Register[15] <= 16'd0;
        end else if (reg_write) begin
            if (IType) begin
                if (RS1 != 4'd0) begin
                    Register[RS1] <= write_data;
                end
            end else if (RA != 4'd0)begin
                Register[RA] <= write_data;
            end
        end
    end

    assign SR1_OUT = (RS1 == 4'd0) ? 16'd0 : Register[RS1];
    assign SR2_OUT = (RS2 == 4'd0) ? 16'd0 : Register[RS2];

endmodule