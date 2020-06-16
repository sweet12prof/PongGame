----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:29:31 03/06/2020 
-- Design Name: 
-- Module Name:    BallLogic - Behavioral 
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

entity BallLogic is
port
		(
			clk, start : in std_logic;
		
			BallvTopFinal	: out integer;
			BallvDownFinal : out integer;
			
			BallhLeftFinal      : out integer;
			BallhRightFinal	  : out integer
			--=countFinal			  : out integer
		);

end BallLogic;

architecture Behavioral of BallLogic is
		constant HVD : integer := 640;
		constant VVD  : integer := 480; --Vertical Valid Display Lines

		signal BallvTopPrev  : integer;
		signal BallvDownPrev : integer;
      signal BallhLeftPrev  : integer ;
		signal BallhRightPrev : integer ; 
		signal	BallvTop	:  integer;
		signal	BallvDown :  integer;
			
		signal	BallhLeft      : integer;
		signal	BallhRight	  :  integer;
		constant speed : integer := 80000;
		signal count  : integer := 0 ;
		
	
	BEGIN
	

	MoveBALLPorcess_P2: process(clk)
							begin 
								if(rising_edge(clk)) then 
									if(start = '1' ) then 
										if(count = speed) then 
											count <=  0;
										else 
											count <= count + 1;
										end if;
									end if;
								end if;
								
						end process;
						
						
		

		
		process(clk)
			begin 
				
					
				if(rising_edge(clk)) then 
					if(start = '0') then 
						
						
						BallhLeftPrev   <= (hvd / 2) - 5;
						BallhRightPrev	 <= (hvd / 2 ) + 5;
						BallvTopPrev	 <= vvd / 2 - 5;
						BallvDownPrev	<= vvd / 2 + 5;
						
						
						BallhLeft  <=  BallhLeftPrev + 1;
						BallhRight <=  BallhRightPrev + 1;
						BallvTop  <=   BallvTopPrev + 1;
						BallvDown <=  BallvDownPrev + 1;
					else 
					
					if(count = speed) then 
					
									BallhLeftPrev   <= BallhLeft;
									BallhRightPrev	 <= BallhRight;
									BallvTopPrev	 <=  BallvTop ;
									BallvDownPrev	<=  BallvDown ;
								
								if((BallhRight  > BallhRightPrev and BallhRight /=  HVD - 10) or  (BallhRight  < BallhRightPrev and BallhRight =  20)   ) then 
										BallhRight <= BallhRight + 1;
										BallhLeft  <= BallhLeft + 1;
								else
										BallhRight <= BallhRight - 1;
										BallhLeft  <= BallhLeft -  1;
								end if;
								
								if( (BallvDown > BallvDownPrev and BallvDown /=  vvd) or (BallvDown < BallvDownPrev and BallvDown =  0) ) then 
										BallvDown <= BallvDown + 1;
										BallvTop  <= BallvTop + 1;
								else 
										BallvDown <= BallvDown - 1;
										BallvTop  <= BallvTop  - 1;
								END IF;
						end if;
				
				end if;
				
				end if;
		
			end process;
		
			BallvTopFinal	<= BallvTop;
			BallvDownFinal <= BallvDown;
			
			BallhLeftFinal    <= BallhLeft;   
			BallhRightFinal	<= BallhRight;  



end Behavioral;

