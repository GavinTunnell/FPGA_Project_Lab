`timescale 1ns / 1ps

module ALU(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] op_type, //What Selected Operator
    output reg [15:0] alu_result, //Operation Result
    output reg Zero
);
    always @(*) begin
        case (op_type)
            4'd0: begin
                alu_result = a + b;
            end
            4'd1: begin
                alu_result = a - b;
            end
            4'd2: begin
                alu_result = a | b;
            end
            4'd3: begin
                alu_result = a & b;
            end
            4'd4: begin
                alu_result = (a < b) ? 16'd1 : 16'd0;
            end
            4'd5: begin 
                alu_result = a << b[3:0];
            end
            4'd6: begin
                alu_result = a >> b[3:0];
            end
            4'd7: begin
                alu_result = a + {12'd0, b[3:0]};
            end
            4'd8: begin
                alu_result = a - {12'd0, b[3:0]};
            end
            default: begin
                alu_result = 16'd0;
            end
        endcase 
        Zero = (alu_result == 0) ? 1 : 0;
    end
endmodule
