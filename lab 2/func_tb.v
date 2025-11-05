`timescale 1ns / 1ps

module func_test ();
    reg [7:0] a_bi, b_bi;
    reg clk_i, rst_i, start_i;
	reg test;
    wire busy;
    wire [15:0] out;
    
    func uut(
        .clk(clk_i), 
        .reset(rst_i), 
        .start(start_i), 
        .a(a_bi), 
        .b(b_bi), 
        .busy(busy), 
        .result(out)
    );

    always #5 clk_i = ~clk_i;

    reg [31:0] test_vectors [0:9];
    integer i, error_count;
    
    initial begin
        $dumpfile("func_tb.vcd");
        $dumpvars(0, func_test);

        test_vectors[0] = {8'd3, 8'd8, 16'd11};     // 3, 8 = 9 + 2 = 11
        test_vectors[1] = {8'd4, 8'd27, 16'd19};    // 4, 27 = 16 + 3 = 19
        test_vectors[2] = {8'd5, 8'd64, 16'd29};    // 5, 64 = 25 + 4 = 29
        test_vectors[3] = {8'd6, 8'd125, 16'd41};   // 6, 125 = 36 + 5 = 41
        test_vectors[4] = {8'd7, 8'd216, 16'd55};   // 7, 216 = 49 + 6 = 55
        test_vectors[5] = {8'd0, 8'd0, 16'd0};      // 0, 0 = 0 + 0 = 0
        test_vectors[6] = {8'd1, 8'd1, 16'd2};      // 1, 1 = 1 + 1 = 2
        test_vectors[7] = {8'd10, 8'd10, 16'd102};  // 10, 10 = 100 + 2 = 102
        test_vectors[8] = {8'd15, 8'd255, 16'd231}; // 15, 255 = 225 + 6 = 231
        test_vectors[9] = {8'd255, 8'd255, 16'd65031}; // 255, 255 = 65025 + 6 = 65031
        
        clk_i = 1'b0; 
        rst_i = 1'b1; 
        error_count = 0;
        #20;
        
        for (i = 0; i < 10; i = i + 1) begin
            rst_i = 1'b1;
            #10;
            rst_i = 1'b0;
            #10;

            a_bi = test_vectors[i][31:24];  
            b_bi = test_vectors[i][23:16];
            start_i = 1'b1;
			test <= 1; 
            #5;
            start_i = 1'b0;
            
            wait(busy == 1'b0);
			test <= 0;
            #10;
            
            if (out === test_vectors[i][15:0]) begin
                $display("TEST %0d PASS: %d^2 + %d^(1/3) = %d", 
                         i+1, a_bi, b_bi, out);
            end else begin
                $display("TEST %0d FAIL: %d^2 + %d^(1/3) = %d (expected %d)", 
                         i+1, a_bi, b_bi, out, test_vectors[i][15:0]);
                error_count = error_count + 1;
            end
        end
        
        $display("----------------------------------------");
        if (error_count == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("FAILED: %0d of %0d tests failed", error_count, 10);
        end
        
        $finish;
    end
endmodule