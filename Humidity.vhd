library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hygrometer is
  port (t, o : in std_logic_vector(3 downto 0);
    CLK, enable: in std_logic;
    tens, ones: out std_logic_vector(3 downto 0);
    above_threshold, below_threshold : out std_logic);
end Hygrometer;

architecture Behavioral of Hygrometer is

  signal above_signal : std_logic:='0';
  signal below_signal: std_logic:='0';
  signal dec_val: integer range 0 to 99;
  signal count1: integer range 0 to 99;

begin
    dec_val <= to_integer(unsigned(t)) * 10 + to_integer(unsigned(o));
  process (CLK)
    variable top_threshold: integer range 30 to 70:=60;
    variable bot_threshold: integer range 30 to 70:=40;

  begin
    if enable = '0' then
      count1 <= dec_val;
    else
      if dec_val < bot_threshold then
        above_signal <= '0';
        below_signal <= '1';
        if dec_val < 50 then  
          if CLK = '1' then
            count1 <= count1 + 1;
          end if;
        end if;
      elsif dec_val > top_threshold then
        above_signal <= '1';
        below_signal <= '0';
        if dec_val > 50 then  
          if CLK = '1' then
            count1 <= count1 - 1;
          end if;
        end if;
      else -- if dec_val is between bot_threshold and top_threshold
        above_signal <= '0';
        below_signal <= '0';
      end if;
    end if;
  end process;

  tens <= std_logic_vector(to_unsigned(dec_val / 10, 4));
  ones <= std_logic_vector(to_unsigned(dec_val mod 10, 4));

  above_threshold <= above_signal;
  below_threshold <= below_signal;

end Behavioral;
