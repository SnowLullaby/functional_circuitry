`timescale 1ns / 1ps
`include "cbrt.v"

module func (
    input        clk,
    input        reset,
    input        start,
    input  [7:0] a,
    input  [7:0] b,
    output       busy,
    output reg [15:0] result
);

reg         mult_start;
reg  [7:0]  mult_a, mult_b;
wire        mult_busy;
wire [15:0] mult_result;

mult mult_inst (
    .clk(clk),
    .reset(reset),
    .start(mult_start),
    .a(mult_a),
    .b(mult_b),
    .busy(mult_busy),
    .product(mult_result)
);

reg        cbrt_start;
wire       cbrt_busy;
wire [3:0] cbrt_result;

cbrt cbrt_inst (
    .clk(clk),
    .reset(reset),
    .start(cbrt_start),
    .a(b),
    .busy(cbrt_busy),
    .root(cbrt_result)
);

localparam IDLE   = 2'b00;
localparam START  = 2'b01;
localparam WORK   = 2'b10;
localparam FINISH = 2'b11;

reg [1:0]  state;
reg [15:0] a_squared;
reg [3:0]  b_cube_root;

assign busy = (state != IDLE);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        result <= 16'd0;
        mult_start <= 1'b0;
        cbrt_start <= 1'b0;
        a_squared <= 16'd0;
        b_cube_root <= 4'd0;
    end else begin
        case (state)
            IDLE:
                if (start) begin
                    mult_start <= 1'b1;
                    cbrt_start <= 1'b1;
                    mult_a <= a;
                    mult_b <= a;
                    state <= START;
                end
                
            START:
                begin
                    if (mult_busy && cbrt_busy) begin
                        mult_start <= 1'b0;
                        cbrt_start <= 1'b0;
                    end
                    state <= WORK;
                end
                
            WORK:
                begin
                    if (~mult_busy && ~cbrt_busy) begin
                        a_squared <= mult_result;
                        b_cube_root <= cbrt_result;
                        state <= FINISH;
                    end
                end
                
            FINISH:
                begin
                    result <= a_squared + b_cube_root;
                    state <= IDLE;
                end
        endcase
    end
end
endmodule