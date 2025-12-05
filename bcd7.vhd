--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity bcd7 is
	port(

        bcd_in: in std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0)

        );
end bcd7;

architecture rtl of bcd7 is
signal inverter : std_logic_vector(6 downto 0);


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
sseg(7) <= '1';


end rtl;