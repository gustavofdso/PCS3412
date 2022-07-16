library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity ram_mem is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
    address : in  std_logic_vector (31 downto 0);
    datain  : in  std_logic_vector (31 downto 0);
    dataout : out std_logic_vector (31 downto 0)
  );
end entity ram_mem;

architecture RTL of ram_mem is

   type ram_type is array ((2**address'length)-1 downto 0) of std_logic_vector(datain'range);
   signal ram : ram_type ;
   signal read_address : std_logic_vector(address'range);

begin
	
  RamProc: process(clock) is
  begin
  
    if rising_edge(clock) then
      if we = '1' then
        ram(to_integer(unsigned(address))) <= datain;
      end if;
      read_address <= address;
    end if;
  end process RamProc;

  dataout <= ram(to_integer(unsigned(read_address)));

end architecture RTL;