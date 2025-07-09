library IEEE;
use IEEE.NUMERIC_BIT.all;		-- Used for rising_edge function

LIBRARY bibli_1;
USE bibli_1.riscv_pkg.ALL;

entity dmem is
	port(clk, we: in BIT;
		a, wd: in BIT_VECTOR(31 downto 0);
		rd: out BIT_VECTOR(31 downto 0));
end;

architecture behave of dmem is
  -- Tipo de memória com 64 palavras de 32 bits
  type ramtype is array (63 downto 0) of BIT_VECTOR(31 downto 0);
  signal mem : ramtype := (others => (others => '0'));
begin

  -- Processo síncrono: escrita e leitura na borda de subida
  process(clk)
    variable idx : integer;
  begin
    if rising_edge(clk) then
      idx := BTOI(a(7 downto 2));  -- converte endereço para 0..63
      if we = '1' then
        mem(idx) <= wd;            -- escreve
      end if;
      rd <= mem(idx);              -- lê (read-after-write se we='1')
    end if;
  end process;

end architecture;