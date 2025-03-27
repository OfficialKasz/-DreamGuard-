--
-- Slows Clock Down
-- Eric W. Johnson
-- ECE 222
-- March 24, 2009
--

library ieee;
use ieee.std_logic_1164.all;

entity slow_clk is
  port (In_Clk: in std_logic;
        Out_Clk: out std_logic);
end slow_clk;

architecture behav of slow_clk is
begin
   Process (In_Clk)
      Variable cnt : INTEGER RANGE 0 TO 1000000;
   Begin
      IF (In_Clk'EVENT AND In_Clk='1') THEN
         cnt := cnt + 1;
         IF cnt = 1000000 THEN
            Out_Clk <= '1';
         ELSE
            Out_Clk <= '0';
         END IF;
      END IF;
   End Process;
end behav;
