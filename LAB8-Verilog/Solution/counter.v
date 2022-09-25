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

//your code goes here

