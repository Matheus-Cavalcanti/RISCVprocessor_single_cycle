ENTITY mux2 IS
	GENERIC (width	 : INTEGER := 32);
	PORT	  (d0, d1 : IN BIT_VECTOR(width-1 DOWNTO 0);	  --entradas (32 bits)
				s		 : IN BIT;									  --seletor
				y		 : OUT BIT_VECTOR(width-1 DOWNTO 0)); --saida (32 bits)
END mux2;

ARCHITECTURE logic OF mux2 IS
BEGIN                                                                                                                                                                                                           
	y <= d0 WHEN s = '0' ELSE
		  d1;
END logic;
