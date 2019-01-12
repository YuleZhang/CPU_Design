----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:40:59 12/19/2018 
-- Design Name: 
-- Module Name:    ALU_desigin - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_desigin is
    Port ( clk : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0));
end ALU_desigin;

architecture Behavioral of ALU_desigin is
signal opa:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
signal opb:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
signal status:STD_LOGIC_VECTOR(1 downto 0):= "00";
begin
process(clk)--√Ù∏––≈∫≈£¨¥•∑¢
begin
	if(clk'event and clk = '0') then
		if(status = "00")then
			led <= not opa;
			opa <= sw;
			status <= "01";
		end if;
		if(status = "01")then
			led <= not opb;
			opb <= sw;
			status <= "10";
		end if;
		if(status = "10")then
			
			--if(sw = "1111111111111111")then
			--	led <= opa + opb;
			--	led <= "1111111111111111";
			--end if;
			--if(sw = "1111111111111110")then
			--	led <= opa - opb;
			--end if;
			led <= "1111111111111111";
			status <= "11";
		end if;
		if(status = "11")then
			status <= "00";
			led <= "0000000000000000";
		end if;
	end if;
end process;

end Behavioral;

