library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.core_buses.instruction_type_bus;

entity decoder is
    port(
        i_clk         : in std_logic;
        i_reset       : in std_logic;
        i_instruction : in std_logic_vector(31 downto 0);
        o_immediate : out std_logic_vector(31 downto 0);
        o_register1 : out std_logic_vector(4 downto 0);
        o_register2 : out std_logic_vector(4 downto 0);
        o_instruction_type_bus : out instruction_type_bus
    );
end decoder;

architecture behavioral of decoder is

    signal is_u_instruction: std_logic;
    signal is_i_instruction: std_logic;
    signal is_b_instruction: std_logic;
    signal is_j_instruction: std_logic;
    signal is_r_instruction: std_logic;
    signal is_s_instruction: std_logic;
    signal signature: std_logic_vector(4 downto 0);
    signal is_inst_aux : std_logic;

    signal funct3: std_logic_vector(2 downto 0);
    signal rs1   : std_logic_vector(4 downto 0);
    signal rs2   : std_logic_vector(4 downto 0);
    signal rd    : std_logic_vector(4 downto 0);
    signal opcode: std_logic_vector(6 downto 0);

    signal funct3_valid: std_logic;
    signal rs1_valid   : std_logic;
    signal rs2_valid   : std_logic;
    signal rd_valid    : std_logic;
    signal imm_valid   : std_logic;

    signal imm         : std_logic_vector(31 downto 0);
    signal dec_bits    : std_logic_vector(10 downto 0);

begin

    -- Primero: Decode Logic: Instruction Type
    signature <= i_instruction(6 downto 2);
                
    is_u_instruction <= '1' when (signature = "0-101") 
                        else '0';
    is_i_instruction <= '1' when (signature = "00000" or signature = "00001" or signature = "00100"  or signature = "00110" or signature = "11001")
                        else '0';
    is_b_instruction <= '1' when (signature = "11000")
                        else '0';
    is_j_instruction <= '1' when (signature = "11011")
                        else '0';
    is_r_instruction <= '1' when (signature = "01011" or signature = "011X0" or signature = "10100")
                        else '0';
    is_s_instruction <= '1' when (signature = "0100X")
                        else '0';
    -- Segundo: Decode Logic: Instruction Fields
    funct3 <= i_instruction(14 downto 12);
    rs1 <= i_instruction(19 downto 15);
    rs2 <= i_instruction(24 downto 20);
    rd <= i_instruction(11 downto 7);
    opcode <= i_instruction(6 downto 0);

    funct3_valid <= is_r_instruction or is_i_instruction or is_s_instruction or is_b_instruction;
    rs1_valid    <= is_r_instruction or is_i_instruction or is_s_instruction or is_b_instruction;
    rs2_valid    <= is_r_instruction or is_s_instruction or is_b_instruction;
    rd_valid     <= (is_r_instruction or is_i_instruction or is_u_instruction or is_j_instruction) when (rd /= b"000000") else '0';
    imm_valid    <= not is_r_instruction;

    imm     <= (31 downto 11 => i_instruction(31)) & i_instruction(30 downto 20)                              when (is_i_instruction = '1') else
               (31 downto 11 => i_instruction(31)) & i_instruction(30 downto 25) & i_instruction(11 downto 7) when (is_s_instruction = '1') else
               (31 downto 12 => i_instruction(31)) & i_instruction(7) & i_instruction(30 downto 25) & i_instruction(11 downto 8) & '0' when (is_b_instruction = '1') else
               i_instruction(31 downto 12) & (11 downto 0 => '0') when (is_u_instruction = '1') else
               (31 downto 10 => i_instruction(31)) & i_instruction(19 downto 12) & i_instruction(20) & i_instruction(30 downto 21) & '0' when (is_j_instruction = '1') else
               (others => '0');

    -- Tercero: Decode Logic: Instruction (see image with subset of instructions in red)
    dec_bits <= i_instruction(30) & funct3 & opcode;
    o_instruction_type_bus.is_beq   <= (dec_bits = "00001100011" or dec_bits = "10001100011");
    o_instruction_type_bus.is_bne   <= (dec_bits = "00011100011" or dec_bits = "10011100011");
    o_instruction_type_bus.is_blt   <= (dec_bits = "01001100011" or dec_bits = "11001100011");
    o_instruction_type_bus.is_bge   <= (dec_bits = "01011100011" or dec_bits = "11011100011");
    o_instruction_type_bus.is_bltu  <= (dec_bits = "01101100011" or dec_bits = "11101100011");
    o_instruction_type_bus.is_bgeu  <= (dec_bits = "01111100011" or dec_bits = "11111100011");
    o_instruction_type_bus.is_addi  <= (dec_bits = "00000010011" or dec_bits = "10000010011" );
    o_instruction_type_bus.is_add   <= (dec_bits = "00000110011");
    o_immediate <= imm;
    
end behavioral ; -- behavioral