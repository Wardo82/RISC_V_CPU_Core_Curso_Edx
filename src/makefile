GHDL=ghdl
FLAGS=--workdir=work -fsynopsys

all:
	@$(GHDL) -a $(FLAGS) core_buses.vhd
	@$(GHDL) -a $(FLAGS) 1_program_counter.vhd
	@$(GHDL) -a $(FLAGS) 2_instruction_memory.vhd
	@$(GHDL) -a $(FLAGS) 3_decoder.vhd
	@$(GHDL) -a $(FLAGS) 4_register_file.vhd
	@$(GHDL) -a $(FLAGS) 5_arithmetic_logic_unit.vhd
	@$(GHDL) -a $(FLAGS) main_core.vhd
	@$(GHDL) -a $(FLAGS) main_core_tb.vhd
	@$(GHDL) -e $(FLAGS) main_core_tb	
	@$(GHDL) -r $(FLAGS) main_core_tb --wave=wave.ghw