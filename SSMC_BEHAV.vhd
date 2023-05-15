library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SSMC_BEHAV is
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
end entity;

architecture SSMC_BEHAV_arch of SSMC_BEHAV is  
	
	signal sum, sub : signed(3 downto 0); -- intermediate sum/sub results
	signal sum_buf, sub_buf : signed(4 downto 0); -- result buffers (with carry/borrow)
	signal mul : signed(7 downto 0); -- intermediate multiplication result
	signal car, bor : std_logic;
	constant ADD_COM : std_logic_vector(1 downto 0) := "01"; -- add opcode 
	constant SUB_COM : std_logic_vector(1 downto 0) := "10"; -- sub opcode
	constant MUL_COM : std_logic_vector(1 downto 0) := "11"; -- mul opcode
begin

	-- summation circuit:
	sum_buf <= signed(OP_0(OP_0'high) & OP_0) + signed(OP_1(OP_1'high) & OP_1);
	sum <= sum_buf(3 downto 0);
	car <= sum_buf(4);
	
	-- substraction circuit:
	sub_buf <= signed(OP_0(OP_0'high) & OP_0) - signed(OP_1(OP_1'high) & OP_1); 
	sub <= sub_buf(3 downto 0);
	bor <= sub_buf(4);
	
	-- multiplication circuit:
	mul <= signed(OP_0) * signed(OP_1);
	
	-- result assignments (MUX1 and MUX2):
	RES <= x"0" & std_logic_vector(sum) when OPSEL = ADD_COM else
	       x"0" & std_logic_vector(sub) when OPSEL = SUB_COM else
	       std_logic_vector(mul) when OPSEL = MUL_COM else
	       (others => '0'); -- for unknown opcodes
	
	CF <= car when OPSEL = ADD_COM else
	      bor when OPSEL = SUB_COM else
	      '0'; -- for mul opcode and unknown opcodes  
	
	-- comparator circuit:
	CMP: process(OP_0, OP_1)
	begin
		if signed(OP_0) > signed(OP_1) then
			AG <= '1';
			AE <= '0';
			AL <= '0';
		elsif signed(OP_0) < signed(OP_1) then
			AG <= '0';
			AE <= '0';
			AL <= '1';
		else
			AG <= '0';
			AE <= '1';
			AL <= '0';
		end if;
	end process;
		
end architecture;