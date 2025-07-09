ENTITY mux3 IS
	GENERIC (width		  : INTEGER := 32);
	PORT 	  (d0, d1, d2 : IN BIT_VECTOR(width-1 DOWNTO 0);	 --entradas (32 bits)
				s	  		  : IN BIT_VECTOR (1 DOWNTO 0); 			--seletor
				y			  : OUT BIT_VECTOR(width-1 DOWNTO 0)); --saida (32 bits)
END mux3;

ARCHITECTURE logic OF mux3 IS
BEGIN
	WITH s SELECT
		y <= d0  				WHEN "00",
			  d1  				WHEN "01",
			  d2  				WHEN "10",
			  (OTHERS => '0') WHEN "11"; --para todos os bits do vetor eh atribuido '0'
END logic;
