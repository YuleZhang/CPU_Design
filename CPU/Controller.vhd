----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:15:18 01/03/2019 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  instructions : in STD_LOGIC_VECTOR(15 downto 0);
			  MemRead : out STD_LOGIC;
			  MemWrite: out STD_lOGIC;
			  ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
			  ALUA : out STD_LOGIC;
			  ALUB : out STD_LOGIC_VECTOR(1 downto 0);
			  IRWrite : out STD_LOGIC
			  );
end Controller;

architecture Behavioral of Controller is
signal status : STD_LOGIC_VECTOR(2 downto 0);
signal instruction_fetch : STD_LOGIC;
signal decode : STD_LOGIC;
begin
process(clk)
	if(clk'event and clk = '1')then
		if(status = "000")then
		--È¡Ö¸
			 MemRead <= '1';
			 MemWrite <= '0';
			 ALUOp <= "00";
			 ALUA <= '1';
			 ALUB <= "01";
			 IRWrite <= '1';
			 status <= "001";
		elsif(status = "001")then
		--ÒëÂë
			decode <= '1';
			status <= "010";
			
		end if;
	end if;
end process;

end Behavioral;

