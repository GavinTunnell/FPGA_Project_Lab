module PC(
    input  wire        clk,
    input  wire        rst,
    input  wire        pc_write,
    input  wire        pc_en,
    input  wire [15:0] pc_next,
    output reg  [15:0] addr
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 16'h0000;
        end else if (pc_write) begin
            addr <= pc_next;
        end else if (pc_en) begin
            addr <= addr + 16'd2;
        end
    end
endmodule
