LIBRARY ieee; USE ieee.std_logic_1164.all;

EnTITY full_adder IS
	PORT(A1, B1, Z1 : IN std_logic;
			S, C	:	OUT std_logic);
END full_adder;

ARCHITECTURE fulladder_body OF full_adder IS
BEGIN
	S<= A1 XOR B1 XOR Z1;
	C<= (A1 AND B1)OR(Z1 AND A1)OR(Z1 AND B1);
END fulladder_body;