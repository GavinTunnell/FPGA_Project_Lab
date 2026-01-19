`timescale 1ns / 1ps

module PC(
    input wire clk,
    input wire rst,
    input wire pc_write,
    input wire [15:0] pc_next,
    output reg [15:0] addr
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 16'h8000;
        end else if (pc_write) begin
            addr <= pc_next;
        end else begin
            addr <= addr + 16'd2;
        end
    end
endmodule