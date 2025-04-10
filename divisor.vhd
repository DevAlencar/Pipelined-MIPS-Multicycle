library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor is
    Generic (
        DIVISOR : integer := 50000000  -- Define o valor do divisor para dividir a frequência do clock
    );
    Port (
        clk_in  : in  STD_LOGIC;       -- Clock de entrada
        rst     : in  STD_LOGIC;       -- Reset
        clk_out : out STD_LOGIC        -- Clock de saída dividido
    );
end divisor;

architecture Behavioral of divisor is
    signal counter : integer := 0;       -- Contador para o divisor
    signal clk_div : STD_LOGIC := '0';   -- Sinal interno do clock dividido
begin
    process (clk_in, rst)
    begin
        if rst = '1' then                 -- Verifica se o reset está ativo
            counter <= 0;                 -- Reinicia o contador
            clk_div <= '0';               -- Reinicia o clock dividido
        elsif (clk_in = '1' and clk_in'event) then    -- Detecta a borda de subida do clock
            if counter = (DIVISOR / 2 - 1) then
                clk_div <= not clk_div;   -- Inverte o clock de saída
                counter <= 0;             -- Reinicia o contador
            else
                counter <= counter + 1;   -- Incrementa o contador
            end if;
        end if;
    end process;

    clk_out <= clk_div;                  -- Atribui o clock dividido à saída
end Behavioral;