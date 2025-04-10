library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
  port ( 
    RegA   : in  std_logic_vector (31 downto 0);	
    RegB   : in  std_logic_vector (31 downto 0);
    
    oper   : in  std_logic_vector (2 downto 0);	 -- function
	result : out std_logic_vector (31 downto 0); -- Result  
    zero   : out std_logic     					 -- zero
  );
end alu;

architecture behavior of alu is
begin
  process (RegA, RegB, oper)
  begin
    case oper is
      when "010" => -- add
        Result <= RegA + RegB;
		  zero<='0';
      when "110" => -- sub
        Result<= RegA + (not(RegB)) + 1;
        if ((RegA + (not(RegB)) + 1) = x"00000000") then 
          zero<='1';
        else
          zero<='0';
        end if;
      when "000" => -- and
        Result<= ((RegA) and (RegB));
		  zero<='0';
      when "001" => -- or
        Result<= ((RegA) or (RegB));
		  zero<='0';
      --when "011" => -- jr
        --Result<= RegA;
      when "100" => -- xor
        Result<= ((RegA) xor (RegB));
		  zero<='0';
      when "111" => -- slt 
        if (RegA < RegB) then 
          Result <= x"00000001";
			 zero<='0';
        else 
          Result <= x"00000000";
			 zero<='0';
        end if;
      when others => -- 
        Result <= x"00000000";
		  zero<='0';
    end case;
  end process;
end behavior;