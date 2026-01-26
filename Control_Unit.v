`timescale 1ns / 1ps

module Control_Unit (
    input wire clk,
    input wire rst,
    input wire [3:0] op_type,
    input wire reg_imm,
    output reg reg_write,
    output reg IType,
    output reg control_write,
    output reg pc_write,
    output reg pc_en,
    output reg ir_en
);

    reg [2:0] state;
    reg [2:0] next_state;

    parameter FETCH = 3'd0;
    parameter DECODE = 3'd1;
    parameter EXECUTE = 3'd2;
    parameter MEMORY = 3'd3;
    parameter WRITEBACK = 3'd4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= FETCH;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        reg_write = 0;
        IType = reg_imm;
        control_write = 0;
        pc_write = 0;
        pc_en = 0;
        ir_en = 0;
        
        case (state)
            FETCH: begin
                pc_en = 1;
                ir_en = 1;
                next_state = DECODE;
            end
            DECODE: begin
            
                next_state = EXECUTE;
            end
            EXECUTE: begin
            
                next_state = MEMORY;
            end
            MEMORY: begin
                reg_write = 1; // Write ALU result to reg for most ops
                if (op_type == 4'd9) begin
                    next_state = WRITEBACK;
                end else begin
                    next_state = FETCH;
                end
            end
            WRITEBACK: begin
                next_state = FETCH;
            end
        endcase
    end

endmodule