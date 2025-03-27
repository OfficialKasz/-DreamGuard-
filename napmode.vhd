library ieee;
use ieee.std_logic_1164.all;

entity napMode is
    port(soundLvl : in std_logic_vector(1 downto 0);
         CLK : in std_logic;
         oscillator, wirelessSignal : out std_logic;
         speaker : out std_logic_vector(1 downto 0));
end napMode;

architecture Behav of napMode is
begin

process (CLK)
    variable counter : integer range 0 to 10 := 0; -- declare counter variable
begin
    if rising_edge(CLK) then
        if soundLvl = "00" then 
            oscillator <= '0';
            wirelessSignal <= '0';
            speaker <= "00";
        elsif soundLvl = "01" then 
            oscillator <= '1';
            wirelessSignal <= '0';
            speaker <= "01";
        elsif soundLvl = "10" then 
            oscillator <= '1';
            speaker <= "10";
            if counter = 10 then -- check if delay has elapsed
                wirelessSignal <= '1';
                counter := 0; -- reset counter
            else
                counter := counter + 1; -- increment counter
            end if;
        else
            oscillator <= '0';
            wirelessSignal <= '0';
            speaker <= "00";
        end if;
    end if;
end process;

end Behav;