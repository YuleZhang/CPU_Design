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
    Port ( cs : in  STD_LOGIC;   --�Ĵ�����Ƭѡ�ź�
           rd : in  STD_LOGIC;   --�Ĵ����Ѷ��ź�
           wr : in  STD_LOGIC;   --�Ĵ�����д�ź�
           rdReg1 : in  STD_LOGIC_VECTOR (2 downto 0);  --������һ���Ĵ����ı��
           rdReg2 : in  STD_LOGIC_VECTOR (2 downto 0);  --������һ���Ĵ����ı��
           rdData1 : out  STD_LOGIC_VECTOR (15 downto 0); --������һ���Ĵ�����ֵ
           rdData2 : out  STD_LOGIC_VECTOR (15 downto 0); --������һ���Ĵ�����ֵ
           wrReg : in  STD_LOGIC_VECTOR (2 downto 0);  --��д�ļĴ����ı��
           wrData : in  STD_LOGIC_VECTOR (15 downto 0));  --��д������
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

