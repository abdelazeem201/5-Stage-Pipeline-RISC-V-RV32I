library IEEE;
use IEEE.std_logic_1164.all; 
use work.RISCV_package.all;

entity PC is
	port(
		PC_IN	: In	word;			--new program count
		PC_OUT	: Out	word;			--current program count
		EN		: In 	std_logic;	--enable active high
		CLK		: In	std_logic;	--clock
		RST		: In	std_logic	--asynchronous reset active low
	);
end entity PC;

architecture behavioral of PC is

begin
	PC_proc: process(CLK, RST)			
	begin
		if RST='0' then					
			PC_OUT<=X"00400000";			--initialize the PC to the first instruction
		elsif )CLK'event and CLK = '1') then 		--otherwise if there is a positive clock edge
			if EN='1' then				--and enable is active
				PC_OUT <= PC_IN; 		--writes the input on the output
			end if;
	    end if;
	end process;
	
end behavioral;
