library IEEE;
use IEEE.std_logic_1164.all;

entity tb_identifica_roupa is
end tb_identifica_roupa;

architecture tb of tb_identifica_roupa is

component indentifica_roupa is
	generic (
        W : integer := 4  
    );
	port ( 
    	CLK : in std_logic;
        RST : in std_logic;
    	B_TipoRoupa : in std_logic_vector(1 downto 0); 
        -- 01 ciclo rápido, 10 ciclo normal,  11 ciclo longo
        A_Molhar : in std_logic; 
        A_Lavar : in std_logic;
        A_Enxaguar : in std_logic;
        A_Centrifugar : in std_logic;
        -- um enable para poder receber o 
        H_Controle : in std_logic;
        -- indica as etapas que foi feito em nivel alto
        R_Molhado : out std_logic;
        R_Lavado : out std_logic;
        R_Enxaguado : out std_logic;
        R_Centrifugado : out std_logic
    );
    

end component;

--sinais básicos como reset e clock
    signal rst_s : std_logic;
    signal clk_s : std_logic;
    constant CLK_PERIOD : time := 20 ns;
--sinais especificos
    signal h_controle_s :std_logic;
    signal Botao_s : std_logic_vector(1 downto 0);
    signal Acoes_s : std_logic_vector(3 downto 0);
    signal Roupa_in_s :std_logic_vector(3 downto 0);



begin
	DUT: indentifica_roupa port map (
    clk_s, 
    rst_s,
    Botao_s, 
    Acoes_s(0),
    Acoes_s(1),
    Acoes_s(2),
    Acoes_s(3),
    h_controle_s,
    Roupa_in_s(0),
    Roupa_in_s(1),
    Roupa_in_s(2),
    Roupa_in_s(3)
    );

sinais : process begin
    rst_s <= '1';
    Botao_s <= "11";
    Acoes_s <= "0000";
    h_controle_s <= '0';

    wait for 15 ns;
    rst_s <= '0';
    Botao_s <= "11";
    Acoes_s <= "0000";
    h_controle_s <= '0';

    wait for CLK_PERIOD;
    Acoes_s <= "0000";
    h_controle_s <= '1';

    wait for CLK_PERIOD;
    Acoes_s <= "0000";
    h_controle_s <= '0';

    wait for CLK_PERIOD;
    Acoes_s <= "0001";
    wait for CLK_PERIOD;
    Acoes_s <= "0011";
    wait for CLK_PERIOD;
    Acoes_s <= "0111";
    wait for CLK_PERIOD;
    Acoes_s <= "1111";
    wait for CLK_PERIOD;
    wait;
end process;

-- Clock process
clk_process :process begin
	while now < 400 ns loop -- simula 20 ciclos de clock
       clk_s <= '0';
       wait for CLK_PERIOD / 2;
       clk_s <= '1';
       wait for CLK_PERIOD / 2;
    end loop;
    wait; -- End simulation
   
end process;    
    

end architecture tb;