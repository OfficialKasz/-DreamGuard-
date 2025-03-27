library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity TEMP_RDM is
  port(CLK, Roll: in std_logic;
       tens, ones: out std_logic_vector(3 downto 0));
end TEMP_RDM;

architecture Count of TEMP_RDM is

begin
  process (CLK)
  variable count1: integer range 60 to 80:=70; 
  begin
    if CLK='1' then
      if Roll='0' then
         count1 := count1 + 1;
         if count1 = 80 then
			     count1 := 60;
		     end if;
	     end if;
	  end if;
	  -- Convert count1 to BCD format
	  tens <= std_logic_vector(to_unsigned(count1/10, 4));
	  ones <= std_logic_vector(to_unsigned(count1 mod 10, 4));
  end process;
end Count;
