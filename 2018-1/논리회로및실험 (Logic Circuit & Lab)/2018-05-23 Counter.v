// Implementation of 8 digit counter.

module Counter(
	RST, CLK,
	SEL, SEG7, SEG_COM,
);

input RST, CLK;
output [2:0]SEL;
output [6:0]SEG7;
output [7:0]SEG_COM;

reg [2:0]SEL;
reg [3:0]DATA_A,DATA_B,DATA_C,DATA_D;
reg [3:0]DATA_E,DATA_F,DATA_G,DATA_H;
reg [6:0]SEG7;
reg [7:0]SEG_COM;

always @(posedge RST or negedge CLK)
begin
	// fill the source code of counter
	if(RST)
		begin
			SEL=3'b000;
			DATA_A=4'b0000;
			DATA_B=4'b0000;
			DATA_C=4'b0000;
			DATA_D=4'b0000;
			DATA_E=4'b0000;
			DATA_F=4'b0000;
			DATA_G=4'b0000;
			DATA_H=4'b0000;
		end
	else
		begin
			SEL=SEL+1'b1;
			if(SEL>=3'b111)
				begin
					DATA_A=DATA_A+1'b1;
						if(DATA_A>4'b1001)
							begin
								DATA_A=4'b0000;
								DATA_B=DATA_B+1'b1;
								if(DATA_B>4'b1001)
									begin
										DATA_B=4'b0000;
										DATA_C=DATA_C+1'b1;
										if(DATA_C>4'b1001)
											begin
												DATA_C=4'b0000;
												DATA_D=DATA_D+1'b1;
												if(DATA_D>4'b1001)
													begin
														DATA_D=4'b0000;
														DATA_E=DATA_E+1'b1;
														if(DATA_E>4'b1001)
															begin
																DATA_E=4'b0000;
																DATA_F=DATA_F+1'b1;
																if(DATA_F>4'b1001)
																	begin
																		DATA_F=4'b0000;
																		DATA_G=DATA_G+1'b1;
																		if(DATA_G>4'b1001)
																			begin
																				DATA_G=4'b0000;
																				DATA_H=DATA_H+1'b1;
																				if(DATA_H>4'b1001)
																					begin
																						DATA_H=4'b0000;
																					end
																			end
																	end
															end
													end
											end
									end
							end
				end
		end
end

always @(SEL)
begin
	// fill the source code of multiplexer
	case(SEL)
		3'b000:SEG_COM=8'b01111111;
		3'b001:SEG_COM=8'b10111111;
		3'b010:SEG_COM=8'b11011111;
		3'b011:SEG_COM=8'b11101111;
		3'b100:SEG_COM=8'b11110111;
		3'b101:SEG_COM=8'b11111011;
		3'b110:SEG_COM=8'b11111101;
		3'b111:SEG_COM=8'b11111110;
		default:SEG_COM=8'b11111111;
	endcase
end

/* 
How to call the function?
Output = DEC4TO7(Input)
More information: https://www.nandland.com/verilog/examples/example-function-verilog.html
*/

function automatic [6:0] DEC4TO7; // function for decoding.
	input [3:0] I; 
	begin
		// fill the source code.
		// Decode input to output.
		case(I)
			4'b0000:DEC4TO7=7'b1111110; // 0
			4'b0001:DEC4TO7=7'b0110000; // 1
			4'b0010:DEC4TO7=7'b1101101; // 2
			4'b0011:DEC4TO7=7'b1111001; // 3
			4'b0100:DEC4TO7=7'b0110011; // 4
			4'b0101:DEC4TO7=7'b1011011; // 5
			4'b0110:DEC4TO7=7'b1011111; // 6
			4'b0111:DEC4TO7=7'b1110010; // 7
			4'b1000:DEC4TO7=7'b1111111; // 8
			4'b1001:DEC4TO7=7'b1110011; // 9
			default:DEC4TO7=7'b1111110;
		endcase
	end
endfunction
  
always @(SEL) 
begin
	// fill the source code for present each 7segments.
	case(SEL)
		3'b000:SEG7=DEC4TO7(DATA_A);
		3'b001:SEG7=DEC4TO7(DATA_B);
		3'b010:SEG7=DEC4TO7(DATA_C);
		3'b011:SEG7=DEC4TO7(DATA_D);
		3'b100:SEG7=DEC4TO7(DATA_E);
		3'b101:SEG7=DEC4TO7(DATA_F);
		3'b110:SEG7=DEC4TO7(DATA_G);
		3'b111:SEG7=DEC4TO7(DATA_H);
		default:SEG7=DEC4TO7(4'b0000);
	endcase
end
endmodule
