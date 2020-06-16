----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:49 03/04/2020 
-- Design Name: 
-- Module Name:    DrawBox - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DrawBox is
	port (
				clk, reset, VideoOn, Vup, VDown, VupP2, vDownP2, start: in std_logic;
				hPos, vPos : in std_logic_vector(9 downto 0);
				rGB		  : out std_logic_vector(2 downto 0);
				BallvTop	: in integer;
				BallvDown : in integer;
				
				BallhLeft     : in integer;
				BallhRight	  : in integer;
				
				P1Top	 : out integer;
				P1Down : out integer;
				P2Top	 : out integer;
				P2Down : out integer
			);
end DrawBox;


architecture Behavioral of DrawBox is
constant HVD : integer := 640;
constant VVD  : integer := 480; --Vertical Valid Display Lines
signal Top  : integer;
signal Down : integer;

signal v2Top  : integer;
signal v2Down : integer;

--		signal		BallvTop		:  integer := vvd / 2 - 5;
--		signal		BallvDown 	: integer := vvd / 2 + 5;
--				
--		signal		BallhLeft     :  integer := (hvd / 2) - 5;
--		signal		BallhRight    :  integer := (hvd / 2 ) + 5;


constant speed : integer := 80000;
signal count  : integer := 0 ;
SIGNAL count2 : integer := 0;





begin
	
	
	
				P1Top	 <= Top;
				P1Down <= Down;
				P2Top	 <= v2Top;
				P2Down <= v2Down;
	
	
	
	
	Draw_P1_BoxProcess : process(clk, reset)
								begin 
									if(reset = '1') then
										rgb <= (others => '1');
									elsif(rising_edge(clk)) then 
										if(videoOn = '1') then 
											rgb <= (others => '1');
												if((to_integer(unsigned(hPos)) > 10 and (to_integer(unsigned(hPos)) < 20)) and (to_integer(unsigned(vPos)) > top and (to_integer(unsigned(vPos)) <= Down))) then
													rgB <= "001";
												elsif((to_integer(unsigned(hPos)) > hvd - 20 and (to_integer(unsigned(hPos)) < hvd - 10)) and (to_integer(unsigned(vPos)) > v2top and (to_integer(unsigned(vPos)) <= v2Down))) then
													rgB <= "001";
												elsif( (to_integer(unsigned(hPos)) > BallhLeft and to_integer(unsigned(hPos)) < BallhRight) and (to_integer(unsigned(vPos)) > BallvTop  and (to_integer(unsigned(vPos)) <= BallvDown))) then 
													rgB <= "010";
												else
													rgb <= (others => '0');
	--											end if;
												end if;
												
										end if;
									end if;
								end process;
--								
--	Draw_P2_BoxProcess : process(clk, reset)
--								begin 
--									if(reset = '1') then
--										rgb <= (others => '0');
--									elsif(rising_edge(clk)) then 
--										if(videoOn = '1') then 
--											if((to_integer(unsigned(hPos)) > hvd - 10 and (to_integer(unsigned(hPos)) < hvd)) and (to_integer(unsigned(vPos)) > top and (to_integer(unsigned(vPos)) <= Down))) then
--												rgB <= (others => '1');
--											end if;
--										end if;
--									end if;
--								end process;

	

	MoveBoxPorcess: process(clk)
							begin 
								if(rising_edge(clk)) then 
									if(Vup = '1' or Vdown = '1') then 
										if(count = speed) then 
											count <=  0;
										else 
											count <= count + 1;
										end if;
									end if;
								end if;
								
						end process;
						
						
		MoveBoxPorcess_MoveUp: process(clk, start)
							begin 
								if(start = '0') then 
									 Top  <= vvd/2 - 50 ;
								    Down <= vvd/2 + 50 ;
									
									
								elsif(rising_edge(clk)) then 
									if(Vup = '1' and count = speed and top > 3) then 
										top <= top - 1;
										Down <= down - 1; 
									elsif(VDown = '1' and count = speed  and Down <= vvd) then 
										top <= top + 1;
										Down <= down + 1; 
									end if;
								end if;
								
						end process;
	
--		MoveBoxPorcess_MoveDown: process(clk)
--							begin 
--								if(rising_edge(clk)) then 
--									if(VDown = '1' and count = speed) then 
--										top <= top - 1;
--										Down <= down - 1; 
--									end if;
--								end if;
--								
--						end process;

	MoveBoxPorcess_P2: process(clk)
							begin 
								if(rising_edge(clk)) then 
									if(VupP2 = '1' or VdownP2 = '1') then 
										if(count2 = speed) then 
											count2 <=  0;
										else 
											count2 <= count2 + 1;
										end if;
									end if;
								end if;
								
						end process;

	MoveBoxPorcess_P2_MoveUp: process(clk, start)
							begin 
								if(start = '0') then 
										v2Top  <= vvd/2 - 50;
									   v2Down <= vvd/2 + 50;
								
								elsif(rising_edge(clk)) then 
									if(Vupp2 = '1' and count2 = speed and v2top > 3) then 
										v2top <= v2top - 1;
										v2Down <= v2down - 1; 
									elsif(VDownp2 = '1' and count2 = speed  and v2Down <= vvd) then 
										v2top <= v2top + 1;
										v2Down <= v2down + 1; 
									end if;
								end if;
								
						end process;
						
						
						
	
						
						
						
	
								
end Behavioral;

