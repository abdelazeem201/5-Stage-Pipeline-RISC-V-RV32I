library IEEE;
use IEEE.std_logic_1164.all; 

entity reg is
	generic (N: positive:= 15);					--number of bits
	port(	D	: In	std_logic_vector(N-1 downto 0);		--data input
		Q	: Out	std_logic_vector(N-1 downto 0);		--data output
		EN	: In 	std_logic;				--enable active high
		CLK	: In	std_logic;				--clock
		RST	: In	std_logic				--asynchronous reset active low
	);
end entity reg;

architecture behavioral of reg is	--register with asyncronous reset and enable

begin
	reg_proc: process(CLK, RST)		
	begin
		if (RST='0') then				
			Q<=(others=>'0');			
		elsif (CLK'event and CLK ='1') then 			
			if EN='1' then					
				Q <= D; 			
			end if;
	    end if;
	end process;
	
end behavioral;
