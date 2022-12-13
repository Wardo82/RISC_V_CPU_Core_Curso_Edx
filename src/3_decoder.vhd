library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder is
    port(
        i_clk         : in std_logic;
        i_reset       : in std_logic;
        i_instruction : in std_logic_vector(31 downto 0);
        --o_immediate : out std_logic_vetor()
        o_register1 : out std_logic_vector(4 downto 0);
        o_register2 : out std_logic_vector(4 downto 0)
        --o_read -- It is called rd on the diagram
        -- I think some flags are missing
    );
end decoder;

architecture behavioral of decoder is

    signal is_u_instruction: std_logic;
    signal is_i_instruction: std_logic;
    signal is_b_instruction: std_logic;
    signal is_j_instruction: std_logic;
    signal is_r_instruction: std_logic;
    signal is_s_instruction: std_logic;
    signal opcode: std_logic_vector(4 downto 0);
begin
    -- Primero: Decode Logic: Instruction Type
    
    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                
            else
                opcode <= i_instruction(6 downto 2);
                if (opcode = "0X101") then
                    is_u_instruction <= '1';
                else
                    is_u_instruction <= '0';
                end if;
                if (opcode = "0000X" or opcode = "001X0" or opcode = "11001") then
                    is_i_instruction <= '1';
                else 
                    is_i_instruction <= '0';
                end if;
                if (opcode = "11000") then
                    is_b_instruction <= '1';
                else 
                    is_b_instruction <= '0';
                end if;
                if (opcode = "11011") then
                    is_j_instruction <= '1';
                else 
                    is_j_instruction <= '0';
                end if;
                if (opcode = "01011" or opcode = "011X0" or opcode = "10100") then
                    is_r_instruction <= '1';
                else 
                    is_r_instruction <= '0';
                end if;
                if (opcode = "0100X") then
                    is_s_instruction <= '1'; 
                else 
                    is_s_instruction <= '0';
                end if;

            end if;
        end if;
    end process ; --

    -- Segundo: Decode Logic: Instruction Fields
    -- Tercero: Decode Logic: Instruction (see image with subset of instructions in red)
    
end behavioral ; -- behavioral