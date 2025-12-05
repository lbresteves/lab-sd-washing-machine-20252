--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity display is
	port(
        R_Molhado : in std_logic;
        R_Lavado : in std_logic;
        R_Enxaguado : in std_logic;
        R_Centrifugado : in std_logic;
        bcd_in: in std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        leds: out std_logic_vector(3 downto 0)
        );
end display;

architecture rtl of display is
signal inverter : std_logic_vector(6 downto 0);
type state_type is (ST0, ST1, ST2, ST3);
signal LS, NS : state_type;

begin
-- converte a entrada numerica no display de 7 segmentos
    with BCD_IN select
        inverter <= "0000001" when "0000", -- 0
                "1001111" when "0001", -- 1
                "0010010" when "0010", -- 2
                "0000110" when "0011", -- 3
                "1001100" when "0100", -- 4
                "0100100" when "0101", -- 5
                "0100000" when "0110", -- 6
                "0001111" when "0111", -- 7
                "0000000" when "1000", -- 8
                "0000100" when "1001", -- 9
                "0001000" when "1010", -- A
                "1100000" when "1011", -- b
                "0110001" when "1100", -- C
                "1000010" when "1101", -- d
                "0110000" when "1110", -- E
                "0111000" when "1111", -- F
                "1111111" when others; -- turn off all LEDs  
					 
sseg(0) <= inverter(6);
sseg(1) <= inverter(5);
sseg(2) <= inverter(4);
sseg(3) <= inverter(3);
sseg(4) <= inverter(2);
sseg(5) <= inverter(1);
sseg(6) <= inverter(0);
--ascender o led correspondente ao estado
    --ordem do vetor (centrifugado, enxaguado, lavado, molhado)
	leds(0) <= not (R_Molhado or R_Lavado or R_Enxaguado or R_Centrifugado);
    leds(1) <= R_Molhado and not (R_Lavado or R_Enxaguado or R_Centrifugado);
    leds(2) <= R_Molhado and R_Lavado and not (R_Enxaguado or R_Centrifugado);
    leds(3) <= R_Molhado and R_Lavado and R_Enxaguado and not R_Centrifugado;

end rtl;