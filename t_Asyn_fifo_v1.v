`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:30 02/05/2015
// Design Name:   Asyn_fifo_v1
// Module Name:   H:/HK7/ISE/Asyn_fifo_v1/Asyn_fifo_v1/t_Asyn_fifo_v1.v
// Project Name:  Asyn_fifo_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Asyn_fifo_v1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_Asyn_fifo_v1;

	// Inputs
	reg [7:0] wdata;
	reg winc;
	reg wclk;
	reg wrst_n;
	reg rinc;
	reg rclk;
	reg rrst_n;

	// Outputs
	wire [7:0] rdata;
	wire wfull;
	wire rempty;

	// Instantiate the Unit Under Test (UUT)
	Asyn_fifo_v1 uut (
		.rdata(rdata), 
		.wfull(wfull), 
		.rempty(rempty), 
		.wdata(wdata), 
		.winc(winc), 
		.wclk(wclk), 
		.wrst_n(wrst_n), 
		.rinc(rinc), 
		.rclk(rclk), 
		.rrst_n(rrst_n)
	);
	
	always #5 wclk = ~wclk;
	always #5 rclk = ~rclk;
	
	initial begin
		// Initialize Inputs
		wdata = 0;
		winc = 0;
		wclk = 0;
		wrst_n = 0;
		rinc = 0;
		rclk = 0;
		rrst_n = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#5 winc = 1;
		#5 wrst_n = 1;
		#5 wdata = 8'hff;
		#5 wdata = 8'hfe;
		#5 wdata = 8'hfd;
		#5 rrst_n = 1;
	end
      
endmodule

