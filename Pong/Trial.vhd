----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:24:24 03/04/2020 
-- Design Name: 
-- Module Name:    Trial - Behavioral 
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

entity Trial is
    Port ( 
				clk, vUp, vDown, VupP2, vDownP2, start  : in  STD_LOGIC;
				rgb		    : out std_logic_vector(2 downto 0);
				VSync, HSync : out std_logic;
				An_Out : out std_logic_Vector(3 downto 0);
            SS_Out : out std_logic_Vector(6 downto 0)
			);
end Trial;

architecture Behavioral of Trial is

	component VGAdriver is
		port (
					clk, reset  : in std_logic;
					Vsync, HSync  : Out std_logic;
					hPos, vPos	  : out std_logic_vector(9 downto 0);
					videoOn		  : out std_logic
					
				);
	end component;
	
	COMPONENT my_DCM1
				PORT(
						CLKIN_IN : IN std_logic;          
						CLKFX_OUT : OUT std_logic;
						CLKIN_IBUFG_OUT : OUT std_logic;
						CLK0_OUT : OUT std_logic;
						LOCKED_OUT : OUT std_logic
					);
	END COMPONENT;
	
	component DrawBox is
		port (
					clk, reset, VideoOn, start : in std_logic;
					hPos, vPos : in std_logic_vector(9 downto 0);
					rGB		  : out std_logic_vector(2 downto 0);
					vUp        : in std_logic;
					vDown, VupP2, vDownP2      : in std_logic;
					BallvTop	: in integer;
					BallvDown : in integer;
				
					BallhLeft    : in integer;
					BallhRight	  : in integer;
					P1Top	 : out integer;
					P1Down : out integer;
					P2Top	 : out integer;
					P2Down : out integer
				);
	end component;
	
	component BallLogic is
		port
		(
			clk, start : in std_logic;
		
			BallvTopFinal	: out integer;
			BallvDownFinal : out integer;
			
			BallhLeftFinal      : out integer;
			BallhRightFinal	  : out integer
			--countFinal			  : out integer
			
		);
	end component;
	
	component Seven_Segment is
		Port 
        (
            clk : in std_logic;
            SS_In1 : in std_logic_vector(7 downto 0);
            SS_In2 : in std_logic_Vector(7 downto 0);
            
            An_Out : out std_logic_Vector(3 downto 0);
            SS_Out : out std_logic_Vector(6 downto 0)
        );
	end component;

	
	
	component GameProcess 
	port (
				clk, reset,  startMatch			: in std_logic;
				start			: out std_logic;
				BallhLeft 	: in integer;
				BallhRight  : in integer;
				BallvTop		: in integer;
				BallvDown	: in integer;
				P1Top		   : in integer;
				P1Down		: in integer;
				P2Top			: in integer;
				P2Down		: in integer;
				--count			  : in integer
				P1Counts    : out integer;
				P2Counts 	: out integer
	  	);
	end component;
	

	signal locked, resetSig, VideoOn, clk_25, someSig1, someSig2, startMatch2 : std_logic;
	signal hPos, vPos : std_logic_vector(9 downto 0);
	signal				BallvTopFinal	:  integer;
	signal				BallvDownFinal :  integer;
				
	signal				BallhLeftFinal      :  integer;
	signal				BallhRightFinal, P1Top, P1down, P2Top, P2Down, P1Count, P2Count	  :  integer;
	 signal SS_In1 :  std_logic_vector(7 downto 0);
    signal SS_In2 :  std_logic_Vector(7 downto 0);
            
begin

			Inst_my_DCM1: my_DCM1 PORT MAP(
														CLKIN_IN => clk,
														CLKFX_OUT => Clk_25,
														CLKIN_IBUFG_OUT => someSig1,
														CLK0_OUT => someSig2,
														LOCKED_OUT => locked 
													);

			resetSig <= not locked;
			
			VGAdriverPortMap :  VGAdriver port map (
																	clk    => clk_25,
																	reset  => resetSig,
																	Vsync  => VSync,
																	HSync  => HSync,
																	hPos    => hPos,
																	vPos	  => vPos,
																	videoOn => videoOn		
								
																	);
																	
		DrawBoxPortMap : DrawBox port map (
															
															clk     => clk_25, 
															reset   => resetSig, 
															VideoOn => VideoOn,
															hPos    => hPos,
															vPos    => vPos,
															rGB	  => rGb,
															vUp	  => Vup,
															vDown   => VDown,
															VupP2   => VupP2,  
															vDownP2 => vDownP2,
															
															BallvTop	  =>	BallvTopFinal,		
																BallvDown  =>  BallvDownFinal, 
																                     
																BallhLeft  =>  BallhLeftFinal, 
																BallhRight  =>  BallhRightFinal,
																
																
																P1Top	 => P1Top,
																P1Down => P1Down,
																P2Top	 => P2Top,
																P2Down => P2Down,
																
																start => startMatch2
															
															
														 );
											
	BallLogicMap : BallLogic port map 
														
															(
																clk   =>  clk_25,
																start =>  startMatch2,
															
																BallvTopFinal	  =>	BallvTopFinal,		
																BallvDownFinal   =>  BallvDownFinal, 
																                     
																BallhLeftFinal   =>  BallhLeftFinal, 
																BallhRightFinal  =>  BallhRightFinal
															--	countFinal	     => count
															);
	
	
	GPPortMap :		GameProcess port map (
																clk     	 => clk_25,
																reset     => resetSig, 
																startMatch	=> start, 
																start			=> startMatch2,
																BallhLeft 	=> BallhLeftFinal, 
																BallhRight  =>	BallhRightFinal,
																BallvTop		=>		BallvTopFinal,
																BallvDown	=> BallvDownFinal, 
																P1Top		   => P1Top,
																P1Down		=> P1Down,
																P2Top			=> P2Top,
																P2Down		=> P2Down,
																P1Counts		=>	P1Count,
																P2Counts     => P2Count
															--	count => count
																
															);
	SSPortMap	: Seven_Segment Port map 
        (
            clk     => clk_25,
            SS_In1  => SS_In1,
            SS_In2  => SS_In2,
            
            An_Out => An_Out,
            SS_Out  => SS_Out
        );
	
	
	SS_In2 <= std_logic_vector(to_unsigned(P1Count, SS_In2'length));
	SS_In1 <= std_logic_vector(to_unsigned(P2Count, SS_In1'length));
	
	
end Behavioral;

