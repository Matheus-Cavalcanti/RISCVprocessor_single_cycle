ENTITY adder IS
	GENERIC (width	: INTEGER := 32);						-- n of bits
	PORT 	  (a, b  : IN BIT_VECTOR (width-1 DOWNTO 0);	-- inputs (n bits)
				cin	: IN BIT;								-- carry-in
				y		: OUT BIT_VECTOR (width-1 DOWNTO 0); -- output (n bits)
				cout  : OUT BIT );							-- carry-out
END adder;

ARCHITECTURE logic OF adder IS

COMPONENT som_1a					  -- 1 bit adder component
	PORT (a, b, cin : IN BIT;	  -- inputs and carry-in
			y, cout	 : OUT BIT ); -- output and carry-out
END COMPONENT;

SIGNAL v : BIT_VECTOR (width DOWNTO 0); -- internal signal to internal carries

BEGIN

	v(0) <= cin;  -- in the 1st iteration v(i=0) is the carry-in 
	cout <= v(width); -- the carry-out receives the last internal carry-out
	
	sum: FOR i IN 0 TO width-1 GENERATE
		element: som_1a PORT MAP (a => a(i),b => b(i),cin => v(i),y => y(i), cout => v(i+1));
	END GENERATE sum;

END logic;
