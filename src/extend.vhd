-------------------------------------------------------------------------------
-- Immediate Sign Extender - RISC-V Single Cycle
-- 
-- Description:
--   Extends various types of immediate values from 25-bit instruction fields
--   to 32-bit signed values. Supports four instruction formats: I, S, B, J.
--   Performs sign extension using the MSB (bit 31) of the instruction.
--
-- Inputs:
--   immsrc    - 2-bit control signal for immediate type selection:
--               00: I-type (12-bit immediate)
--               01: S-type (12-bit immediate)
--               10: B-type (13-bit immediate)
--               11: J-type (21-bit immediate)
--   instr     - 25-bit instruction field (bits 31-7 of full instruction)
--
-- Outputs:
--   immext    - 32-bit sign-extended immediate value
--
-- Operation:
--   For each instruction type, specific bits from the instruction field
--   are concatenated and sign-extended to form a 32-bit value:
--     I-type: {20{instr[31]}, instr[31:20]}
--     S-type: {20{instr[31]}, instr[31:25], instr[11:7]}
--     B-type: {19{instr[31]}, instr[31], instr[7], instr[30:25], instr[11:8], 0}
--     J-type: {11{instr[31]}, instr[31], instr[19:12], instr[20], instr[30:21], 0}
--
-- Implementation:
--   Uses aliases for clear bitfield identification and concatenation
--   Sign extension performed through aggregate assignments
--   Combinatorial logic with case statement for type selection
--
-- Authors:
-- 	Matheus Cavalcanti de Santana / 13217506
-- 	Gabriel Dezajacomo Maruschi / 14571525
-- 	Santhiago Aguiar Afonso da Rosa / 14607274
-- Date: 22/02/2025
-- Course: SEL0632 - Hardware Description Languages
-- University: University of Sao Paulo
-------------------------------------------------------------------------------

ENTITY extend IS
    PORT (
        immsrc  : IN  BIT_VECTOR(1 DOWNTO 0);    -- 2-bit control signal
        instr   : IN  BIT_VECTOR(24 DOWNTO 0);   -- 25-bit instruction field
        immext  : OUT BIT_VECTOR(31 DOWNTO 0)    -- 32-bit extended output
    );
END ENTITY extend;

ARCHITECTURE logic OF extend IS
    -- common sign bit (instruction bit 31)
    ALIAS sign_bit: BIT IS instr(24);
    
    -- declare all possible aliases
    ALIAS I_imm: BIT_VECTOR(11 DOWNTO 0) IS instr(24 DOWNTO 13);
    
    ALIAS S_imm_high: BIT_VECTOR(6 DOWNTO 0) IS instr(24 DOWNTO 18);
    ALIAS S_imm_low: BIT_VECTOR(4 DOWNTO 0) IS instr(4 DOWNTO 0);
    
    ALIAS B_imm_7: BIT IS instr(0);
    ALIAS B_imm_30_25: BIT_VECTOR(5 DOWNTO 0) IS instr(23 DOWNTO 18);
    ALIAS B_imm_11_8: BIT_VECTOR(3 DOWNTO 0) IS instr(4 DOWNTO 1);
    
    ALIAS J_imm_19_12: BIT_VECTOR(7 DOWNTO 0) IS instr(12 DOWNTO 5);
    ALIAS J_imm_20: BIT IS instr(13);
    ALIAS J_imm_30_21: BIT_VECTOR(9 DOWNTO 0) IS instr(23 DOWNTO 14);
BEGIN
    -- immediate extension process
    PROCESS(immsrc, instr)
    BEGIN
        CASE immsrc IS
            -- i-type immediate (12-bit)
            WHEN "00" => 
                immext <= (31 DOWNTO 12 => sign_bit) & I_imm;
                
            -- s-type immediate (12-bit)
            WHEN "01" => 
                immext <= (31 DOWNTO 12 => sign_bit) & S_imm_high & S_imm_low;
                
            -- B-type immediate (13-bit with LSB=0)
            WHEN "10" => 
                immext <= (31 DOWNTO 13 => sign_bit) & 
                          sign_bit & B_imm_7 & B_imm_30_25 & B_imm_11_8 & '0';
                
            -- j-type immediate (21-bit with LSB=0)
            WHEN "11" => 
                immext <= (31 DOWNTO 20 => sign_bit) & 
                          J_imm_19_12 & J_imm_20 & J_imm_30_21 & '0';
                          
            -- default case (output zero)
            WHEN OTHERS =>
                immext <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END ARCHITECTURE logic;