entity datapath is
	port(clk, reset: in BIT;
		ResultSrc: in BIT_VECTOR(1 downto 0);
		PCSrc, ALUSrc: in BIT;
		RegWrite: in BIT;
		ImmSrc: in BIT_VECTOR(1 downto 0);
		ALUControl: in BIT_VECTOR(2 downto 0);
		Zero: out BIT;
		PC: buffer BIT_VECTOR(31 downto 0);
		Instr: in BIT_VECTOR(31 downto 0);
		ALUResult, WriteData: buffer BIT_VECTOR(31 downto 0);
		ReadData: in BIT_VECTOR(31 downto 0));
end;

architecture struct of datapath is
	component flopr generic(width: integer);
		port(clk, reset: in BIT;
				d: in BIT_VECTOR(width-1 downto 0);
				q: out BIT_VECTOR(width-1 downto 0));
	end component;
	component adder
		port(a, b: in BIT_VECTOR(31 downto 0);
				cin : in bit;
				cout : out bit;
				y: out BIT_VECTOR(31 downto 0));
	end component;
	component mux2 generic(width: integer);
		port(d0, d1: in BIT_VECTOR(width-1 downto 0);
				s: in BIT;
				y: out BIT_VECTOR(width-1 downto 0));
	end component;
	component mux3 generic(width: integer);
		port(d0, d1, d2: in BIT_VECTOR(width-1 downto 0);
				s: in BIT_VECTOR(1 downto 0);
				y: out BIT_VECTOR(width-1 downto 0));
	end component;
	component regfile
		port(clk: in BIT;
				we3: in BIT;
				a1, a2, a3: in BIT_VECTOR(4 downto 0);
				wd3: in BIT_VECTOR(31 downto 0);
				rd1, rd2: out BIT_VECTOR(31 downto 0));
	end component;
	component extend
		port(instr: in BIT_VECTOR(31 downto 7);
				immsrc: in BIT_VECTOR(1 downto 0);
				immext: out BIT_VECTOR(31 downto 0));
	end component;
	component alu
		port(a, b: in BIT_VECTOR(31 downto 0);
				ALUControl: in BIT_VECTOR(2 downto 0);
				Result: buffer BIT_VECTOR(31 downto 0);
				Zero: out BIT);
	end component;
	
	signal PCNext, PCPlus4, PCTarget: BIT_VECTOR(31 downto 0);
	signal ImmExt: BIT_VECTOR(31 downto 0);
	signal SrcA, SrcB: BIT_VECTOR(31 downto 0);
	signal Result: BIT_VECTOR(31 downto 0);
begin
	-- next PC logic
	pcreg: flopr generic map(32) port map(clk, reset, PCNext, PC);
	pcadd4: adder port map(a => PC, b => X"00000004", y => PCPlus4, cin => '0', cout => open);
	pcaddbranch: adder port map(a => PC, b => ImmExt, y => PCTarget, cin => '0', cout => open);
	pcmux: mux2 generic map(32) port map(PCPlus4, PCTarget, PCSrc,
											PCNext);
	-- register file logic
	rf: regfile port map(clk, RegWrite, Instr(19 downto 15),
	Instr(24 downto 20), Instr(11 downto 7),
								Result, SrcA, WriteData);
	ext: extend port map(Instr(31 downto 7), ImmSrc, ImmExt);
	-- ALU logic
	srcbmux: mux2 generic map(32) port map(WriteData, ImmExt,
											ALUSrc, SrcB);
	mainalu: alu port map(SrcA, SrcB, ALUControl, ALUResult, Zero);
	resultmux: mux3 generic map(32) port map(ALUResult, ReadData,
												PCPlus4, ResultSrc,
												Result);
end;
