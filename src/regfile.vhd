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
USE bibli_1.riscv_pkg.RISCV_Data_Width;
USE bibli_1.riscv_pkg.flopr;
USE bibli_1.riscv_pkg.BTOI;

ENTITY regfile IS
	GENERIC (N			  : INTEGER := 32); -- n of registers
	PORT	  (A1, A2, A3 : IN BIT_VECTOR(4 DOWNTO 0); 
				WD3		  : IN BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0);
				WE3, clk	  : IN BIT;
				RD1,RD2	  : OUT BIT_VECTOR(RISCV_Data_Width-1 DOWNTO 0));
END regfile;

ARCHITECTURE logic OF regfile IS
    TYPE reg_array IS ARRAY (0 TO 31) OF BIT_VECTOR(N-1 DOWNTO 0); -- register array (N bits)
	 SIGNAL regs : reg_array;
	 
	 SIGNAL write_enable : BIT_VECTOR(31 DOWNTO 0);  -- enable signals for each reg
BEGIN
    GEN_REGS: FOR i IN 0 TO 31 GENERATE
        ZERO_REG: IF i = 0 GENERATE
            regs(0) <= (OTHERS => '0'); -- register 0 is x0 (zero constant)
        END GENERATE;
        
        OTHER_REGS: IF i > 0 GENERATE
            REGX: flopr PORT MAP(
                d     => WD3,
                clk   => write_enable(i),  -- clock selectively enabled
                reset => '0',              -- no individual reset
                q     => regs(i)
            );
        END GENERATE;
    END GENERATE;

	 -- write control: Enable WE3 only for the target register (A3)
    WRITE_PROC: PROCESS(WE3, A3)
    BEGIN
        write_enable <= (OTHERS => '0');  -- disables all by default
        IF WE3 = '1' THEN
            write_enable(BTOI(A3)) <= clk;  -- enables only the target register
        END IF;
    END PROCESS;

    -- asynchronous read
    RD1 <= regs(BTOI(A1));
    RD2 <= regs(BTOI(A2));

END logic;