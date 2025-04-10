library ieee;
use ieee.std_logic_1164.all;

entity iReg is
  port(
    clk, rst   	 : in std_logic;
    load  	 : in std_logic; --IRWrite
    inst     : in std_logic_vector(31 downto 0);
    op	  	 : out std_logic_vector(5 downto 0);
    addr	 : out std_logic_vector(25 downto 0);
    rs	  	 : out std_logic_vector(4 downto 0);
    rt	  	 : out std_logic_vector(4 downto 0);
    rd	  	 : out std_logic_vector(4 downto 0);
    imm	  	 : out std_logic_vector(15 downto 0);
    funct	 : out std_logic_vector(5 downto 0)
  );
end iReg;

architecture behavior of iReg is
begin

  process(clk, inst, rst)
  begin
	if(rst = '1') then
		op		<= (op'range => '0');
        addr	<= (addr'range => '0');
   		rs	  	<= (rs'range => '0');
    	rt	  	<= (rt'range => '0');
    	rd	  	<= (rd'range => '0');
    	imm	  	<= (imm'range => '0');
        funct	<= (funct'range => '0');
    elsif (clk = '1' and clk'event) then
      if(load = '1') then
      	op		<= inst(31 downto 26);
        addr	<= inst(25 downto 0);
   		rs	  	<= inst(25 downto 21);
    	rt	  	<= inst(20 downto 16);
    	rd	  	<= inst(15 downto 11);
    	imm	  	<= inst(15 downto 0);
        funct	<= inst(5 downto 0);
      end if;
	end if;
   
  end process;

end behavior;