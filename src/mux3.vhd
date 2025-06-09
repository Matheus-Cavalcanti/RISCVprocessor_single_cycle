ENTITY mux3 IS
	PORT (d0, d1, d2 : IN BIT_VECTOR(31 DOWNTO 0);	 --entradas (32 bits)
			s0, s1	  : IN BIT; 							 --seletor
			y			  : OUT BIT_VECTOR(31 DOWNTO 0)); --saida (32 bits)
END mux3;

ARCHITECTURE logic OF mux3 IS
	SIGNAL sel : BIT_VECTOR (1 DOWNTO 0);
BEGIN
	sel <= s1 & s0;
	WITH sel SELECT
		y <= d0  				WHEN "00",
			  d1  				WHEN "01",
			  d2  				WHEN "10",
			  (OTHERS => '0') WHEN "11"; --para todos os bits do vetor eh atribuido '0'
END logic;