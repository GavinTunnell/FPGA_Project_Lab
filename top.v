`timescale 1ns / 1ps

module board_cpu_top (
    input  wire clk,    
    input  wire rst,       
    output wire [3:0] an,    
    output wire [6:0] seg   
);

    wire [15:0] addr;

    wire [15:0] instr_mem;
    reg  [15:0] instr;

    wire [3:0]  op_type;
    wire [3:0]  RS1, RS2, RA;
    wire [7:0]  imm;
    wire        reg_imm;
    wire [15:0] SR1_OUT, SR2_OUT;
    wire [15:0] alu_result;
    wire pc_en;
    wire ir_en;
    wire mode;

    wire        reg_write, IType, control_write, pc_write;
    wire [15:0] pc_next = 16'd0;
    
    wire one_zero = (op_type == 4'd5) ? mode : 1'b0;
    wire [15:0] b = IType ? {8'd0, imm} : SR2_OUT;

    wire [15:0] mem_read_data;

    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_write(pc_write),
        .pc_en(pc_en),   
        .pc_next(pc_next),
        .addr(addr)
    );

    Instruction_Memory rom_inst (
        .clk(clk),
        .addr(addr),
        .instr(instr_mem)  
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instr <= 16'h0000;
        end else if (ir_en) begin
            instr <= instr_mem;
        end
    end

    Decoder dec_inst (
        .instr(instr),
        .op_type(op_type),
        .RS1(RS1),
        .RS2(RS2),
        .RA(RA),
        .imm(imm),
        .reg_imm(reg_imm),
        .is_load(is_load),
        .is_store(is_store),
        .mode(mode)
    );

    Registers reg_inst (
        .clk(clk),
        .rst(rst),
        .RS1(RS1),
        .RS2(RS2),
        .RA(RA),
        .IType(IType),
        .write_data(alu_result),
        .reg_write(reg_write),
        .SR1_OUT(SR1_OUT),
        .SR2_OUT(SR2_OUT)
    );

    ALU alu_inst (
        .a(SR1_OUT),
        .b(b),
        .op_type(op_type),
        .one_zero(one_zero),
        .alu_result(alu_result),
        .Zero()
    );

    Data_Memory ram_inst (
        .clk(clk),
        .control_write(control_write),
        .addr(addr),
        .write_data(SR2_OUT),
        .read_data(mem_read_data)
    );

    Control_Unit ctrl_inst (
        .clk(clk),
        .rst(rst),
        .op_type(op_type),
        .reg_imm(reg_imm),
        .reg_write(reg_write),
        .IType(IType),
        .control_write(control_write),
        .pc_write(pc_write),
        .pc_en(pc_en),      
        .ir_en(ir_en)         
    );

    reg [16:0] refresh_counter = 0;
    wire refresh_clk;
    always @(posedge clk) refresh_counter <= refresh_counter + 1;
    assign refresh_clk = refresh_counter[16];

    reg [1:0] digit_sel = 0;
    always @(posedge refresh_clk) digit_sel <= digit_sel + 1;

    wire [15:0] counter = reg_inst.Register[1];

    wire [3:0] digit3 = counter / 1000;
    wire [3:0] digit2 = (counter / 100) % 10;
    wire [3:0] digit1 = (counter / 10) % 10;
    wire [3:0] digit0 = counter % 10;

    reg [3:0] current_digit;
    always @(*) begin
        case (digit_sel)
            2'd0: current_digit = digit0;
            2'd1: current_digit = digit1;
            2'd2: current_digit = digit2;
            2'd3: current_digit = digit3;
        endcase
    end

    assign an = (digit_sel == 2'd0) ? 4'b1110 :
                (digit_sel == 2'd1) ? 4'b1101 :
                (digit_sel == 2'd2) ? 4'b1011 :
                                     4'b0111;

    seven_seg_decoder seg_decoder (
        .digit(current_digit),
        .seg(seg)
    );

endmodule
