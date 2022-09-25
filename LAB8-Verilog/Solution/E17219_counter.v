//CO221 - Digital Design - 2017
//Lab 8 : 4-bit Counter implementation in verilog

// Top level stimulus module
module testbed;

	// Declare variables for stimulating input
	reg CLK, CLEAR_BAR;
	wire [3:0] NUM;
	
	// Monitor changes in NUM and print once a change happens
	initial
		$monitor($time," Count : %d",NUM);
		
	//Instantiate the design block counter	
	//NUM is the 4-bit output from the counter
	//CLK is the clock signal
	//The counter should increment at each falling edge of the clock cycle 
	//CLEAR_BAR is the signal that asynchronously clears the counter. A CLEAR_BAR=0 should clear the counter.
	rippleCounter4 mycounter(NUM,CLK,CLEAR_BAR);	
		
	// reset	
	initial
	begin	
		CLEAR_BAR=1'b0;	
		#5 CLEAR_BAR=1'b1;
		#500 CLEAR_BAR=1'b0;
		#50 CLEAR_BAR=1'b1;
	end		
		
	// Set up the clock to toggle every 10 time units	
	initial
	begin
		
		//generate files needed to plot the waveform
		//you can plot the waveform generated after running the simulator by using gtkwave		
		CLK = 1'b0;
		forever #10 CLK = ~CLK; // An indefinite loop in which clock is complemented
								// after a delay of 10 time units				
	end

	// Finish the simulation at after 700 time units
	initial
	begin
		#700 $finish;
	end
	
endmodule

//Sbar Rbar latch with clear and preset
module sr_latch(q,qbar,sbar,rbar,preset,clear);

	//port declaration
	output q,qbar;
	input sbar,rbar,clear,preset;
	
	//implementation
	nand (q,sbar,qbar,preset);
	nand (qbar,rbar,q,clear);
	
endmodule

//D latch module with clear and preset
module d_latch(q,qbar,d,en,preset,clear);
	
	//port declaration
	output q,qbar;
	input d,en,clear,preset;
	
	//implementation
	wire s,r;
	
	nand (s,d,en);
	nand (r,~d,en);
	
	sr_latch srl(q,qbar,s,r,preset,clear);
	
endmodule

//D filpflop with clear and preset
module d_ff(q,d,clk,preset,clear);

	//port declaration
	output q;
	input d,clk,clear,preset;
	
	//implementation
	wire y,ybar,l;
	
	//master d latch
	d_latch master(y,ybar,d,clk,1'b1,clear);
	//slave d latch
	d_latch slave(q,l,y,~clk,preset,clear);

endmodule

//T flipflop with clear and preset
module t_ff(q,t,clk,preset,clear);

	//port declaration
	output q;
	input t,clk,clear,preset;
	
	//implementation
	wire a;
	
	xor (a,t,q);
	
	d_ff dddd(q,a,clk,preset,clear);
	
endmodule

//counter with clear
module  rippleCounter4(NUM,CLK,CLEAR_BAR);
	
	//port declaration
	output [3:0]NUM;
	input CLK,CLEAR_BAR;
	
	//implementation
	t_ff t1(NUM[0],1'b1,CLK,1'b1,CLEAR_BAR);
	t_ff t2(NUM[1],1'b1,NUM[0],1'b1,CLEAR_BAR);
	t_ff t3(NUM[2],1'b1,NUM[1],1'b1,CLEAR_BAR);
	t_ff t4(NUM[3],1'b1,NUM[2],1'b1,CLEAR_BAR);
	
endmodule



