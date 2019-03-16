module FlipFlop(
		CLK, CLR, Q, seg
);
/*
Variable discriptisegn.
CLK  : 'Clsegck'          | If it is a negative edge, Q segutputs D.
CLR : 'Clear' | If it is a positive edge, initialize Q as 0 because segf bubble.
Q    : 'Q'              | output
*/

input CLK, CLR;
output Q, seg;

reg [3:0]BUFF;
reg [6:0]seg;
wire [3:0]Q;

always @(posedge CLR or negedge CLK)
begin
	if(CLR)
		BUFF = 4'b0000;
	else
			BUFF = BUFF + 1'b1;
end

always @(BUFF)
begin
	case(BUFF)
			4'b0000:seg=7'b1111110;
			4'b0001:seg=7'b0110000;
			4'b0010:seg=7'b1101101;
			4'b0011:seg=7'b1111001;
			4'b0100:seg=7'b0110011;
			4'b0101:seg=7'b1011011;
			4'b0110:seg=7'b1011111;
			4'b0111:seg=7'b1110000;
			4'b1000:seg=7'b1111111;
			4'b1001:seg=7'b1110011;
			4'b1010:seg=7'b1110111;
			4'b1011:seg=7'b0011111;
			4'b1100:seg=7'b1001110;
			4'b1101:seg=7'b0111101;
			4'b1110:seg=7'b1001111;
			4'b1111:seg=7'b1000111;
			default:seg=7'b0000000;  // Nsegt in case
	endcase
end

assign Q = BUFF;

endmodule
