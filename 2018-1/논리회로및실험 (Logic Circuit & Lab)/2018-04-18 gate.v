//gate.V

module gate(
	A,B,C,D,
	W,X,Y,Z
);

 input A,B,C,D;
 output W,X,Y,Z;

 assign W = ~(~(A&~B) & ~(~C&~D) & ~(A&~D)); //NAND - AND
 assign X = ~(~((~C&~D) | (A&~B) | (A&~D))); //AND - NOR
 assign Y = ~((~A|B) & (C|D) & (~A|D)); //OR-NAND
 assign Z = ~(C|D) | ~(~A|B)| ~(~A|D); //NOR-OR
endmodule
