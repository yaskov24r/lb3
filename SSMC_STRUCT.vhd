library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SSMC_STRUCT is
	generic (
		N_GLOB : integer := 4
	);
	port (
		OP_0  : in std_logic_vector(3 downto 0);
		OP_1  : in std_logic_vector(3 downto 0);
		OPSEL : in std_logic_vector(1 downto 0);
		RES  : out std_logic_vector(7 downto 0);
		FC : out std_logic;
		AG : out std_logic;
		AE : out std_logic;
		AL : out std_logic
	);
end entity;

architecture SSMC_STRUCT_arch of SSMC_STRUCT is  
	component SUM_N
		generic ( N : integer );
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);
			SUM : out std_logic_vector(N-1 downto 0);
			CAR : out std_logic
		);
	end component; 
	component SUB_N
		generic ( N : integer );
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);
			SUB : out std_logic_vector(N-1 downto 0);
			BOR : out std_logic
		);
	end component;
	component MUL_N
		generic ( N : integer );
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);
			MUL : out std_logic_vector(2*N-1 downto 0)
		);
	end component;
	component CMP_N
		generic ( N : integer );
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);
			ALB : out std_logic; 
			AEB : out std_logic;
			AGB : out std_logic
		);
	end component;
	component MUX_N
		generic ( N : integer );
		port (
			IN0 : in  std_logic_vector(N-1 downto 0);
			IN1 : in  std_logic_vector(N-1 downto 0);
			IN2 : in  std_logic_vector(N-1 downto 0);
			SEL : in  std_logic_vector(1 downto 0);
			MXO : out std_logic_vector(N-1 downto 0)
		);
	end component;
	signal sum_s, sub_s : std_logic_vector(N_GLOB-1 downto 0); 
	signal sum_ext_s, sub_ext_s : std_logic_vector(2*N_GLOB-1 downto 0); 
	signal car_s, bor_s : std_logic;
	signal mul_s : std_logic_vector(2*N_GLOB-1 downto 0);
	constant ALL_ZEROS_N : std_logic_vector(N_GLOB-1 downto 0) := (others => '0');
begin
		
	sum_inst: SUM_N
	generic map ( N => N_GLOB )
	port map (A => OP_0, B => OP_1, SUM => sum_s, CAR => car_s );
	
	sub_inst: SUB_N
	generic map ( N => N_GLOB )
	port map (A => OP_0, B => OP_1, SUB => sub_s, BOR => bor_s );
	
	mul_inst: MUL_N
	generic map ( N => N_GLOB )
	port map (A => OP_0, B => OP_1, MUL => mul_s );
	
	cmp_inst: CMP_N
	generic map ( N => N_GLOB )
	port map (
		A => OP_0, 
		B => OP_1, 
		ALB => AL, 
		AEB => AE, 
		AGB => AG 
	); 
	
	sum_ext_s <= ALL_ZEROS_N & sum_s; -- (N_GLOB-1 downto 0 => sum_s, others => '0');
	sub_ext_s <= ALL_ZEROS_N & sub_s; -- (N_GLOB-1 downto 0 => sub_s, others => '0');
	
	mux_bus: MUX_N
	generic map ( N => 2*N_GLOB )
	port map (
		IN0 => sum_ext_s, 
		IN1 => sub_ext_s, 
		IN2 => mul_s, 
		SEL => OPSEL, 
		MXO => RES
	);
	
	mux_bit: MUX_N
	generic map ( N => 1 )
	port map (
		IN0(0) => car_s, -- formal name should be 
		IN1(0) => bor_s, -- followed by (0) to match 
		IN2(0) => '0',   -- type of connected signal
		SEL => OPSEL, 
		MXO(0) => FC
	);
end architecture;