`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:21:09 01/27/2015 
// Design Name: 
// Module Name:    icap_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ICAP_statemachine(
	clock,
	reset,
	fifo_empty,
	fifo_read_en,
	icap_en
    );

parameter DATA_WIDTH = 8;

input clock;
input reset;
input fifo_empty;
output fifo_read_en;
output icap_en;

parameter IDLE = 2'b00;
parameter READ_FIFO = 2'b01;
parameter READ_ICAP = 2'b10;
parameter ABORT_ICAP = 2'b11;

parameter ENABLE = 1'b0;
parameter DISABLE = 1'b1;

reg state, next_state;
reg icap_en;
reg icap_wr;
reg fifo_read_en;

always @(posedge clock)
begin
	if (reset)	state <= IDLE; 
	else	state <= next_state;
end

always @(state or fifo_empty)
begin
	case(state)
		IDLE: begin
			icap_en = DISABLE;
			icap_wr = DISABLE;
			fifo_read_en = DISABLE;
			//icap_wr_en = DISABLE;
			if (~fifo_empty)
				next_state = READ_FIFO;
			else 
				next_state = IDLE;
		end
		READ_FIFO: begin
			icap_en = ENABLE;
			icap_wr = ENABLE;
			fifo_read_en = ENABLE;
			if (fifo_empty)
				next_state = IDLE;
			else 
				next_state = READ_FIFO;
		end
		default: begin
			icap_en = DISABLE;
			icap_wr = DISABLE;
			fifo_read_en = DISABLE;
			next_state = IDLE;	
		end
	endcase
end

endmodule
