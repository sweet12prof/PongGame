----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:03 03/04/2020 
-- Design Name: 
-- Module Name:    VGAdriver - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAdriver is
	port (
				clk, reset : in std_logic;
				Vsync, HSync  : Out std_logic;
				hPos, vPos	  : out std_logic_vector(9 downto 0);
				videoOn		  : out std_logic
				
			);
end VGAdriver;

architecture Behavioral of VGAdriver is
	
	constant HTD : integer := 800; --Horizontal Display
	constant HVD : integer := 640; --Horizontal Valid Display 
	constant HFP : integer := 16;
	constant HBP : integer := 48;
	constant HPW : integer := 96;
	
	constant VTD  : integer := 521; --Vertical Total lines
	constant VVD  : integer := 480; --Vertical Valid Display Lines
	constant VFP  : integer :=  10; --Vertical Front Porch
	constant VBP  : integer :=  29; --Vertical Back Porch
	constant VPW  : integer :=  2;
	
	signal hPosSignal, vPosSignal : std_logic_vector(9 downto 0);

begin

	hPos <= hPosSignal;
	vPos <= vPosSignal;
	horizontalCountProcess : process(clk, reset)
										begin 
											if(reset = '1') then 
												hPosSignal <= (others => '0');
											elsif(rising_edge(clk)) then 
												if(hPosSignal < HTD - 1) then 
													hPosSignal <= hPosSignal + 1;
												else 
													hPosSignal <= (others => '0');
												end if;
											end if;
										end process;
	

	VerticalCountProcess : process(clk, reset, hPosSignal)
										begin 
											if(reset = '1') then 
												vPosSignal  <= (others => '0');
											elsif(rising_edge(clk)) then 
												if(hPosSignal = HTD - 1) then
													if(vPosSignal  < VTD - 1) then 
														vPosSignal  <= vPosSignal  + 1;
													else 
														vPosSignal  <= (others => '0');
													end if;
												end if;
											end if;						
										end process;
	

	hSyncProcess : process(hPosSignal, clk, reset)
							begin 
								if(reset = '1') then 
									hSync <= '0';
								elsif(rising_edge(clk)) then 
										if(hPosSignal < (HVD + HFP - 1) or hPosSignal > (HVD + HFP + HPW - 1)) then 
											HSync <= '1'; 
										else 
											HSync <= '0';
										end if;
								end if;
							end process;
							

	VerticalSyncProcess : process(vPosSignal, clk, reset)
							begin 
								if(reset = '1') then 
									vSync <= '0';
								elsif(rising_edge(clk)) then 
										if(vPosSignal < (vVD + vFP - 1) or vPosSignal > (vVD + vFP + vPW - 1)) then 
											vSync <= '1'; 
										else 
											vSync <= '0';
										end if;
								end if;
							end process;
							
	
 Video_OnProcess : process(hPosSignal, vPosSignal, Clk, reset)
							begin 
								if(reset = '1') then 
									videoOn <= '0';
								elsif(rising_edge(clk)) then	
									if(hPosSignal <= hVD - 1 and vPosSignal <= vvD - 1) then 
										videoOn <= '1';
									end if;
								end if;
							end process;


end Behavioral;

