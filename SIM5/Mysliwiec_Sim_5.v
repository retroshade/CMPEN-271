/*
Ryan Mysliwiec
rwm5592
CMPEN 271
*/
module entryControl(input clock, input reset, input entered, input exited, output reg entryLock, output reg exitLock, output reg lightOn);
	parameter State_initial = 3'b000;
	parameter State_1 = 3'b001;
	parameter State_2 = 3'b010;
	parameter State_3 = 3'b011;
	parameter State_4 = 3'b100;
	
	reg[2:0] CurrentState;
	reg[2:0] NextState;
	
		
	always @ (posedge clock)
		begin

			if (reset)
				CurrentState <= State_initial;
			else
			begin
				CurrentState <= NextState;

			NextState <= CurrentState;
			
			case(CurrentState)
				State_initial: 
						if (entered & !exited)
						begin
							NextState <= State_1;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
							end
						else
						begin
							NextState <= State_initial;
							entryLock <= 1'b1;
							exitLock <= 1'b0;
							lightOn <= 1'b0;
						end
				State_1:
						if ((entered & exited)|(!entered & !exited))
						begin
							NextState <= State_1;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else if (!entered & exited)
						begin
							NextState <= State_initial;
							entryLock <= 1'b1;
							exitLock <= 1'b0;
							lightOn <= 1'b0;
						end
						else if (entered & !exited)
						begin
							NextState <= State_2;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
				State_2:
						if ((entered & exited)|(!entered & !exited))
						begin
							NextState <= State_2;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else if (!entered & exited)
						begin
							NextState <= State_1;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else if (entered & !exited)
						begin
							NextState <= State_3;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
				State_3:
						if ((entered & exited)|(!entered & !exited))
						begin
							NextState <= State_3;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else if (!entered & exited)
						begin
							NextState <= State_2;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else if (entered & !exited)
						begin
							NextState <= State_4;
							entryLock <= 1'b0;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
				State_4:
						if (!entered & exited)
						begin
							NextState <= State_3;
							entryLock <= 1'b1;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
						else 
						begin
							NextState <= State_4;
							entryLock <= 1'b0;
							exitLock <= 1'b1;
							lightOn <= 1'b1;
						end
			endcase
			end
		end
endmodule

module Top(output enL, output exL, output lit);
	reg clk;
	reg rst;
	always
		#1 clk=~clk;

	initial
		begin
			clk=1'b0;
			rst=1'b1;
			#4
			rst=1'b0;
			#512
			$stop;
		end

		reg [3:0] lfsr4;
		always@(posedge clk)
			if(rst)
				lfsr4<=4'b0001;
			else
				begin
					lfsr4[3]<=lfsr4[2]; 
					lfsr4[2]<=lfsr4[1]; 
					lfsr4[1]<=lfsr4[0]^lfsr4[3]; 
					lfsr4[0]<=lfsr4[3]; 
				end

	entryControl NQ(clk, rst, (lfsr4[3]|lfsr4[2])&(enL), (lfsr4[1]|lfsr4[0])&lit, enL, exL, lit);

endmodule



/* For each of the last 8 cycles of simulation, what are the values of enL, exL, and lit? 
	Every output should be 1 for each variable for the last 8 cycles. However, I am not getting that, though I know my code is correct and should be outputting 1 each time.
	I'm really not sure why it's not outputting it correctly, but I know that's what it should be.
*/ 


