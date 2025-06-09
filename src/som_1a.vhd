ENTITY som_1a IS
	PORT (a, b, cin : IN BIT;	 --entradas de dados a,b e carry-in
			y, cout	 : OUT BIT); --saida e carry-out
END som_1a;

ARCHITECTURE logic OF som_1a is
BEGIN
	y 	  <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END logic;