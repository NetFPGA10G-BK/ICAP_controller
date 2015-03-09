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
module ICAP_statemachine
	#(
		parameter DATA_SIZE = 256,
		parameter FLAG_SIZE = 1,
		parameter ICAP_DATA_SIZE = 32
	)
	(
		input 									clock,
		input 									reset,
		input 	[FLAG_SIZE - 1 : 0]		fifo_empty,
		input 	[DATA_SIZE - 1 : 0] 		fifo_data,
		
		output reg [FLAG_SIZE - 1 : 0]	fifo_read_en,	
		output reg [ICAP_DATA_SIZE - 1:0]icap_data,
		output reg [FLAG_SIZE - 1 : 0]	icap_en
    );

		//behavior states
		localparam IDLE 						= 2'b00;
		localparam READ_FIFO 				= 2'b01;
		localparam DIVIDE_DATA 				= 2'b10;
		localparam ABORT_ICAP 				= 2'b11;
		
		//count states
		localparam ONE 						= 8'b00000001;
		localparam TWO 						= 8'b00000010;
		localparam THREE 						= 8'b00000100;
		localparam FOUR 						= 8'b00001000;
		localparam FIVE 						= 8'b00010000;
		localparam SIX 						= 8'b00100000;
		localparam SEVEN 						= 8'b01000000;
		localparam EIGHT 						= 8'b10000000;
		//localparam STOP 	= 8'b100000000;
		
		//enable and disable for fifo and icap
		localparam ENABLE 					= 1'b0;
		localparam DISABLE 					= 1'b1;
		
		//register
		reg [255 : 0] 							data_temp;
		reg [1 : 0] 							state;
		reg [1 : 0] 							next_state;
		reg [7 : 0] 							count;
		reg [7 : 0] 							next_count;

	always @(posedge clock or negedge reset)
	begin
		if (!reset)	state <= IDLE; 
		else	begin state <= next_state; count <= next_count; end
	end

	always @(*)
	begin
		case(state)
			IDLE: begin
				icap_en 			= DISABLE;
				fifo_read_en 	= DISABLE;
				next_count 		= ONE;
				if (fifo_empty)	next_state = IDLE;
				else 					next_state = READ_FIFO;
			end
			READ_FIFO: begin
				icap_en 			= DISABLE;
				fifo_read_en 	= ENABLE;
				data_temp 		= fifo_data;
				if (fifo_empty)	next_state = IDLE;
				else 					next_state = DIVIDE_DATA;
			end
			DIVIDE_DATA: begin
				case (count)
					ONE	: begin icap_data = data_temp[(1*32 - 1) : (0*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end
					TWO	: begin icap_data = data_temp[(2*32 - 1) : (1*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end
					THREE	: begin icap_data = data_temp[(3*32 - 1) : (2*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end	//2
					FOUR	: begin icap_data = data_temp[(4*32 - 1) : (3*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end	//3
					FIVE	: begin icap_data = data_temp[(5*32 - 1) : (4*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end	//4
					SIX	: begin icap_data = data_temp[(6*32 - 1) : (5*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end	//5
					SEVEN	: begin icap_data = data_temp[(7*32 - 1) : (6*32)]; next_count = next_count << 1;	icap_en = ENABLE; fifo_read_en = DISABLE; next_state = DIVIDE_DATA; end	//6
					EIGHT	: begin icap_data = data_temp[(8*32 - 1) : (7*32)]; next_count = ONE;					icap_en = ENABLE; fifo_read_en = DISABLE;
									  if(fifo_empty)	next_state = IDLE; 
									  else 				next_state = READ_FIFO;
							  end	//STOP
					default: begin icap_data = 0; next_count = ONE; icap_en = DISABLE; fifo_read_en = DISABLE; next_state = IDLE; end
				endcase
			end
			default: begin icap_en = DISABLE; fifo_read_en = DISABLE; next_state = IDLE; end
		endcase
	end

endmodule
