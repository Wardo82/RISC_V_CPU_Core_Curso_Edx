library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity instruction_memory is
    port(
        i_clk     : in std_logic;
        i_address : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0)
    );
end instruction_memory;

architecture behavioral of instruction_memory is
    type t_array_imem is array(0 to 15) of std_logic_vector(31 downto 0);
    -----------------------------------------------------------------------------------
    -- /====================\
    -- | Sum 1 to 9 Program |
    -- \====================/
    --
    -- Program to test RV32I
    -- Add 1,2,3,...,9 (in that order).
    --
    -- Regs:
    --  x12 (a2): 10
    --  x13 (a3): 1..10
    --  x14 (a4): Sum
    -- 
    constant c_first_test : t_array_imem := (
        0 => "00000000000000000000011100010011", -- ADDI x14, x0,    0 : Initialize sum register a4 with 0
        1 => "00000000101000000000011000010011", -- ADDI x12, x0, 1010 : Store count of 10 in register a2.
        2 => "00000000000100000000011010010011", -- ADDI x13, x0,    1 : Initialize loop count register a3 with 0
        -- Loop:
        3 => "00000000111001101000011100110011", -- ADD, x14, x13, x14 : Incremental summation
        4 => "00000000000101101000011010010011", -- ADDI, x13, x13,  1 : Increment loop count by 1
        5 => "11111110110101100100100011100011", -- BLT x13, x12, 1111111111000 -- If a3 is less than a2, branch to label named <loop>
        -- Test result value in x14, and set x31 to reflect pass/fail.
        6 => "11111101010001110000111100010011", -- ADDI, x30, x14, 111111010100 : Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
        7 => "00000000000000000101000001100011", -- BGE, x0, x0, 0 : Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
        8 => "00000000000100000000000000010011", -- ADDI, x0, x0, 1)
        others => (others => '0')
    );
    -----------------------------------------------------------------------------------

    -- For the second test, watch the image in the current folder.
begin
    process (i_clk)
	begin
		if rising_edge(i_clk) then
			o_data <= c_first_test(to_integer(unsigned(i_address)) / 4);
		end if;
	end process;

end behavioral;