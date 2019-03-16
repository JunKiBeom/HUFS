//gate.v

module gate(A,B,X);
input A,B;
output X;

assign X= (A & (! B)) | ((! A) & B);

endmodule
