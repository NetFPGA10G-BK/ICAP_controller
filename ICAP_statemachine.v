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
module icap_statemachine
	#(
		parameter DATA_SIZE = 256
	)
	(
		clock,
		reset,
		fifo_empty,
		fifo_read_en,
		fifo_data,
		icap_data,
		icap_en
    );


input clock;
input reset;
input fifo_empty;
output fifo_read_en;
output icap_en;
output [DATA_SIZE - 1 : 0] fifo_data;
output reg [31 : 0] icap_data;

//behavior states
parameter IDLE = 2'b00;
parameter READ_FIFO = 2'b01;
parameter DIVIDE_DATA = 2'b10;
parameter ABORT_ICAP = 2'b11;

parameter ENABLE = 1'b0;
parameter DISABLE = 1'b1;

reg state, next_state;
reg icap_en;
reg fifo_read_en;
reg count = 0;

wire [255 : 0] data_temp;

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
			fifo_read_en = DISABLE;
			if (~fifo_empty)
				next_state = READ_FIFO;
			else 
				next_state = IDLE;
		end
		READ_FIFO: begin
			icap_en = DISABLE;
			fifo_read_en = ENABLE;
			if (fifo_empty)
				next_state = IDLE;
			else 
				next_state = DIVIDE_DATA;
		end
		DIVIDE_DATA: begin
			if (count < 8) begin
				icap_en = ENABLE;
				fifo_read_en = DISABLE;
				case (count)
					0: icap_data = data_temp[(1*32 - 1) : (0*32)];
					1: icap_data = data_temp[(2*32 - 1) : (1*32)];
					2: icap_data = data_temp[(3*32 - 1) : (2*32)];
					3: icap_data = data_temp[(4*32 - 1) : (3*32)];
					4: icap_data = data_temp[(5*32 - 1) : (4*32)];
					5: icap_data = data_temp[(6*32 - 1) : (5*32)];
					6: icap_data = data_temp[(7*32 - 1) : (6*32)];
					7: icap_data = data_temp[(8*32 - 1) : (7*32)];
					default:	icap_data = 0;
				endcase
				count = count + 1;
				next_state = DIVIDE_DATA;
			end
			else begin
				count = 0;
				if (fifo_empty)
					next_state = IDLE;
				else
					next_state = READ_FIFO;
			end
		end
		default: begin
			icap_en = DISABLE;
			fifo_read_en = DISABLE;
			next_state = IDLE;	
		end
	endcase
end

assign data_temp = fifo_data;
endmodule
