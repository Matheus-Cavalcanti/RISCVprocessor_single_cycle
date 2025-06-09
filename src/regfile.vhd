LIBRARY bibli_1;
USE bibli_1.riscv_pkg.RISCV_Data_Width;

ENTITY regfile IS
	PORT (A1, A2, A3, WD3 : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
			WE3				 : IN BIT;
			clk				 : IN BIT);
END regfile;

ARCHITECTURE logic OF regfile IS
	
	
	
END logic;