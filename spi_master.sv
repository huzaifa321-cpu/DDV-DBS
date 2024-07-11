`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 02:41:54 PM
// Design Name: 
// Module Name: spi_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_master (
  input  logic       clk, 
  input  logic       rst_n,
  input  logic       start_transaction,
  input  logic [7:0] tx_data,
  output logic [7:0] rx_data,
  output logic       transaction_done,
  output logic       sclk,
  output logic       mosi,
  input  logic       miso,
  output logic       ss_n
);

  typedef enum logic [1:0] {IDLE, TRANSMIT, FINISH} state_t;
  state_t current_state, next_state;

  logic [7:0] tx_shift_reg, rx_shift_reg;
  logic [2:0] bit_counter;
  reg [7:0] tx_data_shift, rx_data_shift;
  reg sclk_reg;

  always_ff @(posedge clk or negedge rst_n) begin
   if(!rst_n)begin
        current_state <= IDLE;
        tx_data_shift <= 8'b0;  
        rx_data_shift <= 8'b0;
        sclk_reg <= 1'b0;
        bit_counter <= 3'b0;
        transaction_done <= 1'b0;
        ss_n <= 1'b1;
   end
   else begin
            current_state <= next_state;
            if(current_state == TRANSMIT)begin
                if(sclk_reg ==  1'b1)begin
                    tx_data_shift <= {tx_data_shift[6:0], 1'b0};
                    rx_data_shift <= {rx_data_shift[6:0], miso};
                    bit_counter <= bit_counter + 1;
                end
            end
        end
  end

  always_comb begin
    transaction_done = 1'b0;
    sclk_reg = sclk_reg;
    next_state = current_state;
    case(current_state)
    IDLE:begin
        if(start_transaction)begin
            next_state = TRANSMIT; 
            tx_data_shift = tx_data;
            ss_n = 1'b0;
    end
    else begin 
    ss_n = 1'b0;
    end
    sclk_reg = 1'b0;
    end
    TRANSMIT:begin 
    if(bit_counter == 3'b111 && sclk_reg == 1'b0)begin
         next_state = FINISH;
    end
    sclk_reg = ~sclk_reg;
    end
    FINISH:begin 
            next_state = IDLE;
            transaction_done = 1'b1;   
            rx_data_shift = rx_data;
            ss_n = 1'b1;
            sclk_reg = 1'b0;
    end
     default: begin
        next_state = IDLE;
        ss_n = 1'b1;
        sclk_reg = 1'b0;
      end
    endcase
        
  end

  assign mosi = tx_shift_reg[7];
  assign sclk = sclk_reg;
endmodule
