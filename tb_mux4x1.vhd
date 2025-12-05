--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Juniors

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_MUX_4x1 is
    
end tb_MUX_4x1;


architecture Behavioral of tb_MUX_4x1 is

    
    component mux4x1
        generic (
        W : integer := 4  
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
    end component;

    
    -- Entradas
    signal s_D0  : std_logic_vector(3 downto 0);
    signal s_D1  : std_logic_vector(3 downto 0);
    signal s_D2  : std_logic_vector(3 downto 0);
    signal s_D3  : std_logic_vector(3 downto 0);
    signal s_SEL : std_logic_vector(1 downto 0);
    
    -- Saída
    signal s_Q   : std_logic_vector(3 downto 0);

begin

    
    DUT: mux4x1 port map (s_D0, s_D1, s_D2, s_D3, s_SEL, s_Q);

    
    stimulus_process : process
    begin
        -- Estado inicial
        s_D0 <= "0000";
        s_D1 <= "0001";
        s_D2 <= "0010";
        s_D3 <= "0011";
        s_SEL <= "00";
        wait for 10 ns; -- Espera 10 ns. s_Q deve se tornar '1' (valor de D0)

        -- Teste 1: Seleciona D1
        s_SEL <= "01";
        wait for 10 ns; -- s_Q deve se tornar '0' (valor de D1)

        -- Teste 2: Seleciona D2
        s_SEL <= "10";
        wait for 10 ns; -- s_Q deve se tornar '1' (valor de D2)

        -- Teste 3: Seleciona D3
        s_SEL <= "11";
        wait for 10 ns; -- s_Q deve se tornar '0' (valor de D3)

        -- Fim da simulação
        wait; 
    end process;

end Behavioral;