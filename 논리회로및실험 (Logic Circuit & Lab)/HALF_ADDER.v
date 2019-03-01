//HALF_ADDER;

module HALF_ADDER(
	X,Y,S,C
);

input X,Y;
output S,C;

assign S = X ^ Y;
assign C = X & Y;

endmodule