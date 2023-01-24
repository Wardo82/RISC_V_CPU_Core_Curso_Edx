library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.core_buses.instruction_type_bus;

entity alu is
    port(
        i_clk       : std_logic;
        i_reset     : std_logic;
        i_operator1 : in std_logic_vector(31 downto 0);
        i_operator2 : in std_logic_vector(31 downto 0);
        i_instruction_type_bus : in instruction_type_bus;
        o_result    : out std_logic_vector(31 downto 0);
        o_address   : out std_logic_vector(31 downto 0)
    );
end alu;

architecture behavioral of alu is

    --signal 

begin
    
    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_reset = '0' then
                if i_instruction_type_bus.is_addi then
                    o_result <= std_logic_vector(unsigned(i_operator1) + unsigned(i_operator2));
                elsif i_instruction_type_bus.is_add then
                    o_result <= std_logic_vector(unsigned(i_operator1) + unsigned(i_operator2));
                else
                    o_result <= (others => '0');
                end if;
            else
                o_result <= (others => '0');
            end if;
        end if;
    end process;
end behavioral; -- behavioral