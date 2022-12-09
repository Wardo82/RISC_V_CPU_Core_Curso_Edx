entity decoder is
    port(
        i_instruction : in std_logic_vector(31 downto 0);
        o_immediate : out std_logic_vetor()
        o_register1 : out std_logic_vector(4 downto 0);
        o_register2 : out std_logic_vector(4 downto 0);
        o_read -- It is called rd on the diagram
        -- I think some flags are missing
    );
end decoder;

architecture behavioral of decoder is

    signal 

begin
    -- Primero: Decode Logic: Instruction Type
    -- Segundo: Decode Logic: Instruction Fields
    -- Tercero: Decode Logic: Instruction (see image with subset of instructions in red)
    
end behavioral ; -- behavioral