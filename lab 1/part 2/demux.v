`timescale 1ns / 1ps

module demux (
input a0 ,
input a1 ,
input d ,
output q0,
output q1,
output q2,
output q3
) ;
wire not_a0 , not_a1 , not_d, y1 , y2, not_y1, not_y2;

nor(not_d, d, d) ;
nor(not_a0, a0, a0) ;
nor(not_a1, a1, a1) ;

nor(y1, not_d, a0) ;
nor(not_y1, y1, y1) ;
nor(q0, not_y1, a1) ;
nor(q1, not_y1, not_a1) ;

nor(y2, not_d, not_a0) ;
nor(not_y2, y2, y2) ;
nor(q2, not_y2, a1) ;
nor(q3, not_y2, not_a1) ;
endmodule