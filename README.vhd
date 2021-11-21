LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------------
ENTITY Racquets_Movement1 IS
 PORT (clk     :   IN    STD_LOGIC;
       rst     :   IN    STD_LOGIC;
		 ena     :   IN    STD_LOGIC;
       up      :   IN    STD_LOGIC;
		 down    :   IN    STD_LOGIC;
       Rac_Pos:   OUT   STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY Racquets_Movement1;
--------------------------------------------------------------------
ARCHITECTURE functional OF Racquets_Movement1 IS
TYPE state IS (rest, Movement_1, Movement_2, Movement_3, Movement_4, Movement_5);
SIGNAL pr_state, nx_state:state;
SIGNAL Rac_Pos_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk_racquet : STD_LOGIC;

BEGIN

 CLOCK:	ENTITY work.univ_bin_counter
		GENERIC MAP(N => 24)
		PORT MAP(
					clk		=> clk,
					rst		=> rst,
					ena		=> ena,
					syn_clr	=> '0',
					load		=> '0',
					up			=> '1',
					d			=> "100110001001011010000000",
					max_tick	=>	clk_racquet
					);
	
	PROCESS (rst,clk_racquet)
	BEGIN
		IF (rst='1') THEN
			pr_state <= rest;
		ELSIF (rising_edge(clk_racquet))THEN
				pr_state <= nx_state;
				Rac_Pos <= Rac_Pos_s;
		END IF;
	END PROCESS;
	
PROCESS (up, down, pr_state)
	BEGIN
	CASE pr_state IS
	WHEN rest =>
	   IF(up = '1') THEN
		Rac_Pos_s <= "00000111";
		nx_state <= rest;
      ELSE
      Rac_Pos_s <= "00001110";
		nx_state <= rest;
      END IF;
		
			WHEN Movement_1 =>
				IF (up = '1') THEN
					Rac_Pos_s 	<= "00000111";
					nx_state	<=	rest;
				ELSIF(down = '1') THEN
					Rac_Pos_s	<= "00011100";
					nx_state	<= Movement_2;
				ELSE
					Rac_Pos_s	<=	"00001110";
					nx_state	<=	Movement_1;
				END IF;
				
			WHEN Movement_2	=>
				IF	(up = '1') THEN
					Rac_Pos_s	<=	"00001110";
					nx_state	<=	Movement_1;
				ELSIF	(down = '1') THEN
					Rac_Pos_s	<=	"00111000";
					nx_state	<=	Movement_3;
				ELSE
					Rac_Pos_s	<=	"00011100";
					nx_state	<=	Movement_2;
				END IF;
			
			WHEN Movement_3 =>
				IF	( up = '1') THEN
					Rac_Pos_s	<=	"00011100";
					nx_state	<=	Movement_2;
				ELSIF	(down = '1') THEN
					Rac_Pos_s	<=	"01110000";
					nx_state	<=	Movement_4;
				ELSE
					Rac_Pos_s	<=	"00111000";
					nx_state	<=	Movement_3;
				END IF;
			
			WHEN Movement_4 =>
				IF	(up = '1') THEN
					Rac_Pos_s	<=	"00111000";
					nx_state	<=	Movement_3;
				ELSIF	(down = '1') THEN
					Rac_Pos_s	<=	"11100000";
					nx_state	<=	Movement_5;
				ELSE
					Rac_Pos_s	<=	"01110000";
					nx_state	<=	Movement_4;
				END IF;
			
			WHEN Movement_5 =>
				IF	(up = '1') THEN
					Rac_Pos_s	<=	"01110000";
					nx_state	<=	Movement_4;
				ELSE
					Rac_Pos_s	<=	"11100000";
					nx_state	<=	Movement_5;
				END IF;
			END CASE;
		END PROCESS;
END ARCHITECTURE;



