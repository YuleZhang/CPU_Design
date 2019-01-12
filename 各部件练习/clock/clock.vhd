----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:15 12/18/2018 
-- Design Name: 
-- Module Name:    clock - Behavioral 
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

entity clock is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           seg1 : out  STD_LOGIC_VECTOR (6 downto 0);
           seg2 : out  STD_LOGIC_VECTOR (6 downto 0));
end clock;

architecture Behavioral of clock is
	signal clk_out : std_logic:='0';
	signal cnt : std_logic_vector(25 downto 0):="00000000000000000000000000";
	signal cnt_H : std_logic_vector(3 downto 0):="0000";
	signal cnt_L : std_logic_vector(3 downto 0):="0000";
begin

process(clk)
begin
	if(clk'event and clk='1')then
		cnt<=cnt+'1';
		if(cnt = "00000000000000000000000000") then
			clk_out <='0';
		end if;
		if(cnt = "01011011100011011000000000") then
			cnt <= "00000000000000000000000000";
			clk_out <= '1';
		end if;
	end if;
end process;

process(clk_out, rst)
	variable tmp_H,tmp_L:std_logic_vector(3 downto 0):="0000";
begin
	if(rst = '0') then 
		tmp_L := "0000";
		tmp_H := "0000";
	else
		if(clk_out'event and clk_out='1')then
			tmp_L:= cnt_L+'1';
			if(tmp_L > "1001")then
				tmp_L := "0000";
				tmp_H := cnt_H+'1';
				if(tmp_H>"1001")then
					tmp_H:="0000";
				end if;
			end if;
		end if;
	end if;
	cnt_L<=tmp_L;
	cnt_H<=tmp_H;
end process;
process(cnt_L)
begin
	case cnt_L is
		when "0000"=>seg1<=not "1000000";
		when "0001"=>seg1<=not "1111001";
		when "0010"=>seg1<=not "0100100";
		when "0011"=>seg1<=not "0110000";
		when "0100"=>seg1<=not "0011001";
		when "0101"=>seg1<=not "0010010";
		when "0110"=>seg1<=not "0000010";
		when "0111"=>seg1<=not "1111000";
		when "1000"=>seg1<=not "0000000";
		when "1001"=>seg1<=not "0010000";
		when others=>seg1<=not "1111111";
	end case;
end process;

process(cnt_H)
begin
	case cnt_H is
		when "0000"=>seg2<=not "1000000";
		when "0001"=>seg2<=not "1111001";
		when "0010"=>seg2<=not "0100100";
		when "0011"=>seg2<=not "0110000";
		when "0100"=>seg2<=not "0011001";
		when "0101"=>seg2<=not "0010010";
		when "0110"=>seg2<=not "0000010";
		when "0111"=>seg2<=not "1111000";
		when "1000"=>seg2<=not "0000000";
		when "1001"=>seg2<=not "0010000";
		when others=>seg2<=not "1111111";
	end case;
end process;
end Behavioral;

