--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity identifica_roupa is
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
end identifica_roupa;


architecture arch of identifica_roupa is
-- componentes
-- mux
component mux4x1 is 
    generic (
        W : integer := 4
    );
    port (
        D0  : in  std_logic_vector(W - 1 downto 0);
        D1  : in  std_logic_vector(W - 1 downto 0);
        D2  : in  std_logic_vector(W - 1 downto 0);
        D3  : in  std_logic_vector(W - 1 downto 0);
        SEL : in  std_logic_vector(1 downto 0);
        Q   : out std_logic_vector(W - 1 downto 0)
    );
end component;
--registrador
component reg_inv is

	generic (
        W : integer := 4  
    );
	port ( 
    	CLK : in std_logic;		-- clock
        RST : in std_logic;		-- reset assincrono ativo em alta
        LD : in std_logic;		-- enable sincrono ativo em alta
        INV : in std_logic_vector(W - 1 downto 0); -- vetor que indica qual posicao inverter
        REG_IN : in std_logic_vector(W - 1 downto 0);  -- entrada
       	REG_OUT : out std_logic_vector(W - 1 downto 0) -- saida
    );   

end component;
--sinais internos
    signal etapas : std_logic_vector(W-1 downto 0); --tradução do que vem do botão
    signal mudancas : std_logic_vector(W-1 downto 0); -- ações que vem da controladora
    signal estados_roupa : std_logic_vector(W-1 downto 0); -- estados da roupa
    
    --entradas do mux 
    --ordem do vetor (centrifugar, enxaguar, lavar, molhar)
    signal d0_s : std_logic_vector(W-1 downto 0) := "0111"; --falta só centrigugar
    signal d1_s : std_logic_vector(W-1 downto 0) := "0011"; --só enxagua e centrifuga
    signal d2_s : std_logic_vector(W-1 downto 0) := "0001"; --lavar sem molho
    signal d3_s : std_logic_vector(W-1 downto 0) := "0000"; --lavar com molho

    
begin
-- atribuição de sinal concorrente
    --mudancas recebe entradas A
	mudancas(0) <= A_Molhar;
    mudancas(1) <= A_Lavar;
    mudancas(2) <= A_Enxaguar;
    mudancas(3) <= A_Centrifugar;
    -- saidas R recebe estados roupa
    R_Molhado <= estados_roupa(0);
    R_Lavado <= estados_roupa(1);
    R_Enxaguado <= estados_roupa(2);
    R_Centrifugado <= estados_roupa(3);
    
-- instanciação de componente
    mux: mux4x1 port map (d0_s, d1_s, d2_s, d3_s, B_TipoRoupa, etapas);
    reg: reg_inv port map(CLK, RST, H_Controle, mudancas, etapas, estados_roupa); 

end arch;