library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity noise_counter is
  Port(CLK, Enable, clear: IN std_logic;
        Start : OUT std_logic);
End noise_counter;

Architecture Behav of noise_counter is

begin

process(CLK, clear)
variable i : integer range 0 to 9 := 0;

begin
  if(clear = '1') then
    i := 0;
  elsif(rising_edge(CLK)) then
    start <= '0';
    if Enable = '1' then
      if (i = 0 or i = 1 or i = 2 or i = 3 or i = 4 or i = 5  or i = 6 or i = 7 or i = 8) then
        start <= '0';
        i := i + 1;
      else
        start <= '1';
        i := 0;
      end if;
    end if;
  end if;
end process;

end behav;
