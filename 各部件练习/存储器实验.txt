----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:15 12/29/2018 
-- Design Name: 
-- Module Name:    SRAM - Behavioral 
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

entity SRAM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  addr: out STD_LOGIC_VECTOR(17 downto 0);
			  data:inout STD_LOGIC_VECTOR(15 downto 0);
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
			  RAM_EN : out STD_LOGIC;
			  RAM_OE : out STD_LOGIC;
			  RAM_RW : out STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (15 downto 0));
end SRAM;

architecture Behavioral of SRAM is
signal status:STD_LOGIC_VECTOR(2 downto 0):="000";
signal cnt: STD_LOGIC_VECTOR(17 downto 0):= "000000000000000000";
signal tmp_addr: STD_LOGIC_VECTOR(17 downto 0):= "000000000000000000";
signal tmp_data: STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
begin

process(clk, rst)
variable count: integer range 0 to 100:= 0;
begin
	if(rst = '0')then
		addr <= "000000000000000000";
		data <= "0000000000000000";
	else
		if(clk'event and clk = '0')then
			if(status = "000")then 
				if(count = 0)then
					tmp_addr <= "00" & sw;--存在赋值延时,无法在当前状态机下检测到值的变化
					led <= sw;
				else 
					led <= tmp_addr(15 downto 0);--测试
				end if;
				RAM_EN <= '0';
				RAM_OE <= '1';
				RAM_RW <= '1';
				status <= "001";
			elsif(status = "001")then
				if(count = 0)then
					tmp_data <= sw;
					led <= sw;
				else
					led <= tmp_data;--测试
				end if;
				RAM_EN <= '0';
				RAM_OE <= '1';
				RAM_RW <= '1';
				status <= "010";
			elsif(status = "010")then
				led <= "0000000000000000";
				RAM_EN <= '0';
				RAM_OE <= '1';
				RAM_RW <= '0';
				tmp_addr <= tmp_addr + '1';
				addr <= tmp_addr;
				tmp_data <= tmp_data + '1';
				data <= tmp_data;
				count := count + 1;
				status <= "000";
			elsif(status = "011")then
				led <= "1111111111111111";
				RAM_EN <= '0';
				RAM_OE <= '1';
				RAM_RW <= '1';
				addr <= cnt;
				data <= "ZZZZZZZZZZZZZZZZ";
				status <= "100";
			elsif(status = "100")then
				RAM_EN <= '0';
				RAM_OE <= '0';
				RAM_RW <= '1';
				cnt <= cnt + '1';
				status<= "101";
			elsif(status = "101")then
				count := count + 1;
				led <= data;
				addr <= cnt;--由于赋值存在延时，因此要在上一个过程提前准备好地址或数据
				status <= "100";
			end if;
			if(count = 10)then
				count := count + 1;
				cnt <= "00" & sw;--赋值延时
				status <= "011";
			elsif(count = 21)then
				status <= "000";
				count := 0;
			end if;
		end if;
	end if;
end process;

end Behavioral;

