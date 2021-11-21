LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
---------------------------------------
ENTITY Score IS
	PORT		(	clk		:	IN		STD_LOGIC;
					rst		:	IN		STD_LOGIC;
					Goal_1	:	IN		STD_LOGIC;
					Goal_2	:	IN		STD_LOGIC;
				marcador1	:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
				marcador2	:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;
---------------------------------------
ARCHITECTURE rtl OF Score IS	
	SIGNAL	marcador1_s	  : UNSIGNED(3 DOWNTO 0);
	SIGNAL	marcador2_s	  : UNSIGNED(3 DOWNTO 0);
	SIGNAL	marcador1_next: UNSIGNED(3 DOWNTO 0);
	SIGNAL	marcador2_next: UNSIGNED(3 DOWNTO 0);
	
BEGIN

	--NEXT STATE LOGIC
	marcador1_next	<=		marcador1_s + 1	WHEN (Goal_1 = '1')	ELSE
								marcador1_s;
						
	marcador2_next	<=		marcador2_s + 1	WHEN (Goal_2 = '1')	ELSE
								marcador2_s;
					
	PROCESS(clk,rst)
		VARIABLE	temp1	:	UNSIGNED(3 DOWNTO 0);
		VARIABLE	temp2	:	UNSIGNED(3 DOWNTO 0);
	BEGIN
		IF(rst='1')THEN
			temp1 := "0000";
			temp2 := "0000";
		ELSIF (rising_edge(clk)) THEN
				temp1	:= marcador1_next;
				temp2	:= marcador2_next;
		END IF;
		marcador1	<= STD_LOGIC_VECTOR(temp1);
		marcador1_s	<= temp1;
		marcador2	<= STD_LOGIC_VECTOR(temp2);
		marcador2_s	<= temp2;
	END PROCESS;
END ARCHITECTURE;
