`timescale 1ns / 1ps

module Control_Unit (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  op_type,    // From decoder
    input  wire        reg_imm,    // From decoder (1 for I-Type)
    output reg         reg_write,  // To reg file (write ALU result)
    output reg         alu_src_b,  // Mux: 1 = imm to ALU b, 0 = rt
    output reg         mem_we,     // To data_mem (write enable, for stores later)
    output reg         pc_write    // To PC (load new addr for branches/jumps later)
);

    // States
    parameter FETCH     = 3'd0;
    parameter DECODE    = 3'd1;
    parameter EXECUTE   = 3'd2;
    parameter MEM       = 3'd3;
    parameter WRITEBACK = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    // State register (sequential)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= FETCH;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            FETCH:     next_state = DECODE;
            DECODE:    next_state = EXECUTE;
            EXECUTE:   next_state = MEM;
            MEM:       next_state = WRITEBACK;
            WRITEBACK: next_state = FETCH;
            default:   next_state = FETCH;
        endcase
    end

    // Output logic (combinational, defaults safe)
    always @(*) begin
        reg_write = 0;
        alu_src_b = 0;
        mem_we    = 0;
        pc_write  = 0;

        case (state)
            FETCH: begin
                // Nothing special (PC already advanced)
            end
            DECODE: begin
                // Reg reads happen combinational
            end
            EXECUTE: begin
                alu_src_b = reg_imm;  // Use imm for I-Type
                // Branch calc here later
            end
            MEM: begin
                // mem_we = 1 for store instr later
            end
            WRITEBACK: begin
                reg_write = 1;  // Write ALU result to reg for most ops
            end
        endcase
    end

endmodule