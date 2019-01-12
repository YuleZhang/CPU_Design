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

entity CPU is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  addr: out STD_LOGIC_VECTOR(17 downto 0);
			  data:inout STD_LOGIC_VECTOR(15 downto 0);
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
			  RAM_EN : out STD_LOGIC;
			  RAM_OE : out STD_LOGIC;
			  RAM_WE : out STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is
---Memory
signal MemRead : STD_LOGIC := '0';
signal MemWrite : STD_LOGIC;
signal AddrtoMem : STD_LOGIC := '0';--0表示来源于PC，1表示来源于ALUOut
signal MemData : STD_LOGIC_VECTOR(15 downto 0);
---ALU
signal ALUA : STD_LOGIC;
signal ALUB : STD_LOGIC_VECTOR(1 downto 0);
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0) := "11";
signal ALUData1: STD_LOGIC_VECTOR(15 downto 0);
signal ALUData2: STD_LOGIC_VECTOR(15 downto 0);
signal ALUOut : STD_LOGIC_VECTOR(15 downto 0);
---RegisterFile
signal RegRead : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal RegWrite : STD_LOGIC; --寄存器写信号
signal RegDes : STD_LOGIC;--0写回通用寄存器，1写回T
signal MemtoReg : STD_LOGIC_VECTOR(1 downto 0); --0表示来源于ALUOut,1表示来源于立即数,2来源于内存,3来源于寄存器ry
signal rx : STD_LOGIC_VECTOR(2 downto 0);
signal ry : STD_LOGIC_VECTOR(2 downto 0);
signal rz : STD_LOGIC_VECTOR(2 downto 0);
signal rxyzChoice : STD_LOGIC_VECTOR(1 downto 0) := "00";--0为rx,1为ry,2为rz
signal RegReData1 : STD_LOGIC_VECTOR(15 downto 0);
signal RegReData2 : STD_LOGIC_VECTOR(15 downto 0);

signal IR : STD_LOGIC_VECTOR(15 downto 0);
signal T : STD_LOGIC_VECTOR(15 downto 0);
type reg_file_type is array (0 to 7) OF std_logic_vector(15 downto 0);
signal array_reg : reg_file_type := (
		x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
---System Signal
signal PC : STD_LOGIC_VECTOR(17 downto 0) := "000000000000000000";--测试
signal IrWrite : STD_lOGIC;
signal PcWrite : STD_LOGIC;
---Instructions Status
signal InStatus : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal Instructions : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
---Instructions Test Tmp
signal imm : STD_LOGIC_VECTOR(15 downto 0);
signal cnt : STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";--指令暂存
signal flag : STD_LOGIC:='1';
signal swLoad : STD_LOGIC:='0';
signal fake_rst : STD_LOGIC := '0';

begin
RAM_EN <= '0';
RAM_WE <= '0' when (MemWrite = '1') else '1';
RAM_OE <= '0' when (MemRead = '1' or data = "ZZZZZZZZZZZZZZZZ" or MemWrite = '0') else '1';
data <= cnt when flag = '1' else RegReData2 when (swLoad = '1' or MemWrite = '1')
 else "ZZZZZZZZZZZZZZZZ";
addr <= "00" & ALUOut when (swLoad = '1') else PC when (MemRead = '0' and AddrtoMem = '0') else "00" & ALUOut;
MemData <= data when (MemRead = '1' and AddrtoMem = '1') else x"0000";
Instructions <= data when (MemRead = '1' and AddrtoMem = '1') else Instructions;
--控制器进程
process(clk,rst,InStatus)
variable count: integer range 0 to 100:=0;
begin
	if(rst = '0')then
		InStatus <= "000";
		MemRead <= '0';
		MemWrite <= '0';
		ALUOp <= "00";
		ALUA <= '0';
		ALUB <= "00";
		RegRead <= "00";
		RegWrite <= '0';
		rx <= "000";
		ry <= "000";
		rz <= "000";
		IrWrite <= '0';
		PcWrite <= '0';
		rxyzChoice <= "11";
		--Instructions <= x"0000";
	elsif(clk'event and clk= '1')then
		--先采用内存储器实验步骤，将指令二进制码存进去，再读首地址，顺序执行
		case InStatus is  --取指，在取指的同时进行数据准备
			when "000" =>
				if(count < 33)then
					MemWrite <= '0';
					--累加测试
					case count is
--							when 0=>
--								cnt <= "0000001000000001";
--							when 1=> 
--								cnt <= "0000011000000000";
--							when 2=>
--								cnt<= "0010001011011000";
--							when 3=>
--								cnt<= "0001001000000001";
--							when 4=>
--								cnt<= "1000001000001011";
--							when 5=>
--								cnt<= "1010000111111100";
--							when 6=>
--								cnt<= "1011000000000000";
--							when others=>
--								null;
						--排序测试
						when 0=>
							cnt <= "0000011000000011";
						when 1=>
							cnt <= "0000100000000011";
						when 2=>
							cnt <= "0000101000000000";
						when 3=>
							cnt <= "0000000010000000";
						when 4=>
							cnt <= "0011000000000000";
						when 5=>
							cnt <= "0100000001000000";
						when 6=>
							cnt <= "0100000010000001";
						when 7=>
							cnt <= "0110001010000000";
						when 8=>
							cnt <= "1010000000000011";
						when 9=>
							cnt <= "0111101001000000";
						when 10=>
							cnt <= "0111001010000000";
						when 11=>
							cnt <= "0111010101000000";
						when 12=>
							cnt <= "0101000001000000";
						when 13=>
							cnt <= "0101000010000001";
						when 14=>
							cnt <= "0001000000000001";
						when 15=>
							cnt <= "0001100111111111";
						when 16=>
							cnt <= "1001100111110100";
						when 17=>
							cnt <= "1011100000000000";
						when 18=>
							cnt <= "0001011111111111";
						when 19=>
							cnt <= "0010100011100000";
						when 20=>
							cnt <= "1001011111101110";
						when 21=>--测试部分
							cnt <= "0000000010000000";
						when 22=>
							cnt <= "0011000000000000";
						when 23=>
							cnt <= "0100000110000000";
						when 24=>
							cnt <= "0100000110000001";
						when 25=>
							cnt <= "0100000110000010";
						when 26=>
							cnt <= "0100000110000011";
						when 27=>
							cnt <= "0100000110000100";
						when 28=>
							cnt <= "0100000110000101";
						when 29=>
							cnt <= "0100000110000110";
						when 30=>
							cnt <= "0100000110000111";
						when 31=>
							cnt <= "0100000110001000";
						when 32=>
							cnt <= "0100000110001001";
						when others=>
							null;
					end case;
					led <= PC(15 downto 0);
					ALUA <= '1';
					ALUB <= "01";
					ALUOp <= "00";
					PcWrite <= '0';
					InStatus <= "100";
				elsif(count = 33)then
					led <= PC(15 downto 0);
					MemRead <= '0';
					AddrtoMem <= '0';
					fake_rst <= '1';
					flag <= '0';
					MemWrite <= '0';
					count := count + 1;
				else
					fake_rst <= '0';
					if(rxyzChoice = "00")then
						led <= array_reg(conv_integer(unsigned(rx)));
					elsif(rxyzChoice = "01")then
						led <= array_reg(conv_integer(unsigned(ry)));
					else
						led <= array_reg(conv_integer(unsigned(rz)));
					end if;
					--led <= array_reg(3);
					MemRead <= '1'; --读指令值
					MemWrite <= '0';
					ALUA <= '1';
					ALUB <= "01";
					ALUOp <= "00";
					PcWrite <= '0';
					rxyzChoice <= "11";
					RegWrite <= '0'; 
					AddrtoMem <= '1';
					PcWrite <= '0';
					--PcSource <= '0';
					InStatus <= "001";
				end if;
			when "001" =>  --译码
				PcWrite <= '1';
				led <= Instructions;
				IRWrite <= '1';--指令写入指令寄存器
				MemRead <= '0';
				MemWrite <= '0';
				case Instructions(15 downto 12) is---说明：当操作数B来源于立即数时，imm触发进程，直接赋值
					when "0000" => --LI
						rx <= Instructions(11 downto 9);
						imm <= "0000000" & Instructions(8 downto 0);
						MemtoReg <= "01";
						RegDes <= '0';
						rxyzChoice <= "00";
						InStatus <= "100";
					when "0001" => --ADDIU
						rx <= Instructions(11 downto 9);
						if(Instructions(8) = '1')then
							imm <= "1111111" & Instructions(8 downto 0);
						else
							imm <= "0000000" & Instructions(8 downto 0);
						end if;
						MemtoReg <= "00";
						ALUA <= '0';
						ALUB <= "10";
						ALUOp <= "00";
						RegDes <= '0';
						rxyzChoice <= "00";
						InStatus<="100";
					when "0010" => --ADDU
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						rz <= Instructions(5 downto 3);
						ALUA <= '0';
						ALUB <= "00";
						ALUOp <= "00";
						MemtoReg <= "00";
						RegDes <= '0';
						rxyzChoice <= "10";
						InStatus <= "100";
					when "0011" => --SLL
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						imm <= "0000000000" & Instructions(5 downto 0);
						ALUA <= '0';--实际没用
						ALUB <= "00";
						ALUOp <= "01";
						MemtoReg <= "00";
						RegDes <= '0';
						rxyzChoice <= "01";
						InStatus <= "100";
					when "0100" => --LW
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						imm <= "0000000000" & Instructions(5 downto 0);
						ALUA <= '0';
						ALUB <= "10";
						ALUOp <= "00";
						MemtoReg <= "10";
						RegDes <= '0';
						swLoad <= '1';
						rxyzChoice <= "01";
						AddrtoMem <= '1';
						InStatus <= "010";
					when "0101" => --SW
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						imm <= "0000000000" & Instructions(5 downto 0);
						ALUA <= '0';
						ALUB <= "10";
						ALUOp <= "00";
						AddrtoMem <= '1';
						swLoad <= '1';
						InStatus <= "010";
					when "0110" => --SLT
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						ALUA <= '0';
						ALUB <= "00";
						ALUOp <= "10";
						MemtoReg <= "00";
						RegDes <= '1';
						InStatus <= "100";
					when "0111" =>  --MOVE
						rx <= Instructions(11 downto 9);
						ry <= Instructions(8 downto 6);
						MemtoReg <= "11";
						RegDes <= '0';
						rxyzChoice <= "00";
						InStatus <= "100";
					when "1000" => --SLTI
						rx <= Instructions(11 downto 9);
						imm <= "0000000" & Instructions(8 downto 0);
						ALUA <= '0';
						ALUB <= "10";
						ALUOp <= "10";
						MemtoReg <= "00";
						RegDes <= '1';
						InStatus <= "100";
					when "1001" => --BNEZA
						rx <= Instructions(11 downto 9);
						if(Instructions(8) = '1')then
							imm <= "1111111" & Instructions(8 downto 0);
						else
							imm <= "0000000" & Instructions(8 downto 0);
						end if;
						ALUA <= '1';
						ALUB <= "10";
						ALUOp <= "00";
--						PcSource <= '0';
						InStatus <= "010";
					when "1010" => --BTNEZ
						if(Instructions(8) = '1')then
							imm <= "1111111" & Instructions(8 downto 0);
						else
							imm <= "0000000" & Instructions(8 downto 0);
						end if;
						ALUA <= '1';
						ALUA <= '1';
						ALUB <= "10";
						ALUOp <= "00";
						--PcSource <= '0';
						InStatus <= "010";
					when "1011" => --NOP
						InStatus <= "100";
					when others=>
						InStatus <= "111";
						null;
				end case;
			when "010" => ---执行(ALU运算)
				led <= ALUOut;
				PcWrite <= '0';
				case Instructions(15 downto 12) is
					when "1000"|"0110" =>
						RegWrite <= '1';
					when "0101" =>
						MemWrite <= '1';
						swLoad <= '0';
					when others=>
						null;
				end case;
				InStatus <="011";
			when "011" => ---访存取数
				led <= imm;
				case Instructions(15 downto 12) is
					when "0100" =>
						MemRead <= '1';
						swLoad <= '0';
					when "0101" =>
						MemWrite <= '0';
					when "1001" =>
						if(RegReData1 /= x"0000")then
							PcWrite <= '1';
						end if;
					when "1010" =>
						if(T /= x"0000")then
							PcWrite <= '1';
						end if;
					when others =>
						null;
				end case;
				InStatus <= "100";
			when "100" => ---结果写回
				led <= PC(15 downto 0);
				led <= imm;
				RegWrite <= '1';
				imm <= x"0000";
				if(count < 33)then
					MemWrite <= '1';
					led <= data;
					PcWrite <= '1';
				end if;
				AddrtoMem <= '0';
				MemRead <= '0';
				InStatus <= "000";
				count := count + 1;
			when others=>
				null;
			end case;
	end if;
end process;

--执行运算
process(rst, ALUOp)
variable logic_shift_num : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
begin
	if(rst = '0')then
		ALUOut <= x"0000";
	end if;
	if(ALUOp = "00")then
		ALUOut <= ALUData1 + ALUData2;
	elsif(ALUOp = "01")then
		if(imm = x"0000")then
			ALUOut <= ALUData2(7 downto 0) & "00000000";
		else
			ALUOut <= ALUData2(15 - CONV_INTEGER(unsigned(imm)) downto 0) & logic_shift_num(CONV_INTEGER(unsigned(imm)) - 1 downto 0);
		end if;
	elsif(ALUOp = "10")then
		if(conv_integer(unsigned(ALUData1)) < conv_integer(unsigned(ALUData2)))then
			ALUOut <= x"0001";
		else
			ALUOut <= x"0000";
		end if;
	end if;
end process;
--ALU操作数A,B赋值
process(ALUA, ALUB, RegReData1, RegReData2, PC, imm)
begin
	if(ALUA = '0')then
		ALUData1 <= RegReData1;
	else
		ALUData1 <= PC(15 downto 0);
	end if;
	if(ALUB = "00")then
		ALUData2 <= RegReData2;
	elsif(ALUB = "01")then  --常数1
		ALUData2 <= x"0001";
	elsif(ALUB = "10")then  --来自立即数
		ALUData2 <= imm;
	end if;
end process;

process(IRWrite)
begin
	if(IrWrite'event and IrWrite = '1')then
		IR <= instructions;
	end if;
end process;

process(fake_rst,PcWrite, ALUOut)
begin
	if(fake_rst = '1')then
		PC <= "000000000000000000";
	elsif(PcWrite'event and PcWrite = '1')then
		PC <= "00" & ALUOut;
	end if;
end process;

process(rst, rx, ry)
begin
	if(rst = '0')then
		RegReData1 <= x"0000";
		RegReData2 <= x"0000";
	end if;
	RegReData1 <= array_reg(conv_integer(unsigned(rx)));
	RegReData2 <= array_reg(conv_integer(unsigned(ry)));
end process;

process(RegWrite, imm, ALUOut, rxyzChoice, MemtoReg)
variable tmp_res : STD_LOGIC_VECTOR(15 downto 0):= x"0000";
begin
	if(MemtoReg = "00")then
		tmp_res := ALUOut;
	elsif(MemtoReg = "01")then
		tmp_res := imm;
	elsif(MemtoReg = "10")then
		tmp_res := MemData;
	else
		tmp_res := RegReData2;
	end if;
	if(RegWrite'event and RegWrite = '1')then
		if(RegDes = '0') then--写回通用寄存器
			--rxyzChoice
			case rxyzChoice is
				when "00"=>
					array_reg(conv_integer(unsigned(rx))) <= tmp_res;
				when "01"=>
					array_reg(conv_integer(unsigned(ry))) <= tmp_res;
				when "10"=>
					array_reg(conv_integer(unsigned(rz))) <= tmp_res;
				when others=>
					null;
			end case;
		else ---写回寄存器T
			T <= tmp_res;
		end if;
	end if;
end process;
end Behavioral;

