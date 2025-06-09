ENTITY mux2 IS
	PORT (d0, d1 : IN BIT_VECTOR(31 DOWNTO 0); --entradas (32 bits)
			s		 : IN BIT;  							         --seletor
			y		 : OUT BIT_VECTOR(31 DOWNTO 0));   --saida (32 bits)
END mux2;

ARCHITECTURE logic OF mux2 IS
BEGIN                                                                                                                                                                                                           
	y <= d0 WHEN s = '0' ELSE
		  d1;
END logic;
