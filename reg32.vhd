library ieee;
use ieee.std_logic_1164.all;

entity reg32 is
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    load  : in std_logic;
    d     : in std_logic_vector(31 downto 0);
    q	  : out std_logic_vector(31 downto 0)
  );
end reg32;

architecture behavior of reg32 is
begin

  process(clk, rst, d)
  begin
    if (rst =  '1') then
      q <= (q'range => '0');      
	elsif (clk = '1' and clk'event) then
    	if(load = '1') then
        	q <= d;
        end if;
	end if;
  end process;

end behavior;