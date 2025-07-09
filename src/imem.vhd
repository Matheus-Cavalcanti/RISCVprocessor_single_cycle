LIBRARY bibli_1;
USE bibli_1.riscv_pkg.ALL;

library IEEE;
use ieee.std_logic_textio.all;

use STD.TEXTIO.all;

entity imem is
	port(a: in BIT_VECTOR(31 downto 0);
		rd: out BIT_VECTOR(31 downto 0));
end;

architecture behave of imem is
	type ramtype is array (63 downto 0) of
				BIT_VECTOR(31 downto 0);
	-- initialize memory from file
	impure function init_ram_hex return ramtype is
		 -- Ajuste esse caminho se necessário de acordo com sua pasta de simulação:
		 file text_file : text open read_mode is "C:\Users\Mathe\OneDrive\Documentos\SEL0632\riscvsingle\src\riscvtest.txt";
		 variable text_line  : line;
		 variable ram_content: ramtype;
	begin
    -- 1) Zera toda a memória (0..63)
    for i in ram_content'range loop
        ram_content(i) := (others => '0');
    end loop;

    -- 2) Lê NO MÁXIMO 64 linhas, colocando cada uma em ram_content(0), ram_content(1), …
    for i in ram_content'range loop
        if not endfile(text_file) then
            readline(text_file, text_line);
            hread(text_line, ram_content(i));
        else
            exit;  -- acabou o arquivo, sai do loop
        end if;
    end loop;

    return ram_content;
	end function;
	
	signal mem : ramtype := init_ram_hex;
	begin
	-- read memory
	process(a) begin
		rd <= mem(BTOI(a(31 downto 2)));
	end process;
end;