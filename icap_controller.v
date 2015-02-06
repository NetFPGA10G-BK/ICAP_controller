//----------------------------------------------------------------------------
// icap_controller - module
//----------------------------------------------------------------------------
// IMPORTANT:
// DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
//
// SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
//
// TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
// PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
// OF THE USER_LOGIC ENTITY.
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          icap_controller
// Version:           1.00.a
// Description:       Example Axi Streaming core (Verilog).
// Date:              Thu Feb  5 14:14:46 2015 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// ACLK              : Synchronous clock
// ARESETN           : System reset, active low
// S_AXIS_TREADY  : Ready to accept data in
// S_AXIS_TDATA   :  Data in 
// S_AXIS_TLAST   : Optional data in qualifier
// S_AXIS_TVALID  : Data in is valid
// M_AXIS_TVALID  :  Data out is valid
// M_AXIS_TDATA   : Data Out
// M_AXIS_TLAST   : Optional data out qualifier
// M_AXIS_TREADY  : Connected slave device is ready to accept data out
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------
// Module Section
//----------------------------------------
module icap_controller 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here 
		// ADD USER PORTS ABOVE THIS LINE 
		ICAP_clk,			//ICAP_CLK - or in the future can make a clock generator in this module
		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		ACLK,
		ARESETN,
		S_AXIS_TREADY,			//input
		S_AXIS_TDATA,			//write_data for fifo
		S_AXIS_TLAST,			//the last packet will set the TLAST = 1
		S_AXIS_TVALID,			//input valid
		M_AXIS_TVALID,
		M_AXIS_TDATA,
		M_AXIS_TLAST,
		M_AXIS_TREADY			//for output
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

// ADD USER PORTS BELOW THIS LINE 
	input 									BCLK;
// ADD USER PORTS ABOVE THIS LINE 

	input                                     ACLK;
	input                                     ARESETN;
	output                                    S_AXIS_TREADY;
	input      [256 : 0]                      S_AXIS_TDATA;
	input                                     S_AXIS_TLAST;
	input                                     S_AXIS_TVALID;
	output                                    M_AXIS_TVALID;
	output     [31 : 0]                       M_AXIS_TDATA;
	output                                    M_AXIS_TLAST;
	input                                     M_AXIS_TREADY;

// ADD USER PARAMETERS BELOW THIS LINE 
	parameter DATA_WIDTH = 256;
	parameter ICAP_WIDTH = 32;
// ADD USER PARAMETERS ABOVE THIS LINE
	

//----------------------------------------
// Implementation Section
//----------------------------------------
// 
	//input write_en;
	//input [DATA_WIDTH - 1 : 0] write_data;
	
	//output [ICAP_WIDTH - 1 : 0] icap_data; 
	//output icap_busy;
	
	wire read_en;
	wire fifo_flag_EMPTY;
	wire [DATA_WIDTH - 1 : 0] read_data;
	wire icap_flag_en;
	wire icap_flag_wr_en;
	
	/*Fifo_independent_v8 Fifo_independent_v8(
	  .rst(rst),
	  .wr_clk(clk_1),
	  .rd_clk(clk_2),
	  .din(write_data),
	  .wr_en(write_en),
	  .rd_en(read_en),
	  .dout(read_data),
	  .full(fifo_flag_FULL),
	  .empty (fifo_flag_EMPTY)
	);
	*/
	
	Asyn_fifo_v1 #(DATA_WIDTH, ICAP_WIDTH) fifo
	(	
		.wfull(fifo_flag_FULL),
		.wdata(S_AXIS_TDATA),
		.winc(S_AXIS_TREADY),
		.wclk(ACLK),
		.wrst_n(ARESETN),
		
		.rdata(read_data),
		.rempty(fifo_flag_EMPTY),
		.rinc(read_en),
		.rclk(ICAP_clk),
		.rrst_n(ARESETN)
	);
	
	/*counter counter (
	);*/
	ICAP_statemachine ICAP_SM(
		.clock(ICAP_clk),
		.reset(ARESETN),
		.fifo_empty(fifo_flag_EMPTY),
		.fifo_read_en(read_en),
		.icap_en(icap_flag_en)
		//.icap_wr_en(icap_flag_wr_en)
   );
	
	ICAP_VIRTEX5 #(
		.ICAP_WIDTH("X32")          	// Specifies the input and output data width
	)
	ICAP_VIRTEX5_inst (
		.CLK(ICAP_clk),						// 1-bit input: Clock Input
		.CE(icap_flag_en),				// 1-bit input: Active-Low ICAP input Enable
		.WRITE(icap_flag_wr_en),		// 1-bit input: Read/Write Select input
		.I(read_data),						// ICAP_WIDTH - bit input: Configuration data input bus
		.O(),									// ICAP_WIDTH -bit output: Configuration data output bus
		.BUSY()								// 1-bit output: Busy/Ready output
	); 

endmodule
