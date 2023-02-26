library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

package core_buses is
-- Bus declaration
    -- Instruction flag bus: It contains a flag for each instruction so that the decoder can 
    -- tell the ALU which instruction to execute.
    type instruction_type_bus is record
        is_jal   : boolean;
        is_jalr  : boolean;
        is_beq   : boolean;
        is_bne   : boolean;
        is_blt   : boolean;
        is_bge   : boolean;
        is_bltu  : boolean;
        is_bgeu  : boolean;
        is_add   : boolean;
        is_addi  : boolean;
    end record;

end package ;