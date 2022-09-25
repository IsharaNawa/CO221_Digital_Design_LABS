module SR_Latch(Q,Qbar,S,R,Set,Reset); //SbarRbar Latch with Reset

	output Q,Qbar;
	input S,R,Set,Reset;
	
	nand (Q,S,Qbar,~Set);
	nand (Qbar,Q,R,~Reset);

endmodule

module D_latch(Q,Qbar,D,En,Set,Reset); //tested passed-withot reset

	output Q,Qbar;
	input D,En,Set,Reset;
	
	wire S,R;
	
	nand (S,D,En);
	nand (R,~D,En);
	
	SR_Latch l(Q,Qbar,S,R,Set,Reset);
	
endmodule

module D_FlipFlop(Q,D,clk,Set,Reset); //not tested

	output Q;
	input D,clk,Set,Reset;
	
	wire Y,X,Z,s,r,Qbar;
	
	D_latch master(Y,X,D,clk,1'b0,1'b0);
	D_latch slave(Q,Qbar,Y,~clk);
	
endmodule

module T_FlipFlop(Q,T,clk,Set,Reset); //not tested

	output Q;
	input T,clk;
	
	wire D,Qbar;
	
	xor (D,T,Q);
	
	D_FlipFlop dff(Q,D,clk,Set,Reset);
	
endmodule


module rippleCounter4(a,counter,reset);

	output [0:3] a;
	input counter;
	
	T_FlipFlop t0(a[0],1'b1,counter,1'b0,reset);
	T_FlipFlop t1(a[1],1'b1,a[0],1'b0,reset);
	T_FlipFlop t2(a[2],1'b1,a[1],1'b0,reset);
	T_FlipFlop t3(a[3],1'b1,a[2],1'b0,reset);
	
endmodule

	