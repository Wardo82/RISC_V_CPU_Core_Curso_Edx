entity instruction_memory is
    port(
        i_address : in std_logic_vector (31 downto 0);
        o_data : out std_logic_vector (31 downto 0);
    );
end instruction_memory;

architecture behavioral of instruction_memory is

    //---------------------------------------------------------------------------------
    // /====================\
    // | Sum 1 to 9 Program |
    // \====================/
    //
    // Program to test RV32I
    // Add 1,2,3,...,9 (in that order).
    //
    // Regs:
    //  x12 (a2): 10
    //  x13 (a3): 1..10
    //  x14 (a4): Sum
    // 
    
    // m4_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
    // m4_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
    // m4_asm(ADDI, x13, x0, 1)             // Initialize loop count register a3 with 0
    // Loop:
    // m4_asm(ADD, x14, x13, x14)           // Incremental summation
    // m4_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
    // m4_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
    // Test result value in x14, and set x31 to reflect pass/fail.
    // m4_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
    // m4_asm(BGE, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
    // m4_asm(ADDI, x0, x0, 1)
    //                 m4_asm_end()
    // m4_define(['M4_MAX_CYC'], 50)
    //---------------------------------------------------------------------------------

    -- For the second test, watch the image in the current folder.
end behavioral;