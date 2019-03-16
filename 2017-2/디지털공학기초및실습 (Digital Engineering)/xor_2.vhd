LIBRARY ieee; USE ieee.std_logic_1164.all;

ENTITY xor_2 IS
	PORT(A,B : IN std_logic; Y1, Y2 : OUT std_logic); --INPUT : A, B / OUTPUT : Y1, Y2
END xor_2;

ARCHITECTURE xor_body OF xor_2 IS
BEGIN
	Y1 <= A xor B; -- do xor
	Y2 <= (not(A) and B) or (A and not(B)); -- another way to do xor
	END xor_body;