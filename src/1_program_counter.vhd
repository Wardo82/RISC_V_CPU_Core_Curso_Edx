library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity program_counter is
    port (
        i_clk  : in std_logic;
        i_reset: in std_logic;
        o_program_counter : out std_logic_vector (31 downto 0)
    );
end program_counter;

architecture behavioral of program_counter is
    signal s_next_pc : std_logic_vector(31 downto 0);
begin
    -- First version of Program counter:
    -- $next_pc[31:0] = $reset ? 32'b0 : $pc + 4;
    -- $pc[31:0] = >>1$next_pc;
    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_next_pc <= X"00000000";
            else
                s_next_pc <= std_logic_vector(unsigned(s_next_pc) + 4);
            end if;
        end if;
    end process;

    o_program_counter <= s_next_pc;

    -- Branching logic

    -- taken_br = src1_value comparisson src2_value;
    -- br_tgt_pc = s_next_program_counter + immediate;
    -- algo así, ahora no recuerdo:
    -- o_program_counter <= 
    --    taken_br ? br_tgt_pc : s_next_program_counter + 4;
    
end behavioral;