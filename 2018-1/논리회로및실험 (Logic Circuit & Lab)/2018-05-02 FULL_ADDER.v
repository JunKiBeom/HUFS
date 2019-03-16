//FULL_ADDER;

module FULL_ADDER(
	XF,YF,ZF,SF,CF
);

input XF,YF,ZF;
output SF,CF;


wire REG_SUM;
wire REG_C1, REG_C2;

HALF_ADDER UNIT1(.X(XF),.Y(YF),.S(REG_SUM),.C(REG_C1));
HALF_ADDER UNIT2(.X(ZF),.Y(REG_SUM),.S(SF),.C(REG_C2));

assign CF = REG_C1 | REG_C2;

endmodule
