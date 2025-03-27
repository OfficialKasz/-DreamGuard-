library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity HUMID_RDM is
  port(CLK, Roll: in std_logic;
       tens, ones: out std_logic_vector(3 downto 0));
end HUMID_RDM;

architecture Count of HUMID_RDM is

begin
  process (CLK)
  variable count1: integer range 30 to 70:=50; 
  begin
    if CLK='1' then
      if Roll='0' then
         count1 := count1 + 1;
         if count1 = 70 then
			     count1 := 30;
		     end if;
	     end if;
	  end if;
	  -- Convert count1 to BCD format
	  tens <= std_logic_vector(to_unsigned(count1/10, 4));
	  ones <= std_logic_vector(to_unsigned(count1 mod 10, 4));
  end process;
end Count;



