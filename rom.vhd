--------------------------------------------------------------------
-- A simple 256x8 RAM memory													--
--	myCPU																				--
-- Prof. Max Santana																--
--------------------------------------------------------------------

package ram_constants is
	constant DATA_WIDTH : INTEGER := 8;
	constant ADDR_WIDTH : INTEGER := 8;
	constant INIT_FILE  : STRING  := "instrucoes1.mif";
end ram_constants;

library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

library lpm;
use lpm.lpm_components.all;

library work;
use work.ram_constants.all;

entity rom is
  generic(	
    DATA_WIDTH		: integer := 8;
	 ADDR_WIDTH	: integer := 8;
	 DEPTH			: integer := 256
  );
  port(	
    address		: in std_logic_vector(31 downto 0);
    clock 		: in std_logic;
    wr 			: in std_logic;    
    data_in		: in std_logic_vector(31 downto 0);
	 data_out	: out std_logic_vector(31 downto 0)
);
end rom;

architecture behv of rom is

    signal add			: bit_vector(7 downto 0);
    signal addS0		: STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	signal addS1		: STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	signal addS2		: STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	signal addS3		: STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
    signal dataoutS		: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal datainS		: STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal dataoutS0	: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal dataoutS1	: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal dataoutS2	: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal dataoutS3	: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal datainS0		: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal datainS1		: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	signal datainS2		: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
    signal datainS3		: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	signal wrS			: STD_LOGIC;
	signal clockS		: STD_LOGIC;
    signal add0			: integer;
	signal add2			: integer;
	signal add1			: integer;
	signal add3			: integer;
    signal addu			: unsigned(7 downto 0);

BEGIN

---- Usa apenas 8 bits menos significativos do endereço
     add <= To_BitVector(Address(7 downto 0));
--
-- Conversão de bit-vector em inteiro
     addu(0) <= To_StdULogic(Add(0));
     addu(1) <= To_StdULogic(Add(1));
     addu(2) <= To_StdULogic(Add(2));
     addu(3) <= To_StdULogic(Add(3));
     addu(4) <= To_StdULogic(Add(4));
     addu(5) <= To_StdULogic(Add(5));
     addu(6) <= To_StdULogic(Add(6));
     addu(7) <= To_StdULogic(Add(7));

-- Cálculo dos 4 endereços (inteiros) a serem lidos devido ao endereçamento por byte      
      add1 <= add0 + 1;
      add2 <= add0 + 2;
      add3 <= add0 + 3;
      add0 <= CONV_INTEGER(addu);

-- Conversão dos endereços no formato STD_LOGIC_VECTOR
	  addS0 <= CONV_STD_LOGIC_VECTOR(add0, 8);
      addS1 <= CONV_STD_LOGIC_VECTOR(add1, 8);
      addS2 <= CONV_STD_LOGIC_VECTOR(add2, 8);
      addS3 <= CONV_STD_LOGIC_VECTOR(add3, 8);
	
	-- Conversão do dado (entrada) no formato STD_LOGIC_VECTOR
    datainS <= data_in;

	wrS <= wr;

	clockS <= clock;

	-- Conversão de dado (saída) para bit_vector
	data_out <= dataoutS;

-- Distribuição dos vetores de dados para os bancos de memória      
    datainS0 <= datainS(31 downto 24);
    datainS1 <= datainS(23 downto 16);
    datainS2 <= datainS(15 downto 8);
    datainS3 <= datainS(7 downto 0);
	
	dataoutS(31 downto 24) <= dataoutS0; 
  	dataoutS(23 downto 16) <= dataoutS1;
    dataoutS(15 downto 8) <= dataoutS2;
    dataoutS(7 downto 0) <= dataoutS3;
	

-- Bancos de memórias (cada banco possui 256 bytes)
	MEM: lpm_ram_dq
	GENERIC MAP (lpm_widthad => ADDR_WIDTH, lpm_width => DATA_WIDTH, lpm_file => INIT_FILE)
	PORT MAP (data => datainS0, Address => addS3, we => wrS, inclock => clockS, outclock => clockS, q => dataoutS0);

	MEM_plus_One: lpm_ram_dq
	GENERIC MAP (lpm_widthad => ADDR_WIDTH, lpm_width => DATA_WIDTH, lpm_file => INIT_FILE)
	PORT MAP (data => datainS1, Address => addS2, we => wrS, inclock => clockS, outclock => clockS, q => dataoutS1);

	MEM_plus_Two: lpm_ram_dq
	GENERIC MAP (lpm_widthad => ADDR_WIDTH, lpm_width => DATA_WIDTH, lpm_file => INIT_FILE)
	PORT MAP (data => datainS2, Address => addS1, we => wrS, inclock => clockS, outclock => clockS, q => dataoutS2);

   MEM_plus_Three: lpm_ram_dq
	GENERIC MAP (lpm_widthad => ADDR_WIDTH, lpm_width => DATA_WIDTH, lpm_file => INIT_FILE)
	PORT MAP (data => datainS3, Address => addS0, we => wrS, inclock => clockS, outclock => clockS, q => dataoutS3);


end behv;