library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DreamGuard is
  port(In_clock, RDM1, RDM2: IN std_logic;
       soundLvl : IN std_logic_vector(1 downto 0);
       
       Correction_enable: IN std_logic;
       
       OSC : OUT std_logic;
       WLS : OUT std_logic;
       SPEAK : OUT std_logic_vector(1 downto 0);
       
       LCD_PINS: INOUT std_logic_vector(7 downto 0);
       UP_H, DOWN_H, DOWN_T, UP_T, LCD_RS, LCD_E, LCD_RW, LCD_ON, LCD_BLON: OUT std_logic;
       RDM_humid_tens, RDM_temp_tens, RDM_humid_ones, RDM_temp_ones : OUT std_logic_vector(6 downto 0));
end DreamGuard;

architecture SnugWatch of DreamGuard is
-------------------------------------------------------------------
 Component slow_clk is
    port (In_Clk: in std_logic;
          Out_Clk: out std_logic);
  end component;
-------------------------------------------------------------------
Component TEMP_RDM is
  port(CLK, Roll: in std_logic;
       tens, ones: out std_logic_vector(3 downto 0));
end Component;
-------------------------------------------------------------------
Component HUMID_RDM is
  port(CLK, Roll: in std_logic;
       tens, ones: out std_logic_vector(3 downto 0));
end Component;
-------------------------------------------------------------------
Component BCD_7seg is
  	Port (BCDin_ones, BCDin_tens : in STD_LOGIC_VECTOR (3 downto 0);
          seg1, seg2 : out STD_LOGIC_VECTOR (6 downto 0));
end Component;
-------------------------------------------------------------------
Component napMode is
	Port(soundLvl : IN std_logic_vector(1 downto 0);
			CLK : IN std_logic;
			oscillator, wirelessSignal : OUT std_logic;
			speaker : OUT std_logic_vector(1 downto 0));
	end Component;
-------------------------------------------------------------------
Component Hygrometer is
  port (t, o : in std_logic_vector(3 downto 0);
    CLK, enable: in std_logic;
    tens, ones: out std_logic_vector(3 downto 0);
    above_threshold, below_threshold : out std_logic);
end Component;
-------------------------------------------------------------------
Component Thermometer is
  port (t, o : in std_logic_vector(3 downto 0);
    CLK, enable: in std_logic;
    tens, ones: out std_logic_vector(3 downto 0);
    above_threshold, below_threshold : out std_logic);
end Component;
-------------------------------------------------------------------
Component LCD_Display IS
	PORT(reset, clk_48Mhz			: IN	STD_LOGIC;
	   mode  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 LCD_RS, LCD_E				: OUT	STD_LOGIC;
		 LCD_RW						: OUT   STD_LOGIC;
		 DATA_BUS					: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END Component;
-------------------------------------------------------------------

	signal clock, oscillator_sig, wirelessSignal_sig: std_logic;
	signal speaker_sig : std_logic_vector(1 downto 0);
	signal Humid_tens : std_logic_vector(3 downto 0);
	signal Temp_tens : std_logic_vector(3 downto 0);
	signal Humid_ones : std_logic_vector(3 downto 0);
	signal Temp_ones : std_logic_vector(3 downto 0);
	signal upT, downT, upH, downH : std_logic;
	signal HFT : std_logic_vector(3 downto 0);
	signal HFO : std_logic_vector(3 downto 0);
	signal TFT : std_logic_vector(3 downto 0);
	signal TFO : std_logic_vector(3 downto 0); 
	signal mode : std_logic_vector(2 downto 0);
begin
  slow_clk_1:slow_clk port map(In_CLK => In_clock, Out_CLK => clock);
  TEMP_RDM_1:TEMP_RDM port map(CLK => clock, Roll => RDM1, tens => Temp_tens, ones => Temp_ones);
  HUMID_RDM_1:HUMID_RDM port map(CLK => clock, Roll => RDM2, tens => Humid_tens, ones => Humid_ones);
  
  Hygrometer_1:Hygrometer port map(enable => Correction_enable, CLK => clock, t => Humid_tens, o => Humid_ones, above_threshold => downH, below_threshold => upH, tens => HFT, ones => HFO);
  Thermometer_1:Thermometer port map(enable => Correction_enable, CLK => clock, t => Temp_tens, o => Temp_ones, above_threshold => downT, below_threshold => upT, tens => TFT, ones => TFO);
       
  BCD_7Seg_1: BCD_7Seg port map(BCDin_ones => TFO, BCDin_tens => TFT, seg1 => RDM_temp_tens, seg2 => RDM_temp_ones);
  BCD_7Seg_2: BCD_7Seg port map(BCDin_ones => HFO, BCDin_tens => HFT, seg1 => RDM_humid_tens, seg2 => RDM_humid_ones);
  
  napMode_1:napMode port map(soundLvl => soundLvl, CLK => clock, oscillator => oscillator_sig, wirelessSignal => wirelessSignal_sig, speaker => speaker_sig);
  
  UP_H <= upH;
  UP_T <= upT;
  DOWN_H <= downH;
  DOWN_T <= downT;
  
  OSC <= oscillator_sig;
  WLS <= wirelessSignal_sig;
  SPEAK <= speaker_sig;
  
  process(Correction_enable, speaker_sig, oscillator_sig, wirelessSignal_sig)
    begin
    if (Correction_enable = '1') then
      mode <= "001";
    elsif (speaker_sig = "01" or speaker_sig = "10")  then
      mode <= "011";
    elsif (oscillator_sig = '1') then
      mode <= "110";
    elsif (wirelessSignal_sig = '1') then
      mode <= "111";
    else 
      mode <= "000";
    end if;
  end process; 
  
  LCD_1: LCD_Display port map(reset=>'1', clk_48Mhz=>clock, mode=>mode, LCD_RS=>LCD_RS, LCD_E=>LCD_E, LCD_RW=> LCD_RW, DATA_BUS=>LCD_PINS);
   
end SnugWatch;
