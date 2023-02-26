library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity program_counter is
    port (
        i_clk             : in std_logic;
        i_reset           : in std_logic;
        i_taken_br        : in boolean; 
--        i_jal             : in std_logic;
        i_br_tgt_pc       : in std_logic_vector (31 downto 0);
--        i_jalr            : in std_logic;
--        i_jalr_tgt_pc     : in std_logic_vector (31 downto 0);
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
                if i_taken_br then -- or i_jal = '1' then
                    s_next_pc <= i_br_tgt_pc;
                --elsif i_jalr = '1' then
                --    s_next_pc <= i_jalr_tgt_pc;
                else
                    s_next_pc <= std_logic_vector(unsigned(s_next_pc) + 4);
                end if;
            end if;
        end if;
    end process;

    o_program_counter <= s_next_pc;

    -- Branching logic
    

end behavioral;