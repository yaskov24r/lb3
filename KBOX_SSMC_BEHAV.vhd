library IEEE;
use IEEE.std_logic_1164.all;

entity KBOX_SSMC_BEHAV is
	port (
		OP_A : in std_logic_vector(3 downto 0);
		OP_B : in std_logic_vector(3 downto 0);
		CMD  : in std_logic_vector(3 downto 0);
		RES : out std_logic_vector(7 downto 0);
		FLC : out std_logic;
		AGB : out std_logic;
		AEB : out std_logic;
		ALB : out std_logic
	);
end entity;

architecture KBOX_SSMC_BEHAV_arch of KBOX_SSMC_BEHAV is  
	component SSMC_BEHAV
		port (
			OP_0  : in std_logic_vector(3 downto 0);
			OP_1  : in std_logic_vector(3 downto 0);
			OPSEL : in std_logic_vector(1 downto 0);
			RES  : out std_logic_vector(7 downto 0);
			CF : out std_logic;
			AG : out std_logic;
			AE : out std_logic;
			AL : out std_logic
		);
	end component; 
	component bf4_conc_CA 
		port( 
			X : in STD_LOGIC_VECTOR(3 downto 0); 
			Y : out STD_LOGIC_VECTOR(3 downto 0) 
		);
	end component;
	signal Y1 : std_logic_vector(3 downto 0);
	signal Y2 : std_logic_vector(3 downto 0);
	signal OP1 : std_logic_vector(3 downto 0);
	signal OP2 : std_logic_vector(3 downto 0);
begin
	
	KBOX1: bf4_conc_CA port map (X => OP_A, Y => Y1);
	KBOX2: bf4_conc_CA port map (X => OP_B, Y => Y2); 
	MX1: OP1 <= Y1 when CMD(2) = '1' else OP_A;
	MX2: OP2 <= Y2 when CMD(3) = '1' else OP_B;
	SSM_inst: SSMC_BEHAV
		port map (
			OP_0 => OP1,
			OP_1 => OP2,
			OPSEL => CMD(1 downto 0),
			RES => RES,
			CF => FLC,
			AG => AGB,
			AE => AEB,
			AL => ALB
		);
	
end architecture;