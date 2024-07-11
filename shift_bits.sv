module shift_bits(input in1,
                 input clk,
                 input reset,
                 output [3:0] out
    );
    
    reg[3:0] temp_out;
    
    always @(posedge clk) begin 
    if (reset) begin
        temp_out <= 4'b0000;
    end
    else begin
        temp_out <= {temp_out[2:0],in1};
     end
    end
    assign out = temp_out;
endmodule