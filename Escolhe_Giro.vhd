--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity escolhe_giro is
	generic (
        W : integer := 2 
        --modos do motor 01 vai alternando giro, 10 giro devagar, 00 giro rápido
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
end escolhe_giro;

architecture arch of escolhe_giro is

	signal sel : std_logic_vector (3 downto 0); -- selecao de como girar
    --ordem do vetor (centrifugado, enxaguado, lavado, molhado)

begin
-- sel recebe as entradas
	sel(0) <= R_Molhado;
    sel(1) <= R_Lavado;
    sel(2) <= R_Enxaguado;
    sel(3) <= R_Centrifugado;
    
	acionamento: process(H_Motor, sel) begin
		if RST = '1' then
            F_Motor <= (others => '0'); -- Reseta para "00"
		else
        	case sel is
            	when "0000" => F_Motor <= "01"; -- ta de molho
                when "0001" => F_Motor <= "01"; -- ta lavando
                when "0011" => F_Motor <= "10"; -- ta enxugando
                when "0111" => F_Motor <= "00"; -- ta centrifugando
                when others => F_Motor <= (others => '0');
            end case;
        end if; 
	end process;

end arch;
