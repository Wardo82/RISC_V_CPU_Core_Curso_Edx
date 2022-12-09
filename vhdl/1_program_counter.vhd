Initially, we will implement only sequential fetching, so the PC update will be, for now, simply a counter. Note that:

            The PC is a byte address, meaning it references the first byte of an instruction in the IMem. Instructions are 4 bytes long, so, although the PC increment is depicted as "+1" (instruction), the actual increment must be by 4 (bytes). The lowest two PC bits must always be zero in normal operation.
            Instruction fetching should start from address zero, so the first $pc value with $reset deasserted should be zero, as is implemented in the logic diagram below.
            Unlike our earlier counter circuit, for readability, we use unique names for $pc and $next_pc, by assigning $pc to the previous $next_pc.



entity program_counter is
    port (
        i_reset: in std_logic;
        o_program_counter : out std_logic_vector (31 downto 0);
    );
end program_counter;

architecture behavioral of program_counter is
    signal s_next_program_counter : std_logic_vector(31 downto 0);
begin
    -- Recuerda ver los commits


    -- Branching logic

    taken_br = src1_value comparisson src2_value;
    br_tgt_pc = s_next_program_counter + immediate;
    -- algo así, ahora no recuerdo:
    o_program_counter <= 
        taken_br ? br_tgt_pc : s_next_program_counter + 4;
    
end behavioral;