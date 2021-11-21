
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY Visualization IS
PORT	(	      clk			:	IN		STD_LOGIC;
				   rst			:	IN		STD_LOGIC;
				   ena			:	IN		STD_LOGIC;
			columna_0         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			columna_1         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		   columna_2         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		   columna_3         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			columna_4         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			columna_5         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			columna_6         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			columna_7         :  IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			  Columna         :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
				  Fila         :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE rtl OF Visualization  IS
	TYPE state IS (state0, state1, state2, state3, state4, state5, state6, state7);
	SIGNAL pr_state, nx_state:	state;
	SIGNAL clk_visualization : STD_LOGIC;

BEGIN

clock: ENTITY work.univ_bin_counter
       GENERIC MAP(N  => 16)
	    PORT MAP (
				clk		=>clk,
				rst		=>rst,
				load		=>'0',
				d			=>"1100001101010000",
				ena		=>'1',
				syn_clr	=>'0',
				up			=>'1',
				max_tick	=>clk_visualization);

	PROCESS(rst,clk)
		BEGIN
			IF (rst = '1') THEN
				pr_state	<=	state0;
			ELSIF (rising_edge(clk)) THEN
				IF (clk_visualization = '1' ) THEN
					pr_state	<=	nx_state;
				END IF;
			END IF;
	END PROCESS;
	
	PROCESS(pr_state)
	BEGIN
		CASE pr_state IS
			WHEN state0 => 
			      	Fila        <= columna_0;
	               Columna     <= "10000000";
						nx_state		<=	state1;
			WHEN state1 => 
			      	Fila        <= columna_1;
	               Columna     <= "01000000";
						nx_state		<=	state2;
			WHEN state2 => 
			      	Fila        <= columna_2;
	               Columna     <= "00100000";
						nx_state		<=	state3;
			WHEN state3 => 
			      	Fila        <= columna_3;
	               Columna     <= "00010000";
						nx_state		<= state4;
			WHEN state4 => 
			      	Fila        <= columna_4;
	               Columna     <= "00001000";
						nx_state		<= state5;
			WHEN state5 => 
			      	Fila        <= columna_5;
	               Columna     <= "00000100";
						nx_state		<= state6;
			WHEN state6 => 
			      	Fila        <= columna_6;
	               Columna     <= "00000010";
						nx_state		<= state7;
			WHEN state7 => 
			      	Fila        <= columna_7;
	               Columna     <= "00000001";
						nx_state		<= state0;
		END CASE;
	END PROCESS;
END ARCHITECTURE;
