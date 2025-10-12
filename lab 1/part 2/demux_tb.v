`timescale 1ns / 1ps

module demux_tb;

reg a0_in , a1_in, d_in ;
wire q0_out, q1_out, q2_out, q3_out ;

demux demux_1 (
    . a0 (a0_in),
    . a1 (a1_in),
    . d (d_in),
    . q0 (q0_out),
    . q1 (q1_out),
    . q2 (q2_out),
    . q3 (q3_out)
) ;

integer i ;
reg [1:0] test_val ;
reg expected_val_q0, expected_val_q1, expected_val_q2, expected_val_q3 ;

initial begin
d_in = 1;
for (i = 0 ; i < 4 ; i = i +1) begin
    test_val = i ;
    a0_in = test_val[1] ;
    a1_in = test_val[0] ;
    expected_val_q0 = d_in & !test_val[0] & !test_val[1];
    expected_val_q1 = d_in & test_val[0] & !test_val[1];
    expected_val_q2 = d_in & !test_val[0] & test_val[1];
    expected_val_q3 = d_in & test_val[0] & test_val[1];
    #10
    if (q0_out == expected_val_q0 && q1_out == expected_val_q1 && q2_out == expected_val_q2 && q3_out == expected_val_q3) begin
        $display("The demux output is correct!!! a0_in=%b, a1_in=%b ,d_in=%b, q0_out = %b, q1_out = %b, q2_out = %b, q3_out = %b" ,a0_in ,a1_in ,d_in, q0_out, q1_out, q2_out, q3_out);
    end else begin
        $display("The demux output is wrong!!! a0_in=%b, a1_in=%b ,d_in=%b, q0_out = %b, q1_out = %b, q2_out = %b, q3_out = %b" ,a0_in ,a1_in ,d_in, q0_out, q1_out, q2_out, q3_out) ;
    end
    end
    #10 $stop ;
end
endmodule