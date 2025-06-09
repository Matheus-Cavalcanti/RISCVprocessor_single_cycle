-------------------------------------------------------------------------------
-- RISC-V Package (riscv_pkg)
--
-- Description:
--   This package contains essential components and functions for RISC-V processor
--   implementation. It includes:
--     - Common constants (RISCV_Data_Width)
--     - Basic components (mux2, mux3, flopr, adder, alu)
--     - Arithmetic operators (+ and -) for BIT_VECTOR type
--
-- Usage:
--   This package must be added to library 'bibli_1' before use.
--   Add the following to your project:
--     1. Save this file as 'riscv_pkg.vhd'
--     2. Add to library: 'bibli_1'
--		 3. Import with:
--		    	LIBRARY bibli_1;
--				USE bibli_1.riscv_pkg.<desired object>;
--
-- Components:
--   mux2  : 2-input multiplexer
--   mux3  : 3-input multiplexer
--   flopr : Flip-flop with asynchronous reset
--   adder : N-bit adder with carry in/out
--   alu   : Arithmetic Logic Unit (32-bit)
--
-- Functions:
--   "+" : Bitwise addition with carry propagation
--   "-" : Bitwise subtraction with borrow propagation
--
-- Note:
--   All operations use BIT_VECTOR type with RISCV_Data_Width (32 bits)
--
-- Authors:
-- 	Matheus Cavalcanti de Santana / 13217506
-- 	Gabriel Dezajacomo Maruschi / 14571525
-- 	Santhiago Aguiar Afonso da Rosa / 14607274
-- Date: 06/05/2025
-- Course: SEL0632 - Hardware Description Languages
-- University: University of Sao Paulo
-------------------------------------------------------------------------------

PACKAGE riscv_pkg IS
	CONSTANT RISCV_Data_Width : INTEGER := 32; -- bus width
	
	COMPONENT mux2 PORT (d0, d1 : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
								s		 : IN BIT;
								y		 : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT mux3 PORT (d0, d1, d2 : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
								s0, s1 	  : IN BIT;
								y		 	  : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT flopr PORT (d				: IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
								 clk, reset : IN BIT; 
								 q			   : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT adder PORT (a, b : IN BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0);
								 cin	: IN BIT;
								 y		: OUT BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0);
								 cout : OUT BIT );
	END COMPONENT;
	
	COMPONENT alu PORT (A, B 		 : IN BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0);
							  ALUControl : IN BIT_VECTOR (2 DOWNTO 0);
							  Result	    : BUFFER BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0);
							  Zero		 : OUT BIT);
	END COMPONENT;
	
	FUNCTION "+" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR;
	FUNCTION "-" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR;
END riscv_pkg;

PACKAGE BODY riscv_pkg IS

	FUNCTION "+" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR IS
		VARIABLE s : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0); -- sum result
		VARIABLE c : BIT := '0';					 -- internal carry
	BEGIN	
		
		sum: FOR i IN 0 TO RISCV_Data_Width-1 LOOP
			s(i) := x(i) XOR y(i) XOR c;
			c	  := (x(i) AND y(i)) OR (x(i) AND c) OR (y(i) AND c);
		END LOOP;
		
		RETURN s; 	
	END "+";

	FUNCTION "-" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR IS
		VARIABLE s : BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0); -- sub result
		VARIABLE b : BIT := '0';					-- internal borrow
	BEGIN
		
		sub: FOR i IN 0 TO RISCV_Data_Width-1 LOOP
			s(i) := x(i) XOR y(i) XOR b;
			b	  := ((NOT x(i)) AND y(i)) OR ((NOT x(i)) AND b) OR (y(i) AND b);
		END LOOP;
		
		RETURN s;
	END "-";
	
END riscv_pkg;