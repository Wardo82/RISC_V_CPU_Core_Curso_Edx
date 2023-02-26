library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity register_file is
    port(
        i_clk   : in std_logic;
        i_reset : in std_logic;
        i_write_enable : in std_logic;
        i_write_index  : in std_logic_vector(4 downto 0);
        i_write_data   : in std_logic_vector(31 downto 0);
        i_read_enable1 : in std_logic;
        i_read_index1  : in std_logic_vector(4 downto 0);
        i_read_enable2 : in std_logic;
        i_read_index2  : in std_logic_vector(4 downto 0);
        o_read_data1   : out std_logic_vector(31 downto 0);
        o_read_data2   : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture behavioral of register_file is
    type store_t is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : store_t := (others => x"00000000");

begin

    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '0') then
                
                if (i_write_enable = '1') then
                    registers(to_integer(unsigned(i_write_index))) <= i_write_data;
                end if;
            else
                registers <= (others => x"00000000");
            end if;
        end if;
    end process;

    o_read_data1 <= registers(to_integer(unsigned(i_read_index1))) when (i_read_enable1 = '1')
                    else x"00000000";
    o_read_data2 <= registers(to_integer(unsigned(i_read_index2))) when (i_read_enable2 = '1')
                    else x"00000000";
end behavioral ; -- behavioral