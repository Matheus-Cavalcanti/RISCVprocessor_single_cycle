-------------------------------------------------------------------------------
-- ALU (Arithmetic Logic Unit) - RISC-V Single Cycle
-- 
-- Description:
--   32-bit Arithmetic Logic Unit compatible with RISC-V.
--   Supports basic operations: ADD, SUB, AND, OR, SLT.
--   SLT (Set Less Than) operation is performed in two's complement.
--
-- Inputs:
--   A, B         - 32-bit operands
--   ALUControl   - 3-bit control signal for operation selection:
--                  000: ADD
--                  001: SUB
--                  010: AND
--                  011: OR
--                  101: SLT
--                  others: ZERO
--
-- Outputs:
--   Result       - Operation result (32 bits)
--   Zero         - Flag '1' when Result = 0
--
-- Notes:
--   - Arithmetic operations use two's complement
--   - SLT returns 1 when A < B (signed), 0 otherwise
--   - Internal functions implement bitwise adder and subtractor
--
-- Authors:
-- 	Matheus Cavalcanti de Santana / 13217506
-- 	Gabriel Dezajacomo Maruschi / 14571525
-- 	Santhiago Aguiar Afonso da Rosa / 14607274
-- Date: 06/02/2025
-- Course: SEL0632 - Hardware Description Languages
-- University: University of Sao Paulo
-------------------------------------------------------------------------------

LIBRARY bibli_1;
USE bibli_1.riscv_pkg.ALL;

ENTITY alu IS
	GENERIC (width : INTEGER := 32);
	PORT (A, B 		  : IN BIT_VECTOR (width-1 DOWNTO 0);
			ALUControl : IN BIT_VECTOR (2 DOWNTO 0);
			Result	  : BUFFER BIT_VECTOR (width-1 DOWNTO 0);
			Zero		  : OUT BIT);
end alu;

ARCHITECTURE logic OF alu IS
	
	FUNCTION SLT (x, y : BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0)) RETURN BIT_VECTOR IS
		 VARIABLE r : BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0) := (OTHERS => '0'); -- result
		 VARIABLE sub : BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);			  			  -- internal sub result
	BEGIN
		 
		 sub := x - y; -- A - B
		 
		 -- If MSB (signal bit) = 1, then A < B
		 IF sub(RISCV_Data_Width-1) = '1' THEN
			  r(0) := '1';  -- SLT = 1 (A < B)
		 END IF;
		 
		 RETURN r;
	END SLT;
	
BEGIN
	WITH ALUControl SELECT
		Result <= A + B	  WHEN "000",
					 A - B	  WHEN "001",
					 A AND B	  WHEN "010",
					 A OR B    WHEN "011",
					 SLT(A, B) WHEN "101",
					 ZERO_VECTOR WHEN OTHERS;
	Zero <= '1' WHEN Result = ZERO_VECTOR ELSE '0';
	
END logic; 
