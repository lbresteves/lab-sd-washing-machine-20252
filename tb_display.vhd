--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;


entity tb_display is
end tb_display;

architecture tb of tb_display is

component display is
	port(
        R_Molhado : in std_logic;
        R_Lavado : in std_logic;
        R_Enxaguado : in std_logic;
        R_Centrifugado : in std_logic;
        bcd_in: in std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        leds: out std_logic_vector(3 downto 0)
        );

end component;

	signal s_BCD_in : std_logic_vector(3 downto 0);
    signal saida_bcd7s : std_logic_vector(6 downto 0);
    signal Roupa_in_s :std_logic_vector(3 downto 0);
    signal saida_leds : std_logic_vector(3 downto 0);
    
    
    constant CLK_PERIOD : time := 20 ns;

begin
	DUT: display port map (
    Roupa_in_s(0),
    Roupa_in_s(1),
    Roupa_in_s(2),
    Roupa_in_s(3),
    s_BCD_in,
    saida_bcd7s,
    saida_leds
    );
-- entrada process    
sinais : process begin		
-- O testbench irá varrer todas as 16 entradas possíveis (0 a 15)
        Roupa_in_s <= "0000";
        s_BCD_in <= "0000"; -- Teste 0
        wait for 10 ns;     -- Espera para vermos o resultado na simulação

        s_BCD_in <= "0001"; -- Teste 1
        wait for 10 ns;

        s_BCD_in <= "0010"; -- Teste 2
        wait for 10 ns;

        s_BCD_in <= "0011"; -- Teste 3
        wait for 10 ns;

        s_BCD_in <= "0100"; -- Teste 4
        wait for 10 ns;

        s_BCD_in <= "0101"; -- Teste 5
        wait for 10 ns;

        s_BCD_in <= "0110"; -- Teste 6
        wait for 10 ns;

        s_BCD_in <= "0111"; -- Teste 7
        wait for 10 ns;

        s_BCD_in <= "1000"; -- Teste 8
        wait for 10 ns;

        s_BCD_in <= "1001"; -- Teste 9
        wait for 10 ns;
        
        -- Teste de entradas inválidas (devem desligar o display)
        
        s_BCD_in <= "1010"; -- Teste 'A'
        wait for 10 ns;

        s_BCD_in <= "1011"; -- Teste 'B'
        wait for 10 ns;

        s_BCD_in <= "1100"; -- Teste 'C'
        wait for 10 ns;

        s_BCD_in <= "1101"; -- Teste 'D'
        wait for 10 ns;

        s_BCD_in <= "1110"; -- Teste 'E'
        wait for 10 ns;

        s_BCD_in <= "1111"; -- Teste 'F'
        wait for 10 ns;
		Roupa_in_s <= "0001";
        wait for 10 ns;
		Roupa_in_s <= "0011";
        wait for 10 ns;
		Roupa_in_s <= "0111";
        wait for 10 ns;
		Roupa_in_s <= "1111";
        
        wait for 10 ns;
        wait; -- Espera indefinidamente
end process sinais;   
    

end architecture tb;