ENTITY flopenr IS
  GENERIC (
    width : INTEGER := 32  -- largura do vetor de dados
  );
  PORT (
    clk   : IN  BIT;                             -- sinal de clock
    reset : IN  BIT;                             -- reset assíncrono, ativo em '1'
    en    : IN  BIT;                             -- habilitador de escrita
    d     : IN  BIT_VECTOR(width-1 DOWNTO 0);    -- entrada de dados
    q     : OUT BIT_VECTOR(width-1 DOWNTO 0)     -- saída registrada
  );
END flopenr;

ARCHITECTURE logic OF flopenr IS
BEGIN
  process(clk, reset)
  begin
    if reset = '1' then
      q <= (others => '0');
    elsif (clk'event AND clk = '1') then
      if en = '1' then
        q <= d;
      end if;
    end if;
  end process;
END logic;
