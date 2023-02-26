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
    i_clk             : in std_logic;
    i_reset           : in std_logic;
    i_taken_br        : in boolean; 
--        i_jal             : in std_logic;
    i_br_tgt_pc       : in std_logic_vector (31 downto 0);
--        i_jalr            : in std_logic;
--        i_jalr_tgt_pc     : in std_logic_vector (31 downto 0);
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
    o_rd_valid  : out std_logic;
    o_rd        : out std_logic_vector(4 downto 0);
    o_funct3_valid: out std_logic;
    o_imm_valid   : out std_logic;
    o_immediate : out std_logic_vector(31 downto 0);
    o_rs1_valid   : out std_logic;
    o_register1 : out std_logic_vector(4 downto 0);
    o_rs2_valid   : out std_logic;
    o_register2 : out std_logic_vector(4 downto 0);
    o_instruction_type_bus : out instruction_type_bus
  );
  end component;

  -- 4 Register file
  component register_file
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
  end component;

  -- 5 Arithmetic Logic Unit (ALU)
  component alu is
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
  end component;

  -- Outputs
  signal s_program_counter : std_logic_vector(31 downto 0);
  signal s_instruction : std_logic_vector(31 downto 0);
  signal s_rd_valid  : std_logic;
  signal s_rd        : std_logic_vector(4 downto 0);
  signal s_funct3_valid : std_logic;
  signal s_imm_valid : std_logic;
  signal s_immediate : std_logic_vector(31 downto 0);
  signal s_rs1_valid : std_logic;
  signal s_register1 : std_logic_vector(4 downto 0);
  signal s_rs1_data  : std_logic_vector(31 downto 0);
  signal s_rs2_valid : std_logic;
  signal s_register2 : std_logic_vector(4 downto 0);
  signal s_rs2_data  : std_logic_vector(31 downto 0);
  signal s_instruction_type_bus : instruction_type_bus;
  signal s_result    : std_logic_vector(31 downto 0);
  signal s_taken_br : boolean;
  signal s_br_tgt_pc: std_logic_vector(31 downto 0);

begin

-- ======================================================
-- COMPONENT INSTANTIATION
-- ======================================================
-- 1 Program counter (PC)
    
    pc: program_counter port map(
      i_clk             => i_clock,
      i_reset           => i_reset,
      i_taken_br        => s_taken_br, 
--      i_jal             => s_jal,
      i_br_tgt_pc       => s_br_tgt_pc,
--      i_jalr            : in std_logic;
--      i_jalr_tgt_pc     : in std_logic_vector (31 downto 0);
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
      o_rd_valid    => s_rd_valid,
      o_rd          => s_rd,
      o_funct3_valid => s_funct3_valid,
      o_imm_valid   => s_imm_valid,
      o_immediate   => s_immediate,
      o_rs1_valid   => s_rs1_valid,
      o_register1   => s_register1,
      o_rs2_valid   => s_rs2_valid,
      o_register2   => s_register2,
      o_instruction_type_bus  => s_instruction_type_bus
    );
-- 4 Register file
    reg_file: register_file port map(
        i_clk          => i_clock,
        i_reset        => i_reset,
        i_write_enable => s_rd_valid,
        i_write_index  => s_rd,
        i_write_data   => s_result,
        i_read_enable1 => s_rs1_valid,
        i_read_index1  => s_register1,
        i_read_enable2 => s_rs2_valid,
        i_read_index2  => s_register2,
        o_read_data1   => s_rs1_data,
        o_read_data2   => s_rs2_data
    );

  -- 5 Arithmetic Logic Unit (ALU)
    alunit: alu port map (
        i_clk          => i_clock,
        i_reset        => i_reset,
        i_pc           => s_program_counter,
        i_immediate    => s_immediate,
        i_register1    => s_rs1_data,
        i_register2    => s_rs2_data,
        i_instruction_type_bus  => s_instruction_type_bus,
        o_taken_br     => s_taken_br,
        o_br_tgt_pc    => s_br_tgt_pc,
        o_result       => s_result
    );

end Behavioral ; -- structural*