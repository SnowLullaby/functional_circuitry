`timescale 1ns / 1ps

module addr (
    input  [15:0]  a,
    input  [15:0]  b,
    output [15:0]  sum
);    
    assign sum = a + b;

endmodule