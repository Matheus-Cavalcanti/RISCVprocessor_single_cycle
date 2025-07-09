-------------------------------------------------------------------------------
-- Register File (regfile) - RISC-V Single Cycle
-- 
-- Description:
--   32-register bank with 32-bit registers. Register 0 is hardwired to zero.
--   Asynchronous read, synchronous write (on rising clock edge) when WE3 is active.
--   Implements the core register file for RISC-V processor.
--
-- Inputs:
--   A1, A2, A3  - 5-bit addresses for reading two ports and writing one port
--   WD3         - 32-bit data input for writing
--   WE3         - Write enable signal
--   clk         - Clock signal
--
-- Outputs:
--   RD1, RD2    - 32-bit data outputs for the registers addressed by A1 and A2
--
-- Implementation:
--   - Register 0 (x0) is implemented as constant zero
--   - Registers 1-31 use flopr components with selective clock enable
--   - Write operations occur only on rising clock edge when WE3 = '1'
--   - Read operations are asynchronous and combinatorial
--   - Includes BIT_VECTOR to INTEGER conversion function
--
-- Authors:
-- 	Matheus Cavalcanti de Santana / 13217506
-- 	Gabriel Dezajacomo Maruschi / 14571525
-- 	Santhiago Aguiar Afonso da Rosa / 14607274
-- Date: 22/02/2025
-- Course: SEL0632 - Hardware Description Languages
-- University: University of Sao Paulo
-------------------------------------------------------------------------------

LIBRARY bibli_1;
USE bibli_1.riscv_pkg.ALL;

ENTITY regfile IS
	GENERIC (width		  : INTEGER := 32); -- n of registers
	PORT	  (A1, A2, A3 : IN BIT_VECTOR(4 DOWNTO 0); 
				WD3		  : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
				WE3, clk	  : IN BIT;
				RD1,RD2	  : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
END regfile;

ARCHITECTURE logic OF regfile IS
    TYPE reg_array IS ARRAY (0 TO 31) OF BIT_VECTOR(width-1 DOWNTO 0); -- register array (N bits)
    SIGNAL regs : reg_array;
     
    SIGNAL write_enable_reg : BIT_VECTOR(31 DOWNTO 0);  -- enable signals for each reg
    
	COMPONENT flopenr
   GENERIC (width 			: INTEGER);
   PORT	  (d					: IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
				clk, reset, en : IN BIT; 
				q			   	: OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
	END COMPONENT;
BEGIN

    GEN_REGS: FOR i IN 0 TO 31 GENERATE
        ZERO_REG: IF i = 0 GENERATE
            regs(0) <= (OTHERS => '0');
        END GENERATE;
        
        OTHER_REGS: IF i > 0 GENERATE
            REGX: flopenr 
                GENERIC MAP (width => RISCV_Data_Width)
                PORT MAP(
                d     => WD3,
                clk   => clk, 
                reset => '0', 
                en    => write_enable_reg(i),
                q     => regs(i)
            );
        END GENERATE;
    END GENERATE;

    WRITE_CONTROL: PROCESS(WE3, A3)
    BEGIN
        write_enable_reg <= (OTHERS => '0');
        IF WE3 = '1' THEN
            write_enable_reg(BTOI(A3)) <= '1';
        END IF;
    END PROCESS WRITE_CONTROL;

     -- Leitura assíncrona
    RD1 <= regs(BTOI(A1));
    RD2 <= regs(BTOI(A2));

END logic;
