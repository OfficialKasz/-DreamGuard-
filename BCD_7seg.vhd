library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity BCD_7seg is
  	Port ( BCDin_ones, BCDin_tens : in STD_LOGIC_VECTOR (3 downto 0);
          seg1, seg2 : out STD_LOGIC_VECTOR (6 downto 0));
end BCD_7seg;
 
architecture Behavioral of bcd_7seg is
begin
  process(BCDin_tens, BCDin_ones)
    begin
    case BCDin_tens is
      when "0000" =>
        seg1 <= "0000001"; ---0
      when "0001" =>
        seg1 <= "1001111"; ---1
      when "0010" =>
        seg1 <= "0010010"; ---2
      when "0011" =>
        seg1 <= "0000110"; ---3
      when "0100" =>
        seg1 <= "1001100"; ---4
      when "0101" =>
        seg1 <= "0100100"; ---5
      when "0110" =>
        seg1 <= "0100000"; ---6
      when "0111" =>
        seg1 <= "0001111"; ---7
      when "1000" =>
        seg1 <= "0000000"; ---8
      when "1001" =>
        seg1 <= "0000100"; ---9
      when others =>
        seg1 <= "1111111"; ---null
    end case;
    
    case BCDin_ones is
      when "0000" =>
        seg2 <= "0000001"; ---0
      when "0001" =>
        seg2 <= "1001111"; ---1
      when "0010" =>
        seg2 <= "0010010"; ---2
      when "0011" =>
        seg2 <= "0000110"; ---3
      when "0100" =>
        seg2 <= "1001100"; ---4
      when "0101" =>
        seg2 <= "0100100"; ---5
      when "0110" =>
        seg2 <= "0100000"; ---6
      when "0111" =>
        seg2 <= "0001111"; ---7
      when "1000" =>
        seg2 <= "0000000"; ---8
      when "1001" =>
        seg2 <= "0000100"; ---9
      when others =>
        seg2 <= "1111111"; ---null
    end case;
 
end process;
 
end Behavioral;