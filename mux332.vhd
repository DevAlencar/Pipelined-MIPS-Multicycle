library ieee ;
use ieee.std_logic_1164.all;

entity mux332 is
  port(	
    d0, d1, d2 : in std_logic_vector(31 downto 0);
	 rst : in std_logic;
    s      	   : in std_logic_vector(1 downto 0);
    y	       : out std_logic_vector(31 downto 0)
  );
end mux332;

architecture behavior of mux332 is
begin
	y <= (y'range => '0') when rst = '1' else
			d0 when s = "00" else
			d1 when s = "01" else
			d2 when s = "10";
end behavior;