LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PONG IS
	PORT (	clk		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				up_J1   	:	IN		STD_LOGIC;
				up_J2	   :	IN		STD_LOGIC;
				down_J1	:	IN		STD_LOGIC;
				down_J2	:	IN		STD_LOGIC;
			   score1   :	OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
			   score2   :	OUT	STD_LOGIC_VECTOR(6 DOWNTO 0);
    Columnas_matriz1 :	OUT	STD_LOGIC_VECTOR(7  DOWNTO 0);
	  Columnas_matriz2:	OUT	STD_LOGIC_VECTOR(7  DOWNTO 0);
		Filas_matriz1	:	OUT	STD_LOGIC_VECTOR(7  DOWNTO 0);
		Filas_matriz2	:	OUT	STD_LOGIC_VECTOR(7  DOWNTO 0));
END ENTITY;
-------------------------------------------------------------------------------------
ARCHITECTURE rtl OF PONG IS
	TYPE Tablero IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL juego,ZEROS,game	:Tablero;
	SIGNAL Rac1_Pos			:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Rac2_Pos			:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Position_Ballx   :	INTEGER;
	SIGNAL Position_Bally   :	INTEGER;
	SIGNAL Goal_1				:	STD_LOGIC;
	SIGNAL Goal_2				:	STD_LOGIC;
	SIGNAL marcador1_bin    :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL marcador2_bin    :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL clk_tablero		:	STD_LOGIC;
	SIGNAL tick_speed       :  STD_LOGIC;

	TYPE state IS (Initial, Desarrollo);
	SIGNAL pr_state, nx_state: state;
-------------------------------------------------------------------------------------
BEGIN

	
	BALL:ENTITY work.Ball_Movement
	PORT MAP(	clk 		=> clk,
					ena 		=> ena,
					rst 		=> rst,
					Goal_1	=>	Goal_1,
					Goal_2	=> Goal_2,
					Rac1_Pos => Rac1_Pos,
					Rac2_Pos => Rac2_Pos,
			Position_Ballx => Position_Ballx,
			Position_Bally => Position_Bally);
		
	
	
	timer_fps: ENTITY work.univ_bin_counter
		GENERIC MAP(	N		=>	18	)
		PORT MAP(	clk		=>	clk,
						rst		=> rst,
						ena		=>	ena,
						syn_clr	=>	'0',
						load		=>	'0',
						up			=> '1',
						d			=> "100100100111110000",
						max_tick	=> clk_tablero	);

	
	
	Matriz_1: ENTITY work.Visualization
		PORT MAP(	clk		    =>	clk,
						ena		    =>	ena,
						rst		    =>	rst,
				      columna_0    =>	juego(0),
						columna_1    =>	juego(1),
						columna_2    =>	juego(2),
						columna_3    =>	juego(3),
						columna_4    =>	juego(4),
						columna_5    =>	juego(5),
						columna_6    =>	juego(6),
						columna_7    =>	juego(7),
						Columna      =>	Columnas_matriz1,
						Fila         =>	Filas_matriz1);
	
	
	Matriz_2: ENTITY work.Visualization
		PORT MAP(	clk		    =>	clk,
						ena		    =>	ena,
						rst		    =>   rst,
						columna_0    =>	juego(8),
						columna_1    =>	juego(9),
						columna_2    =>	juego(10),
						columna_3    =>	juego(11),
						columna_4    =>	juego(12),
						columna_5    =>	juego(13),
						columna_6    =>	juego(14),
						columna_7    =>	juego(15),
						Columna      =>	Columnas_matriz2,
						Fila         =>	Filas_matriz2);
	
	
	
	Racquet1: ENTITY work.Racquets_Movement1
		PORT MAP (	clk		=>	clk,
						rst		=>	rst,
						ena      => ena,
						up       => up_J1,
						down     => down_J1,
						Rac_Pos  => Rac1_Pos);
						
	
	
	Racquet2: ENTITY work.Racquets_Movement1
		PORT MAP (	clk		=>	clk,
						rst		=>	rst,
						ena      => ena,
						up       => up_J2,
						down     => down_J2,
						Rac_Pos  => Rac2_Pos);
	
	
   Score:    ENTITY work.Score
	PORT MAP (		clk		=>	clk,
						rst		=>	rst,
						Goal_1	=> Goal_1,
						Goal_2   => Goal_2,
					marcador1   => marcador1_bin,
				   marcador2   => marcador2_bin);	
						
	
	
	bin_to_sseg_1: ENTITY work.bin_to_sseg
	PORT MAP (		bin  => marcador1_bin,
						sseg => score1);
						
	
	
	bin_to_sseg_2: ENTITY work.bin_to_sseg
	PORT MAP (		bin  => marcador2_bin,
						sseg => score2);				
						
		
		timer_for_speed: ENTITY work.univ_bin_counter
	GENERIC MAP(	N 			=> 28)
	PORT MAP (		clk		=>	clk,
						rst		=>	rst,
						ena		=>	ena,
						syn_clr	=>	'0',
						load		=>	'0',
						d			=> "0101111101011110000100000000",
						max_tick => tick_speed);

ZEROS	<=( 
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000");		
		
		
		PROCESS(rst,ena,clk,clk_tablero,ZEROS)
			BEGIN
				IF(rst='1') THEN
					juego <= ZEROS;
				ELSIF(rising_edge(clk)) THEN
					IF(clk_tablero = '1') THEN
						pr_state <= nx_state;
						juego <= game;
					END IF;
				END IF;
			END PROCESS;

	
	PROCESS (pr_state,Rac1_Pos,Rac2_Pos,juego,Position_Ballx,Position_Bally,ZEROS)
		BEGIN
			CASE pr_state IS
				WHEN Initial =>
					game <= ZEROS;
					nx_state<= Desarrollo;
				WHEN Desarrollo =>
					game <=(OTHERS => "00000000");
					game(0) <=  Rac1_Pos;
					game(15)<=  Rac2_Pos;
					game(Position_Ballx)(Position_Bally) <= '1';
					nx_state <= Initial;
			END CASE;
		END PROCESS;		


END ARCHITECTURE;
