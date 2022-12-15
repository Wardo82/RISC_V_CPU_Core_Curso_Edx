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
    signal signature: std_logic_vector(4 downto 0);

    signal funct3: std_logic_vector(3 downto 0);
    signal rs1   : std_logic_vector(5 downto 0);
    signal rs2   : std_logic_vector(5 downto 0);
    signal rd    : std_logic_vector(5 downto 0);
    signal opcode: std_logic_vector(6 downto 0);

    signal funct3_valid: std_logic;
    signal rs1_valid   : std_logic;
    signal rs2_valid   : std_logic;
    signal rd_valid    : std_logic;
    signal imm_valid   : std_logic;

    signal imm         : std_logic_vector(31 downto 0);

begin
    process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                
            else
                -- Primero: Decode Logic: Instruction Type
                signature <= i_instruction(6 downto 2);
                if (signature = "0X101") then
                    is_u_instruction <= '1';
                else
                    is_u_instruction <= '0';
                end if;
                if (signature = "0000X" or signature = "001X0" or signature = "11001") then
                    is_i_instruction <= '1';
                else 
                    is_i_instruction <= '0';
                end if;
                if (signature = "11000") then
                    is_b_instruction <= '1';
                else 
                    is_b_instruction <= '0';
                end if;
                if (signature = "11011") then
                    is_j_instruction <= '1';
                else 
                    is_j_instruction <= '0';
                end if;
                if (signature = "01011" or signature = "011X0" or signature = "10100") then
                    is_r_instruction <= '1';
                else 
                    is_r_instruction <= '0';
                end if;
                if (signature = "0100X") then
                    is_s_instruction <= '1'; 
                else 
                    is_s_instruction <= '0';
                end if;
                
                -- Segundo: Decode Logic: Instruction Fields
                funct3 <= i_instruction(14 downto 12);
                rs1 <= i_instruction(19 downto 15);
                rs2 <= i_instruction(24 downto 20);
                rd <= i_instruction(11 downto 7);
                opcode <= i_instruction(6 downto 0);

                funct3_valid <= is_r_instruction or is_i_instruction or is_s_instruction or is_b_instruction;
                rs1_valid    <= is_r_instruction or is_i_instruction or is_s_instruction or is_b_instruction;
                rs2_valid    <= is_r_instruction or is_s_instruction or is_b_instruction;
                rd_valid     <= is_r_instruction or is_i_instruction or is_u_instruction or is_j_instruction;
                imm_valid    <= not is_r_instruction;
            
                if (is_i_instruction = '1') then
                    imm <= (31 downto 11 => i_instruction(31)) & i_instruction(30 downto 20);
                elsif (is_s_instruction = '1') then
                    imm <= (31 downto 11 => i_instruction(31)) & i_instruction(30 downto 25) & i_instruction(11 downto 7);
                elsif (is_b_instruction = '1') then
                    imm <= (31 downto 12 => i_instruction(31)) & i_instruction(7) & i_instruction(30 downto 25) & i_instruction(11 downto 8) & '0';   
                elsif  (is_u_instruction = '1') then
                    imm <= i_instruction(31 downto 12) & (11 downto 0 => '0');           
                elsif  (is_j_instruction = '1') then
                    imm <= (31 downto 10 => i_instruction(31)) & i_instruction(19 downto 12) & i_instruction(20) & i_instruction(30 downto 21) & '0';
                else
                    imm <= (others => '0');
                end if;
                -- Tercero: Decode Logic: Instruction (see image with subset of instructions in red)

            end if;

        end if;
    end process ; --
    
end behavioral ; -- behavioral