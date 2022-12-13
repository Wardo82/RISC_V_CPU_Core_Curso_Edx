entity register_file is
    port(
        i_reset : in std_logic;
        i_write_enable : in std_logic;
        i_write_index  : in std_logic_vector(4 downto 0);
        i_write_data   : in std_logic_vector(31 downto 0);
        i_read_enable1 : in std_logic;
        i_read_index1  : in std_logic_vector(4:0);
        i_read_enable2 : in std_logic;
        i_read_index2  : in std_logic_vector(4:0);
        o_read_data1   : out std_logic_vector(31 downto 0);
        o_read_data2   : out std_logic_vector(31 downto 0);
    );
end register_file;

architecture behavioral of register_file is

    signal 

begin

end behavioral ; -- behavioral