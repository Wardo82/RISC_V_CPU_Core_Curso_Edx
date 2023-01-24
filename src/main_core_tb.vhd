library ieee;
use ieee.std_logic_1164.all;
use work.core_buses.all;

entity main_core_tb is
end main_core_tb;

architecture behavior of main_core_tb is

    -- Core declaration for the Unit Under Test (UUT)
    component main_core 
    port (
        i_clock : in std_logic;
        i_reset : in std_logic
    );
    end component;

    -- Inputs
    signal i_clk : std_logic := '0';
    signal i_rst : std_logic := '1';
    -- Clock period definition
    constant I_clk_period : time := 10 ns;
begin

    -- Instantiate the unit under test (UUT)
    uut: main_core port map (
        i_clock  => i_clk,
        i_reset  => i_rst
    );

       -- Clock process definitions
   I_clk_process :process
   begin
    I_clk <= '1';
    wait for I_clk_period/2;
    I_clk <= '0';
    wait for I_clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
        -- hold reset state for 10 ns;
        wait for I_clk_period * 1;

        i_rst <= '0';
        wait for 10 * I_clk_period;
        assert false report "Test finished" severity failure;
   end process;
end behavior ; -- behavior