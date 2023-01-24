library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.core_buses.instruction_type_bus;

entity main_core is
  port (
    i_clock : in std_logic;
    i_reset : in std_logic
  ) ;
end main_core;

architecture Behavioral of main_core is
-- ======================================================
-- COMPONENT DECLARATION
-- ======================================================
-- 1 Program counter (PC)
  component program_counter
  port (
    i_clk  : in std_logic;
    i_reset: in std_logic;
    o_program_counter : out std_logic_vector (31 downto 0)
  );
  end component;

  -- 2 Instruction memory (IMEM)
  component instruction_memory
  port(
      i_clk     : in std_logic;
      i_address : in std_logic_vector (31 downto 0);
      o_data : out std_logic_vector (31 downto 0)
  );
  end component;

  -- 3 Decoder
  component decoder
  port(
      i_clk         : in std_logic;
      i_reset       : in std_logic;
      i_instruction : in std_logic_vector(31 downto 0);
      o_immediate : out std_logic_vector(31 downto 0);
      o_register1 : out std_logic_vector(4 downto 0);
      o_register2 : out std_logic_vector(4 downto 0);
      o_instruction_type_bus : out instruction_type_bus
  );
  end component;

  -- Outputs
  signal s_program_counter : std_logic_vector(31 downto 0);
  signal s_instruction : std_logic_vector(31 downto 0);
  signal s_immediate : std_logic_vector(31 downto 0);
  signal s_register1 : std_logic_vector(4 downto 0);
  signal s_register2 : std_logic_vector(4 downto 0);
  signal s_instruction_type_bus : instruction_type_bus;

begin

-- ======================================================
-- COMPONENT INSTANTIATION
-- ======================================================
-- 1 Program counter (PC)
    pc: program_counter port map(
      i_clk             => i_clock,
      i_reset           => i_reset,
      o_program_counter => s_program_counter  
    );
-- 2 Instruction Memory (IMEM)
    imem: instruction_memory port map(
      i_clk     => i_clock,
      i_address => s_program_counter,
      o_data    => s_instruction
    );
-- 3 Decoder
    dec: decoder port map(
      i_clk         => i_clock,
      i_reset       => i_reset,
      i_instruction => s_instruction,
      o_immediate   => s_immediate,
      o_register1   => s_register1,
      o_register2   => s_register2,
      o_instruction_type_bus  => s_instruction_type_bus
    );

end Behavioral ; -- structural*