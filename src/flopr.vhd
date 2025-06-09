ENTITY flopr IS
	PORT (d 			  : IN BIT_VECTOR(31 DOWNTO 0);	 --entrada (32 bits)
			clk, reset : IN BIT; 							 --entradas de controle
			q			  : OUT BIT_VECTOR(31 DOWNTO 0)); --saida (32 bits)
END flopr;

ARCHITECTURE logic OF flopr IS
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') 					  THEN q <= (OTHERS => '0'); --q recebe 0 independente de clk
		ELSIF (cLk'EVENT AND cLk = '1') THEN q <= d;
		END IF;
	END PROCESS;
END logic;
