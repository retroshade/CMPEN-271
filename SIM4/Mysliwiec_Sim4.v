//Ryan Mysliwiec
//CMPEN 271
//Simulation Assignment 4

//Module for RS Latch
module rs_latch(r, s, clk, q, nq);
	input r, s, clk;
	output reg q, nq;
	wire w1, w2;
	
	and a1(R, r, clk);
	and a2(S, s, clk);
	nor n1(q, r, nq);
	nor n2(nq, s, q);
endmodule

//Module for NegEdge JK FF
module jk_FF_neg (j,k,clk,q,qn);
	input j,k,clk;
	output reg q;
	output nq;
 
	assign qn = ~q;

	always @ (negedge clk)
		begin
			//when j == 0 and k == 0, q = q, which is not a needed statement
		   if (j == 0 && k == 1)
				q <= 0;
		   else if (j == 1 && k == 0)
				q <= 1;
			else if (j == 1 && k == 1)
				q <= ~q;
		end
endmodule

//Module for DFF with asynchronous reset, aynchrounous enable
module d_FF_asyncr_synce (d,clk,rst,e,q,qb);
	input d, clk, rst,e;
	output reg q; 
	output qb;
 
	assign qb = ~q;
 
	always @ (posedge rst, negedge clk)
		begin
			if (rst)
				q<=0;
			else if (e)
			q<=d;
		end
endmodule

//Module for posedge D FF, master-slave pattern
module d_FF_master_slave (d,clk,q,qb);
	 input d,clk;
	 output q,qb;
	 wire a,b; // b is a dummy variable, it goes to nothing
	 
	 d_latch slave  (a,~clk,q,qb);
	 d_latch master (d,clk,a,b);
 
endmodule

//Module for D latch in the master-slave FF
module d_latch(d,clk,q,qb);
	 input d,clk;
	 output reg q;
	 output qb;
	 
	 assign qb = ~q;
	 
	 always @ (d,clk)
		begin
			if (clk)
				q <= d;
		end 
endmodule


module Top;
	//create inputs and outputs
	 reg r; //doubles as k for jk
	 reg s; //doubles as j for jk
	 reg d; //same for task 1c and 1d
	 reg e;
	 reg resetn;
	 reg clkSlow;
	 reg clkFast;
	 reg [7:0] count;
	 wire q;
	 wire notq;
	 
	 //1a
	 rs_latch                	test_latch(r,s,clkSlow,q,notq);
	 //1b
	 jk_FF_neg        			test_jk_ff(s,r,clkSlow,q,notq);
	 //1c
	 d_FF_asyncr_synce			test_dffae(d,clkSlow,resetn,e,q,notq);
	 //1d
	 d_FF_master_slave			test_ff_ms(d,clkSlow,q,notq);
 
	 initial
		begin
			clkSlow = 0;
			clkFast = 0;
			r = 0;
			s = 0;
			d = 0;
			e = 0;
			resetn = 0;
			count[0] = 0;
		end
  
	 initial   #100  $finish;
		  always #7  clkSlow = ~clkSlow;
		  always #2  clkFast = ~clkFast;
		  always #10  r   	= ~r;
		  always #12  s   	= ~s;
		  always #10  d   	= ~d;
		  always #12  e   	= ~e;
		  always #15  resetn  = ~resetn;
  
	always @ (posedge clkFast)
		 begin
			  if(resetn)
					count <= 8'h00;
			  else
					count <= count + 8'h01;
		 end
  
endmodule
