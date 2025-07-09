-------------------------------------------------------------------------------
-- RISC-V Package (riscv_pkg)
--
-- Description:
--   This package contains essential components and functions for RISC-V processor
--   implementation. It includes:
--     - Common constants (RISCV_Data_Width, ZERO_VECTOR)
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
	
	CONSTANT ZERO_VECTOR : BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0) := (OTHERS => '0'); -- null vector for comparison
	
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
	
	COMPONENT regfile PORT (A1, A2, A3 : IN BIT_VECTOR(4 DOWNTO 0); 
									WD3		  : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
									WE3, clk	  : IN BIT;
									RD1,RD2	  : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT extend PORT (immsrc  : IN  BIT_VECTOR(1 DOWNTO 0);
								  instr   : IN  BIT_VECTOR(24 DOWNTO 0);
								  immext  : OUT BIT_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT aludec PORT (ALUOp     : IN  BIT_VECTOR(1 DOWNTO 0);
								  funct3    : IN  BIT_VECTOR(2 DOWNTO 0);
								  opb5      : IN  BIT;
								  funct7b5  : IN  BIT;
								  ALUControl: OUT BIT_VECTOR(2 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT controller PORT(op: in BIT_VECTOR(6 downto 0);
									  funct3: in BIT_VECTOR(2 downto 0);
									  funct7b5, Zero: in BIT;
									  ResultSrc: out BIT_VECTOR(1 downto 0);
									  MemWrite: out BIT;
									  PCSrc, ALUSrc: out BIT;
									  RegWrite: out BIT;
									  Jump: buffer BIT;
									  ImmSrc: out BIT_VECTOR(1 downto 0);
									  ALUControl: out BIT_VECTOR(2 downto 0));
	END COMPONENT;
	
	COMPONENT datapath PORT(clk, reset: in BIT;
									ResultSrc: in BIT_VECTOR(1 downto 0);
									PCSrc, ALUSrc: in BIT;
									RegWrite: in BIT;
									ImmSrc: in BIT_VECTOR(1 downto 0);
									ALUControl: in BIT_VECTOR(2 downto 0);
									Zero: out BIT;
									PC: buffer BIT_VECTOR(31 downto 0);
									Instr: in BIT_VECTOR(31 downto 0);
									ALUResult, WriteData: buffer BIT_VECTOR(31 downto 0);
									ReadData: in BIT_VECTOR(31 downto 0));
	END COMPONENT;
	
	COMPONENT dmem PORT(clk, we: in BIT;
							  a, wd: in BIT_VECTOR(31 downto 0);
							  rd: out BIT_VECTOR(31 downto 0));
	END COMPONENT;
	
	COMPONENT imem PORT(a: in BIT_VECTOR(31 downto 0);
							  rd: out BIT_VECTOR(31 downto 0));
	END COMPONENT;
	
	COMPONENT maindec PORT(op: in BIT_VECTOR(6 downto 0);
								  ResultSrc: out BIT_VECTOR(1 downto 0);
								  MemWrite: out BIT;
								  Branch, ALUSrc: out BIT;
								  RegWrite, Jump: out BIT;
								  ImmSrc: out BIT_VECTOR(1 downto 0);
								  ALUOp: out BIT_VECTOR(1 downto 0));
	END COMPONENT;
	
	COMPONENT riscvsingle PORT(clk, reset: in BIT;
										PC: out BIT_VECTOR(31 downto 0);
										Instr: in BIT_VECTOR(31 downto 0);
										MemWrite: out BIT;
										ALUResult, WriteData: out BIT_VECTOR(31 downto 0);
										ReadData: in BIT_VECTOR(31 downto 0));
	END COMPONENT;
	
	COMPONENT top PORT(clk, reset: in BIT;
							 WriteData, DataAdr: buffer BIT_VECTOR(31 downto 0);
							 MemWrite: buffer BIT);
	END COMPONENT;
	
	FUNCTION "+" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR;
	FUNCTION "-" (x, y : BIT_VECTOR (RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR;
	
	FUNCTION BTOI(x : BIT_VECTOR) RETURN INTEGER;
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
	
	FUNCTION BTOI (x : BIT_VECTOR) RETURN INTEGER IS
		VARIABLE r : INTEGER := 0;
	BEGIN
		FOR i IN x'RANGE LOOP
			r := r * 2; -- shift the actual value
			IF x(i) = '1' THEN
				r := r + 1; -- add the actual bit
			END IF;
		END LOOP;
		
		RETURN r;
	END BTOI;
	
END riscv_pkg;
