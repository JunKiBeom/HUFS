LIBRARY ieee; USE ieee.std_logic_1164.all;

ENTITY bi_multi IS
	PORT(A1, A0, B1, B0 : IN std_logic; P3, P2, P1, P0 : OUT std_logic);
END bi_multi;

ARCHITECTURE bi_multi_body OF bi_multi IS
BEGIN
	P0 <= A0 AND B0;
	P1 <= (A1 AND B0) XOR (A0 AND B1);
	P2 <= (A1 AND B1) XOR ((A1 AND B0)AND(A0 AND B1));
	P3 <= (A1 AND B1) AND ((A1 AND B0)AND(A0 AND B1));
END bi_multi_body;
