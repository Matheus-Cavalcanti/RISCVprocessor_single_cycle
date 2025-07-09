entity riscvsingle is
	port(clk, reset: in BIT;
		PC: out BIT_VECTOR(31 downto 0);
		Instr: in BIT_VECTOR(31 downto 0);
		MemWrite: out BIT;
		ALUResult, WriteData: out BIT_VECTOR(31 downto 0);
		ReadData: in BIT_VECTOR(31 downto 0));
end;

architecture struct of riscvsingle is
	component controller
		port(op:			in BIT_VECTOR(6 downto 0);
			funct3:			in BIT_VECTOR(2 downto 0);
			funct7b5, Zero:	in BIT;
			ResultSrc:		out BIT_VECTOR(1 downto 0);
			MemWrite:		out BIT;
			PCSrc, ALUSrc:	out BIT;
			RegWrite, Jump:	out BIT;
			ImmSrc:			out BIT_VECTOR(1 downto 0);
			ALUControl:		out BIT_VECTOR(2 downto 0));
	end component;
	component datapath
		port(clk, reset:	in BIT;
			ResultSrc:		in BIT_VECTOR(1 downto 0);
			PCSrc, ALUSrc:	in BIT;
			RegWrite:		in BIT;
			ImmSrc:			in BIT_VECTOR(1 downto 0);
			ALUControl:		in BIT_VECTOR(2 downto 0);
			Zero:			out BIT;
			PC:				out BIT_VECTOR(31 downto 0);
			Instr:			in BIT_VECTOR(31 downto 0);
			ALUResult, WriteData:	out BIT_VECTOR(31 downto 0);
			ReadData:		in BIT_VECTOR(31 downto 0));
	end component;
	
	signal ALUSrc, RegWrite, Jump, Zero, PCSrc: BIT;
	signal ResultSrc, ImmSrc: BIT_VECTOR(1 downto 0);
	signal ALUControl: BIT_VECTOR(2 downto 0);
begin
	c: controller port map(Instr(6 downto 0), Instr(14 downto 12),
							Instr(30), Zero, ResultSrc, MemWrite,
							PCSrc, ALUSrc, RegWrite, Jump,
							ImmSrc, ALUControl);
	dp: datapath port map(clk, reset, ResultSrc, PCSrc, ALUSrc,
							RegWrite, ImmSrc, ALUControl, Zero,
							PC, Instr, ALUResult, WriteData,
							ReadData);
end;