----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:56:19 12/31/2018 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( cs : in  STD_LOGIC;   --¼Ä´æÆ÷¶ÑÆ¬Ñ¡ÐÅºÅ
           rd : in  STD_LOGIC;   --¼Ä´æÆ÷¶Ñ¶ÁÐÅºÅ
           wr : in  STD_LOGIC;   --¼Ä´æÆ÷¶ÑÐ´ÐÅºÅ
           rdReg1 : in  STD_LOGIC_VECTOR (2 downto 0);  --´ý¶ÁµÚÒ»¸ö¼Ä´æÆ÷µÄ±àºÅ
           rdReg2 : in  STD_LOGIC_VECTOR (2 downto 0);  --´ý¶ÁµÚÒ»¸ö¼Ä´æÆ÷µÄ±àºÅ
           rdData1 : out  STD_LOGIC_VECTOR (15 downto 0); --´ý¶ÁµÚÒ»¸ö¼Ä´æÆ÷µÄÖµ
           rdData2 : out  STD_LOGIC_VECTOR (15 downto 0); --´ý¶ÁµÚÒ»¸ö¼Ä´æÆ÷µÄÖµ
           wrReg : in  STD_LOGIC_VECTOR (2 downto 0);  --´ýÐ´µÄ¼Ä´æÆ÷µÄ±àºÅ
           wrData : in  STD_LOGIC_VECTOR (15 downto 0));  --´ýÐ´µÄÊý¾Ý
end RegisterFile;

architecture Behavioral of RegisterFile is
begin
process(cs, wr, rd)
	constant NUM_REGISTERS: integer:= 8;
	type RegisterType is array(0 to NUM_REGISTERS - 1) of STD_LOGIC_VECTOR(15 downto 0);
	variable registers: RegisterType;
	begin
		if(cs = '0')then
			for i in 0 to NUM_REGISTERS - 1 loop
				registers(i) := "0000000000000000";
			end loop;
		elsif(cs = '1' and wr = '1')then
			if(wrReg /= "000")then
				registers(to_integer(unsigned(wrReg))) := wrData;
			end if;
		elsif(cs = '1' and rd = '1')then 
			rdData1 <= registers(to_integer(unsigned(rdReg1)));
			rdData2 <= registers(to_integer(unsigned(rdReg2)));
		end if;
end process;

end Behavioral;

