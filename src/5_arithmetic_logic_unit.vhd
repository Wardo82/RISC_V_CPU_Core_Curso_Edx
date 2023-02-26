library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.core_buses.instruction_type_bus;

entity alu is
    port(
        i_clk       : std_logic;
        i_reset     : std_logic;
        i_pc        : in std_logic_vector(31 downto 0);
        i_immediate : in std_logic_vector(31 downto 0);
        i_register1 : in std_logic_vector(31 downto 0);
        i_register2 : in std_logic_vector(31 downto 0);
        i_instruction_type_bus : in instruction_type_bus;
        o_taken_br  : out boolean;
        o_br_tgt_pc : out std_logic_vector(31 downto 0);
        o_result    : out std_logic_vector(31 downto 0)
    );
end alu;

architecture behavioral of alu is

    --signal 

begin
    
    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_reset = '0' then
              
            else
                o_result <= (others => '0');
            end if;
        end if;
    end process;

    o_result <= 
        std_logic_vector(unsigned(i_register1) + unsigned(i_immediate)) when i_instruction_type_bus.is_addi else
        std_logic_vector(unsigned(i_register1) + unsigned(i_register2)) when i_instruction_type_bus.is_add else
        (others => '0');
        
    o_taken_br <= (i_register1 = i_register2) when i_instruction_type_bus.is_beq else
                  (i_register1 /= i_register2) when i_instruction_type_bus.is_bne else
                  signed(i_register1) < signed(i_register2) when i_instruction_type_bus.is_blt else
                  signed(i_register1) >= signed(i_register2) when i_instruction_type_bus.is_bge  else
                  unsigned(i_register1) < unsigned(i_register2) when i_instruction_type_bus.is_bltu else
                  unsigned(i_register1) >= unsigned(i_register2) when i_instruction_type_bus.is_bgeu else
                  false;

    o_br_tgt_pc <= std_logic_vector(unsigned(i_pc) + unsigned(i_immediate));

end behavioral; -- behavioral