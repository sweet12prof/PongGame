----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:54 03/06/2020 
-- Design Name: 
-- Module Name:    GameProcess - Behavioral 
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

entity GameProcess is
	port (
				clk, reset,  startMatch		: in std_logic;
				start			: out std_logic;
				BallhLeft 	: in integer;
				BallhRight  : in integer;
				BallvTop		: in integer;
				BallvDown	: in integer;
				P1Top		   : in integer;
				P1Down		: in integer;
				P2Top			: in integer;
				P2Down		: in integer;
				P1Counts		: out integer;
				P2Counts    : out integer
				
				
			);
end GameProcess;

architecture Behavioral of GameProcess is
	type state_type  is (IDLE, RUNNING, startAgain, refresh, slowSpeed,  STOP );
		signal PS, NS : state_type;
		
		signal P1Count, P2Count, P1CountPrev, P2CountPrev : integer;
		 constant HVD : integer := 640;
		 constant speed : integer := 80000;
		 signal count, countPrev : integer ;
		
begin

	P1Counts <= P1Count;
	P2Counts <= P2Count;
	Sync_Process : process(clk, NS, reset, P1Count, P2Count, Count)
							begin 
								IF(reset = '1') then							
									CountPrev <= 0;
									P1CountPrev <= 0;
									P2CountPrev <= 0;
									PS <= IDLE;
								elsif(rising_edge(clk)) then 
									PS <= NS;
									P1CountPrev <= P1Count;
									P2CountPrev <= P2Count;
									CountPrev  <= Count;
								end if;
							end process;
	
	Com_process : process(PS,  BallhLeft, BallhRight, P1Top, P1Down, P2Top, P2Down, BallvTop, BallvDown, startMatch, P1Count, P2Count, P1CountPrev, P2CountPrev, countPrev )
							begin
								case PS is 
									when idle 	   => 
											start <= '0';
										--	startCount <= '0';
											Count <= CountPrev - CountPrev ;
											P1Count <= P1CountPrev - P1CountPrev;
											P2Count <= P2CountPrev - P2CountPrev;
											if(startMatch = '1') then 
												NS <= startAgain;
											else 
												NS <= idle;
											end if;
									when startAgain =>
											start <= '0';
											Count <= CountPrev - CountPrev ;
											P1Count <= P1CountPrev;
											P2Count <= P2CountPrev;
											NS <= running;
									when running   =>
											START <= '1';
											Count <= CountPrev - CountPrev ;
											P1Count <= P1CountPrev;
											P2Count <= P2CountPrev;
											if( ((BallhRight = HVD - 10 and ((BallvDown <= P2Top) or BalLVTop  >=  P2Down)))) then 
														P1Count <= P1CountPrev + 1;
														P2Count <= P2CountPrev + 0;
														NS <= slowSpeed;
											elsif (BallhLeft = 10 and ((BallvDown <= P1Top) or BalLvTop  >=  P1Down))  then 
														P1Count <= P1CountPrev + 0;
														P2Count <= P2CountPrev + 1;
														NS <= slowSpeed;	
										else 
														NS <= running;
										end if;
									
										
									when Refresh => 
										start <= '0';
										Count <= CountPrev - CountPrev ;
										P1Count <= P1CountPrev + 0;
										P2Count <= P2CountPrev + 0;
										if((P1Count = 10))
											then 
												
													NS <= idle;
										elsif (p2Count = 10) then
												
													NS <= idle;
										elsE
													NS <= StartAgain;
										
											
										end if;
										
									when slowSpeed =>
													start <= '0';
													Count <= CountPrev + 1;
													P1Count <= P1CountPrev + 0;
													P2Count <= P2CountPrev + 0;
													if(Count /= speed * 90) then 
														NS <= SlowSpeed;
													else 
														Count <= CountPrev - CountPrev;
														NS <= refresh;
													end if;
											
									when others => 
									--startCount <= '0';
									Count <= CountPrev - CountPrev ;
									P1Count <= P1CountPrev + 0;
									P2Count <= P2CountPrev + 0;
									START <= '0';
											NS <= idle;
										
								end case;
							end process;
							
	
--		
									
		

end Behavioral;

