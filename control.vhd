library ieee;
use ieee.std_logic_1164.all;

entity control is
  port(
    op		 : in std_logic_vector(5 downto 0);
    clk		 : in std_logic; 
    rst		 : in std_logic; 
    PcWrite  : out std_logic;
    regDst	 : out std_logic;
    branch	 : out std_logic;
    irWrite  : out std_logic;
    cause    : out std_logic;
    memWR	 : out std_logic;                    
    memToReg : out std_logic;
    aluOp	 : out std_logic_vector(1 downto 0); 	 -- when 10 (R-type), 
                                                     --      00 (addi, lw, sw), 
                                                     --      01 (beq, bne), 
                                                     --      xx (j)
    PcSrc	 : out std_logic_vector(1 downto 0);
    regWrite     : out std_logic;					 -- when 1 write, else non-write
    state : out std_logic_vector(3 downto 0);
    aluSrcA: out std_logic;
    aluSrcB: out std_logic_vector(1 downto 0)
    
    --Fazer os sinais da giruas so com o memWrite
    
  );
end control;

architecture behavior of control is

	type FSM is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
    signal current_state, next_state: FSM;

begin
  process(clk, rst)
    begin
      if(rst = '1') then
          current_state <= s0;
          state <= "0000";
      elsif (clk = '1' and clk'event) then
          --debug
      case(next_state) is
          when s0  => state <= "0000";
          when s1  => state <= "0001";
          when s2  => state <= "0010";
          when s3  => state <= "0011";
          when s4  => state <= "0100";
          when s5  => state <= "1001";
          when s6  => state <= "0110";
          when s7  => state <= "0111";
          when s8  => state <= "1000";
          when s9  => state <= "1001";
          when s10 => state <= "1010";
          when s11 => state <= "1011";
          when s12 => state <= "1100";
      end case;
    --
   	current_state <= next_state; --linha bugada que ele mudou
   end if;
  end process;
  
  process(current_state)
  begin
  	case(current_state) is
    	when s0 => 				--fetch
            aluSrcA <= '0';
            aluSrcB <= "01";
            aluOp <= "00";
            PcSrc <= "00";
            irWrite <= '1';
            PcWrite <= '1';
            --
            branch <= '0';
            memWR <= 'X';
            memToReg <= 'X';
            regWrite <= 'X';
            regDst <= 'X';
				cause <= '0';
            --
            	next_state <= s1;
                
        when s1 =>				--decode/register fetch
        	aluSrcA <= '0';
            aluSrcB <= "11";
            aluOp <= "00";
            irWrite <= '0';
            PcWrite <= '0';
            
            case (op) is 	      	-- fazer o next_state baseado nas entradas
            	when "000000" =>
                	next_state <= s6;
                when "100011" | "101011" =>
                	next_state <= s2;
                when "000100" =>
                	next_state <= s8;
                when "001000" =>
                	next_state <= s9;
                when "000010" =>
                	next_state <= s11;
                when others =>
                	next_state <= s12;
            end case;
       when s2 =>
       		aluSrcA <= '1';
            aluSrcB <= "10";
            aluOp <= "00";
				PcWrite <= '0';
				irWrite <= '0';
            if(op = "100011") then 
            	next_state <= s3;
            elsif (op = "101011") then
            	next_state <= s5;
            end if;
       when s3 =>
            	next_state <= s4;
					PcWrite <= '0';
					irWrite <= '0';
       when s4 =>
       		regDst <= '0';
            memToReg <= '1';
            regWrite <= '0';
				PcWrite <= '0';
				irWrite <= '0';
       			next_state <= s0;
       when s5 =>
            memWR <= '1';
				PcWrite <= '0';
				irWrite <= '0';
            	next_state <= s0;
       when s6 =>
       		aluSrcA <= '1';
            aluSrcB <=  "00";
            aluOp <= "10";
				PcWrite <= '0';
				irWrite <= '0';
            	next_state <= s7;
       when s7 =>
       		regDst <= '1';
            memToReg <= '0';
            regWrite <= '1';
				PcWrite <= '0';
				irWrite <= '0';
       			next_state <= s0;
       when s8 => 
       		aluSrcA <= '1';
            aluSrcB <= "00";
            aluOp <= "01";
            PcSrc <= "01";
            branch <= '1';
				PcWrite <= '0';
				irWrite <= '0';
            	next_state <= s0;
       when s9 =>
       		aluSrcA <= '1';
            aluSrcB <= "10";
            aluOp <= "00";
				PcWrite <= '0';
				irWrite <= '0';
       			next_state <= s10;
       when s10 =>
       		regDst <= '0';
            memToReg <= '0';
            regWrite <= '1';
				PcWrite <= '0';
				irWrite <= '0';
       			next_state <= s0;
       when s11 =>
       		PcSrc <= "10";
            PcWrite <= '1';
				irWrite <= '0';
            	next_state <= s0;
       when s12 =>
       		cause <= '1';
    end case;
  end process;
end behavior;