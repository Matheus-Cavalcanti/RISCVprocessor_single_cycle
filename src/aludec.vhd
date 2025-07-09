-------------------------------------------------------------------------------
-- ALU Decoder (aludec) - RISC-V Single Cycle
-- 
-- Description:
--   Decodes ALU control signals based on instruction type and function fields.
--   Determines the operation to be performed by the ALU unit.
--
-- Inputs:
--   ALUOp      - 2-bit control signal indicating instruction type:
--                00: Load/Store (lw/sw)
--                01: Branch (beq)
--                10: R-type/I-type arithmetic
--   funct3     - 3-bit function field from instruction
--   opb5       - Bit 5 of opcode (distinguishes I-type from R-type)
--   funct7b5   - Bit 5 of funct7 field (distinguishes sub from add)
--
-- Outputs:
--   ALUControl - 3-bit control signal for ALU operation:
--                000: ADD
--                001: SUB
--                010: AND
--                011: OR
--                101: SLT (Set Less Than)
--
-- Operation:
--   Implements the control logic as per the provided truth table:
--   +--------+---------+------------------+-------------+--------------+
--   | ALUOp  | funct3  | {opb5, funct7b5} | ALUControl  | Instruction  |
--   +--------+---------+------------------+-------------+--------------+
--   | 00     | x       | x                | 000 (add)   | lw, sw       |
--   | 01     | x       | x                | 001 (sub)   | beq          |
--   | 10     | 000     | 00,01,10         | 000 (add)   | add          |
--   | 10     | 000     | 11               | 001 (sub)   | sub          |
--   | 10     | 010     | x                | 101 (slt)   | slt          |
--   | 10     | 110     | x                | 011 (or)    | or           |
--   | 10     | 111     | x                | 010 (and)   | and          |
--   +--------+---------+------------------+-------------+--------------+
--
-- Authors:
-- 	Matheus Cavalcanti de Santana / 13217506
-- 	Gabriel Dezajacomo Maruschi / 14571525
-- 	Santhiago Aguiar Afonso da Rosa / 14607274
-- Date: 06/23/2025
-- Course: SEL0632 - Hardware Description Languages
-- University: University of Sao Paulo
-------------------------------------------------------------------------------

ENTITY aludec IS
    PORT (
        ALUOp     : IN  BIT_VECTOR(1 DOWNTO 0);
        funct3    : IN  BIT_VECTOR(2 DOWNTO 0);
        opb5      : IN  BIT;
        funct7b5  : IN  BIT;
        ALUControl: OUT BIT_VECTOR(2 DOWNTO 0)
    );
END ENTITY aludec;

ARCHITECTURE logic OF aludec IS
    SIGNAL op_funct7 : BIT_VECTOR(1 DOWNTO 0);
BEGIN
    -- combine opb5 and funct7b5 into a single vector
    op_funct7 <= opb5 & funct7b5;
    
    PROCESS(ALUOp, funct3, op_funct7)
    BEGIN
        CASE ALUOp IS
            -- load/store instructions
            WHEN "00" => 
                ALUControl <= "000";  -- ADD
                
            -- branch instructions
            WHEN "01" => 
                ALUControl <= "001";  -- SUB
                
            -- r-type/i-type instructions
            WHEN "10" => 
                CASE funct3 IS
                    -- ADD/SUB
                    WHEN "000" => 
                        IF op_funct7 = "11" THEN 
                            ALUControl <= "001";  -- SUB
                        ELSE 
                            ALUControl <= "000";  -- ADD
                        END IF;
                        
                    -- SLT
                    WHEN "010" => 
                        ALUControl <= "101";
                        
                    -- OR
                    WHEN "110" => 
                        ALUControl <= "011";
                        
                    -- AND
                    WHEN "111" => 
                        ALUControl <= "010";
                        
                    -- default: ADD for undefined funct3
                    WHEN OTHERS => 
                        ALUControl <= "000";  -- ADD
                END CASE;
                
            -- default: ADD for undefined ALUOp
            WHEN OTHERS => 
                ALUControl <= "000";  -- ADD
        END CASE;
    END PROCESS;
END ARCHITECTURE logic;