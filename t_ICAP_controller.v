module t_ICAP_statemachine ();
	
	parameter FLAG_SIZE = 1;
	parameter DATA_SIZE = 256;
	parameter ICAP_DATA_SIZE = 32;
	
	reg 									clock;
	reg 									reset;
	reg 	[FLAG_SIZE - 1 : 0]		fifo_empty;
	reg 	[DATA_SIZE - 1 : 0] 		fifo_data;
	
	wire 	[FLAG_SIZE - 1 : 0]		fifo_read_en;	
	wire 	[ICAP_DATA_SIZE - 1:0]	icap_data;
	wire 	[FLAG_SIZE - 1 : 0]		icap_en;
	
	wire 	[1:0]							state;
	wire [255:0]						data_temp;
	wire 	[1:0]							next_state;
	wire 	[7:0]							count;
	
	parameter time_out = 1000;
	
	ICAP_statemachine #(.DATA_SIZE(256), .FLAG_SIZE(1), .ICAP_DATA_SIZE(32)) ICAP1 (
		.clock(clock),
		.reset(reset),
		.fifo_empty(fifo_empty),
		.fifo_data(fifo_data),
		
		.fifo_read_en(fifo_read_en),	
		.icap_data(icap_data),
		.icap_en(icap_en),
		.data_temp(data_temp),
		.state(state),
		.next_state(next_state),
		.count(count)
   );
	
	initial $monitor("clock = %b, reset = %b, fifo_empty = %b, fifo_data = %b, fifo_read_en = %b, icap_data = %b, icap_en = %b, data_temp = %b, next_state = %b, state = %b, count = %b", 
						clock, reset, fifo_empty, fifo_data, fifo_read_en, icap_data, icap_en, data_temp, next_state, state, count);
	
	always #5  clock = ~clock;      // 200MHz
	
	initial #time_out $break;
	
	initial begin
		clock   = 1'b0;

      $display("[%t] : System Reset Asserted...", $realtime);
      reset = 1'b0;
      $display("[%t] : System Reset De-asserted...", $realtime);
      reset = 1'b1;
		#10 fifo_data = 256'hffff0008ffff0007ffff0006ffff0005ffff0004ffff0003ffff0002ffff0001;
		#10 fifo_empty = 0;
		
		#90 
		$display("[%t] : System Reset Asserted...", $realtime);
      #10 reset = 1'b0;
      $display("[%t] : System Reset De-asserted...", $realtime);
      #10 	reset = 1'b1;
				fifo_data = 256'hffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0011;
		#10;
	end
	
	
endmodule
