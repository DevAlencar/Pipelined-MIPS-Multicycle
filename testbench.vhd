library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end entity testbench;

architecture behavior of testbench is
	signal wire_clock, ERROR, wireCause, wire_reset: std_logic;
	constant clock_period: time := 10 ns;
	
    begin
  		PROCESSOR: entity work.design port map(
  			clk => wire_clock,
        	rst => wire_reset,
            causeOut => wireCause
        );
        
        CLOCKGENERATOR: process
          begin
          for i in 0 to 30 loop
            wire_clock <= '0';
            wait for clock_period/2;
            wire_clock <= '1';
            wait for clock_period/2;
            
            if(wireCause = '1') then
            	ERROR <= '1';
            	exit;
            end if;
            
          end loop;
          wait;
        end process;
         
		process
        	begin
            	wire_reset <= '1';
                wait for 10 ns;
                wire_reset <= '0';
                wait for 10 ns;
                wait;
        end process;
end behavior;