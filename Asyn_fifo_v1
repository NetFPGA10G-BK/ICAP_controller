`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:15:14 02/05/2015 
// Design Name: 
// Module Name:    Asyn_fifo_v1 
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
module Asyn_fifo_v1
	#(
		parameter DATA_SIZE = 8,
		parameter ARRAY_SIZE = 4
	)
	(
		output [DATA_SIZE-1:0] rdata,
		output wfull,
		output rempty,
		input [DATA_SIZE-1:0] wdata,
		input winc, wclk, wrst_n,
		input rinc, rclk, rrst_n
	);
	
	wire [ARRAY_SIZE-1:0] waddr, raddr;
	wire [ARRAY_SIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;
	
	sync_r2w sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr), .wclk(wclk), .wrst_n(wrst_n));

	sync_w2r sync_w2r (.rq2_wptr(rq2_wptr), .wptr(wptr), .rclk(rclk), .rrst_n(rrst_n));

	fifomem #(DATA_SIZE, ARRAY_SIZE) fifomem (.rdata(rdata), .wdata(wdata), .waddr(waddr), .raddr(raddr), .wclken(winc), .wfull(wfull), .wclk(wclk));
	
	rptr_empty #(ARRAY_SIZE) rptr_empty (.rempty(rempty), .raddr(raddr), .rptr(rptr), .rq2_wptr(rq2_wptr), .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n));
	
	wptr_full #(ARRAY_SIZE) wptr_full (.wfull(wfull), .waddr(waddr), .wptr(wptr), .wq2_rptr(wq2_rptr), .winc(winc), .wclk(wclk), .wrst_n(wrst_n));
	
endmodule
