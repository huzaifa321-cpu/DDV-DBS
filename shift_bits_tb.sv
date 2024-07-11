`timescale 1ns / 1ps

module tb_shift_bits;

    // Declare signals for connecting to DUT (Design Under Test)
    reg in1;
    reg clk;
    reg reset;
    wire [3:0] out;

    // Instantiate the DUT (Design Under Test)
    shift_bits dut (
        .in1(in1),
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation
    always #5 clk = ~clk;  // Toggle clk every 5 time units

    
    initial begin
        clk = 0;
        reset = 1;
        @ (negedge clk)
        reset = 0;
        // Test case 1: Shift left with input changes
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)

        // Test case 2: Shift left with input changes
        in1 = 1'b0;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)
        
        // Test case 3: Shift left with input changes
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)
        in1 = 1'b1;
        @ (negedge clk)
        in1 = 1'b0;
        @ (negedge clk)

//        // End simulation
        $finish;
    end

endmodule