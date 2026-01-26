`timescale 1ns / 1ps

module Data_Memory(
    input wire clk,
    input wire control_write,
    input wire [15:0] addr,
    input wire [15:0] write_data,
    output reg [15:0] read_data
);

    reg [15:0] ram [0:4095];
    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) begin
            ram[i] = 16'd0; // Clear on start
        end
    end
    
    always @(posedge clk) begin
        if (control_write) begin
            ram[addr >> 1] <= write_data;
        end
        read_data <= ram[addr >> 1];
    end

endmodule