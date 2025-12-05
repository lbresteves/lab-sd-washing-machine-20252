--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Escolhe_Giro is
end tb_Escolhe_Giro;

architecture tb of tb_Escolhe_Giro is

component escolhe_giro is
	generic (
        W : integer := 2 
        --estados do motor 00 desligado, 01 vai alternando giro, 10 giro devagar, 11 giro rápido
    );
	port(
    	RST : in std_logic;
		H_Motor : in std_logic;
        R_Molhado : in std_logic;
        R_Lavado : in std_logic;
        R_Enxaguado : in std_logic;
        R_Centrifugado : in std_logic;
        F_Motor : out std_logic_vector (W-1 downto 0)
    );
    

end component;

--sinais básicos como reset e clock
    signal rst_s : std_logic;
    constant CLK_PERIOD : time := 20 ns;
--sinais especificos
    signal habilitar_s :std_logic;
    signal falar_motor_s : std_logic_vector(1 downto 0);
    signal Roupa_in_s :std_logic_vector(3 downto 0);



begin
	DUT: escolhe_giro port map (
    rst_s,
    habilitar_s, 
    Roupa_in_s(0),
    Roupa_in_s(1),
    Roupa_in_s(2),
    Roupa_in_s(3),
    falar_motor_s
    );

sinais : process begin
    rst_s <= '1';
    habilitar_s <= '0';
    Roupa_in_s <= "0000";
    wait for 15 ns;
    rst_s <= '0';
    habilitar_s <= '0';
    Roupa_in_s <= "0000";
    wait for CLK_PERIOD;
    habilitar_s <= '1';
    Roupa_in_s <= "0000";
    wait for CLK_PERIOD;
    Roupa_in_s <= "0000";
    wait for CLK_PERIOD;
    Roupa_in_s <= "0001";
    wait for CLK_PERIOD;
    Roupa_in_s <= "0011";
    wait for CLK_PERIOD;
    Roupa_in_s <= "0111";
    wait for CLK_PERIOD;
    Roupa_in_s <= "1111";
    wait for CLK_PERIOD;
    wait;
end process;

   
    

end architecture tb;