LIBRARY ieee; USE ieee.std_logic_1164.all;

ENTITY half_adder IS
	PORT(A,B : IN std_logic;
			S1,S2,C : OUT std_logic);
END half_adder;

ARCHITECTURE halfadder_body OF half_adder IS
BEGIN
	S1 <= (A or B) and not (A and B);
	S2 <= A XOR B;
	C <= A and B;
END halfadder_body;