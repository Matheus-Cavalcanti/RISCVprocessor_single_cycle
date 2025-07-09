entity top is
	port(clk, reset: in BIT;
		WriteData, DataAdr: buffer BIT_VECTOR(31 downto 0);
		MemWrite: buffer BIT);
end;

architecture test of top is
	component riscvsingle
		port(clk, reset: in BIT;
			PC: out BIT_VECTOR(31 downto 0);
			Instr: in BIT_VECTOR(31 downto 0);
			MemWrite: out BIT;
			ALUResult, WriteData: out BIT_VECTOR(31 downto 0);
			ReadData: in BIT_VECTOR(31 downto 0));
	end component;
	component imem
		port(a: in BIT_VECTOR(31 downto 0);
			rd: out BIT_VECTOR(31 downto 0));
	end component;
	component dmem
		port(clk, we: in BIT;
			a, wd: in BIT_VECTOR(31 downto 0);
			rd: out BIT_VECTOR(31 downto 0));
	end component;
	
	signal PC, Instr, ReadData: BIT_VECTOR(31 downto 0);
begin
	-- instantiate processor and memories
	rvsingle: riscvsingle port map( clk, reset, PC, Instr,
									MemWrite, DataAdr,
									WriteData, ReadData);
	imem1: imem port map(PC, Instr);
	dmem1: dmem port map( clk, MemWrite, DataAdr, WriteData,
	ReadData);
end;