library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.math_real.all; -- for stimulus random generation

entity kbox_ssmc_tb is
end entity;

architecture kbox_ssmc_tb_arch of kbox_ssmc_tb is
	
	-- Stimulus signals
	signal TEST_A : STD_LOGIC_VECTOR(3 downto 0);
	signal TEST_B : STD_LOGIC_VECTOR(3 downto 0);
	signal TEST_CMD : STD_LOGIC_VECTOR(3 downto 0);
	-- Observed signals
	signal RES_beh : STD_LOGIC_VECTOR(7 downto 0);
	signal FLC_beh, AGB_beh, AEB_beh, ALB_beh : STD_LOGIC;
	signal RES_struct : STD_LOGIC_VECTOR(7 downto 0);
	signal FLC_struct, AGB_struct, AEB_struct, ALB_struct : STD_LOGIC;
	type TV_TYPE is array (0 to 15) of STD_LOGIC_VECTOR(3 downto 0);
	constant TEST_VECTORS : TV_TYPE := (
		"0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
		"1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"
	);

begin
	
	-- Units Under Test port map
	UUT1 : entity work.kbox_ssmc_behav(kbox_ssmc_behav_arch)
		port map (
			OP_A => TEST_A,
			OP_B => TEST_B,
			CMD  => TEST_CMD,
			RES => RES_beh,
			FLC => FLC_beh,
			AGB => AGB_beh,
			AEB => AEB_beh,
			ALB => ALB_beh
		);
	UUT2 : entity work.kbox_ssmc_struct(kbox_ssmc_struct_arch)
		port map (
			OP_A => TEST_A,
			OP_B => TEST_B,
			CMD  => TEST_CMD,
			RES => RES_struct,
			FLC => FLC_struct,
			AGB => AGB_struct,
			AEB => AEB_struct,
			ALB => ALB_struct
		);
	-- stimulus expressions
	stim_gen: process
		variable seed1 :positive := 20; -- USE YOUR ACADEMIC GROUP ID NUMBER
		variable seed2 :positive := 42;
		variable rnd_ind : integer;
		variable rnd_num : real;
	begin
		uniform(seed1, seed2, rnd_num);
		rnd_ind := integer(rnd_num * real(2**4 - 1)); 
		TEST_A <= TEST_VECTORS(rnd_ind);
		uniform(seed2, seed1, rnd_num);
		rnd_ind := integer(rnd_num * real(2**4 - 1)); 
		TEST_B <= TEST_VECTORS(rnd_ind);
		for i in 0 to 15 loop -- test all commands and operand combinations
			TEST_CMD <= TEST_VECTORS(i);
			wait for 10 ns;
		end loop;
		--wait;
	end process;
end architecture;