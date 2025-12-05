--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade para um MUX 4x1 
entity mux4x1 is
    generic (
        W : integer := 4  -- Largura do barramento
    );
    port (
        -- 4 entradas de dados
        D0  : in  std_logic_vector(W - 1 downto 0);
        D1  : in  std_logic_vector(W - 1 downto 0);
        D2  : in  std_logic_vector(W - 1 downto 0);
        D3  : in  std_logic_vector(W - 1 downto 0);
        
        -- 2 bits de seleção
        SEL : in  std_logic_vector(1 downto 0);
        
        -- 1 saída de dados
        Q   : out std_logic_vector(W - 1 downto 0)
    );
end mux4x1;

architecture arch of mux4x1 is
begin
    with SEL select
        Q <= D0 when "00",
             D1 when "01",
             D2 when "10",
             D3 when "11",
             (others => '0') when others;
end arch;