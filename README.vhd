LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Ball_Movement IS 
 PORT(  clk           :  IN  STD_LOGIC;
        rst           :  IN  STD_LOGIC;
		  ena 			 :  IN  STD_LOGIC;
		  Rac1_Pos      :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		  Rac2_Pos      :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		  Position_Ballx:  OUT INTEGER:=8;
		  Position_Bally:  OUT INTEGER:=4;
		  Goal_1        :  OUT STD_LOGIC:='0';
		  Goal_2        :  OUT STD_LOGIC:='0');
END ENTITY;		  

ARCHITECTURE rtl OF Ball_Movement IS
TYPE state IS(Inicial, Arriba_derecha, Arriba_izquierda, Abajo_izquierda, Abajo_derecha);
SIGNAL pr_state, nx_state:state;
SIGNAL Pos_x                  :  INTEGER;
SIGNAL Pos_y                  :  INTEGER;
SIGNAL clk_ball               :  STD_LOGIC;
SIGNAL Position_Ballx_s 		:	INTEGER;
SIGNAL Position_Bally_s 		:	INTEGER;
SIGNAL Goal_1_s					:	STD_LOGIC;
SIGNAL Goal_2_s					:	STD_LOGIC;
SIGNAL adder_x						:	INTEGER;
SIGNAL adder_y						:	INTEGER;
SIGNAL rest_x						:	INTEGER;
SIGNAL rest_y						:	INTEGER;

BEGIN
 rest_x  <= Position_Ballx_s  -1;
 rest_y  <= Position_Bally_s  -1;
 adder_x <= Position_Ballx_s  +1;
 adder_y <= Position_Bally_s  +1;
 
 clock: ENTITY work.univ_bin_counter
		GENERIC MAP(N		=>	24	)
		PORT MAP(	clk		=>	clk,
						rst		=> rst,
						ena		=>	ena,
						syn_clr	=>	'0',
						load		=>	'0',
						up			=> '1',
						d			=> "100110001001011010000000",
						max_tick	=> clk_ball	);
						
Position_Ballx <= Position_Ballx_s;
Position_Bally <= Position_Bally_s;

PROCESS (rst,clk,clk_ball)
	BEGIN
		IF (rst='1') THEN
			pr_state <= Inicial;
		ELSIF (rising_edge(clk))THEN
			IF(clk_ball = '1') THEN
				IF(ena = '1') THEN
					pr_state <=  nx_state;
					Goal_1 <= Goal_1_s;
					Goal_2 <= Goal_2_s;
					Position_Ballx_s <= Pos_x;
					Position_Bally_s <= Pos_y;
			END IF;
		END IF;
	 END IF;
	END PROCESS;

 PROCESS (pr_state,Position_Ballx_s,Position_Bally_s,Rac1_Pos,Rac2_Pos,adder_x,adder_y,rest_x,rest_y)
  BEGIN	
	CASE pr_state IS
	  WHEN Inicial =>
	    Pos_x <= 9;
		 Pos_y <= 5;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_izquierda;
		 
     WHEN Arriba_izquierda =>
	    IF(Position_Ballx_s = 0) THEN
		   Pos_x <= Position_Ballx_s;
			Pos_y <= Position_Bally_s;
		   Goal_1_s <= '0';
			Goal_2_s <= '1';
			nx_state <= Inicial;
		 ELSIF (Position_Ballx_s = 1) THEN
		  IF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '1') AND (Rac1_Pos(adder_y) = '1')) THEN
		 Pos_x <= adder_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_derecha;
		  ELSIF((Rac1_Pos(Position_Bally_s) = '0') AND (Rac1_Pos(rest_y) = '1') AND (Rac1_Pos(adder_y) = '0')) THEN
	    Pos_x <= adder_x;
		 Pos_y <= adder_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Abajo_derecha;
		  ELSIF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '1') AND (Rac1_Pos(adder_y) = '0')) THEN
		 Pos_x <= adder_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_derecha;
		 ELSE
		 Pos_x <= rest_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_izquierda;
		  END IF;
		 ELSE
		 IF (Position_Bally_s = 0) THEN
		 Pos_x <= rest_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_izquierda;
       ELSE
		 Pos_x <= rest_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_izquierda;
		 END IF;
		 END IF;
	------------------------------------------------------------
		 
	 WHEN Arriba_derecha =>
	   IF(Position_Ballx_s = 15) THEN
		  Pos_x <= Position_Ballx_s;
		  Pos_y <= Position_Bally_s;
		  Goal_1_s <= '1';
		  Goal_2_s <= '0';
		  nx_state <= Inicial;
	  ELSIF(Position_Ballx_s = 14) THEN
	    IF((Rac2_Pos(Position_Bally_s) = '1') AND (Rac2_Pos(rest_y) = '1') AND (Rac2_Pos(adder_y) = '1')) THEN
		 Pos_x <= rest_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_izquierda;
		  ELSIF((Rac2_Pos(Position_Bally_s) = '0') AND (Rac2_Pos(rest_y) = '1') AND (Rac2_Pos(adder_y) = '0')) THEN
	    Pos_x <= rest_x;
		 Pos_y <= adder_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Abajo_izquierda;
		  ELSIF((Rac2_Pos(Position_Bally_s) = '1') AND (Rac2_Pos(rest_y) = '1') AND (Rac2_Pos(adder_y) = '0')) THEN
		 Pos_x <= rest_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_izquierda;
		  ELSE
		 Pos_x <= adder_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_derecha;
		  END IF;
		 ELSE
		 IF (Position_Bally_s = 0) THEN
		 Pos_x <= adder_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_derecha;
		 ELSE
		 Pos_x <= adder_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_derecha;
		 END IF;
		 END IF;
		 --------------------------------------
		 
	WHEN Abajo_izquierda =>
	   IF(Position_Ballx_s = 0) THEN
		   Pos_x <= Position_Ballx_s;
			Pos_y <= Position_Bally_s;
		   Goal_1_s <= '0';
			Goal_2_s <= '1';
			nx_state <= Inicial;
	   ELSIF (Position_Ballx_s = 1) THEN
		  IF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '1') AND (Rac1_Pos(adder_y) = '1')) THEN
		 Pos_x <= adder_x;
		 Pos_y <= adder_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Abajo_derecha;
		  
		  ELSIF((Rac1_Pos(Position_Bally_s) = '0') AND (Rac1_Pos(rest_y) = '0') AND (Rac1_Pos(adder_y) = '1')) THEN
	    Pos_x <= adder_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_derecha;
		  
		  ELSIF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '0') AND (Rac1_Pos(adder_y) = '1')) THEN
		 Pos_x <= adder_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_derecha;
		 ELSE
		 Pos_x <= rest_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_izquierda;
		  END IF;
		 ELSE
		 IF (Position_Bally_s = 7) THEN
		 Pos_x <= rest_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_izquierda;	
		 ELSE
		 Pos_x <= rest_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_izquierda;
		 END IF;
		 END IF;
	------------------------------------------------------------	
		   
	  WHEN Abajo_derecha =>
	   IF(Position_Ballx_s = 15) THEN
		   Pos_x <= Position_Ballx_s;
			Pos_y <= Position_Bally_s;
		   Goal_1_s <= '1';
			Goal_2_s <= '0';
			nx_state <= Inicial;	
	   ELSIF (Position_Ballx_s = 14) THEN
		  IF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '1') AND (Rac1_Pos(adder_y) = '1')) THEN
		 Pos_x <= rest_x;
		 Pos_y <= adder_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Abajo_izquierda;
		  
		  ELSIF((Rac1_Pos(Position_Bally_s) = '0') AND (Rac1_Pos(rest_y) = '0') AND (Rac1_Pos(adder_y) = '1')) THEN
	    Pos_x <= rest_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_izquierda;
		  
		  ELSIF((Rac1_Pos(Position_Bally_s) = '1') AND (Rac1_Pos(rest_y) = '0') AND (Rac1_Pos(adder_y) = '1')) THEN
		 Pos_x <= rest_x;
		 Pos_y <= rest_y; 
		 Goal_1_s <= '0'; 
		 Goal_2_s <= '0'; 
		 nx_state <= Arriba_izquierda;
		 ELSE
		 Pos_x <= adder_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_derecha;
		  END IF;
		 ELSE
		 IF (Position_Bally_s = 7) THEN
		 Pos_x <= adder_x;
		 Pos_y <= rest_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Arriba_derecha;	
		 ELSE
		 Pos_x <= adder_x;
		 Pos_y <= adder_y;
		 Goal_1_s <= '0';
		 Goal_2_s <= '0';
		 nx_state <= Abajo_derecha;
		 END IF;
		 END IF;
	------------------------------------------------------------	 
	    END CASE;
    END PROCESS;
END ARCHITECTURE;  



