--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity datapath is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        
        -- Entradas externas
        B_TipoRoupa : in std_logic_vector (1 downto 0);
        O_SensorTampa : in std_logic;
        O_SensorCheio : in std_logic;
        O_SensorVazio : in std_logic;
        
        -- Sinais vindos da controladora
        A_Lavar, A_Enxaguar, A_Centrifugar, A_Molhar : in std_logic;
        H_Led, H_Controle, H_Motor, H_Apito : in std_logic;
        H_Encher, H_Esvaziar, H_Sabao, H_Amaciante : in std_logic;
        T_Iniciar, T_Resetar : in std_logic;
        Estado_Atual : in std_logic_vector (3 downto 0); 
        
        -- Saidas
        M_Leds : out std_logic_vector (10 downto 0 );
        F_Motor : out std_logic_vector (1 downto 0); 
        F_ValvulaEncher, F_ValvulaEsvaziar : out std_logic;
        F_GavetaSabao, F_GavetaAmaciante : out std_logic;
        F_Apito : out std_logic;
        sseg: out std_logic_vector(6 downto 0);
        
        -- Saidas de Status (Adicionadas/Corrigidas)
        Estado_Anterior : out std_logic_vector (3 downto 0); 
        S_Tampa, S_Cheio, S_Vazio : out std_logic;
        R_Molhado, R_Lavado, R_Enxaguado, R_Centrifugado : out std_logic;
        T_Estado : out std_logic 
    );
end datapath;

architecture rtl of datapath is

    -- Componentes
    component identifica_roupa is
        generic ( W : integer := 4 );
        port ( 
            CLK : in std_logic;
            RST : in std_logic;
            B_TipoRoupa : in std_logic_vector(1 downto 0); 
            A_Molhar : in std_logic; 
            A_Lavar : in std_logic;
            A_Enxaguar : in std_logic;
            A_Centrifugar : in std_logic;
            H_Controle : in std_logic;
            R_Molhado : out std_logic;
            R_Lavado : out std_logic;
            R_Enxaguado : out std_logic;
            R_Centrifugado : out std_logic
        );
    end component; 
 
    component escolhe_giro is 
        generic ( W : integer := 2 );
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
    
    component temporizador is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        t_iniciar    : in  std_logic;  -- 1 = conta, 0 = pausa
        t_resetar    : in  std_logic;  -- reseta contador
        estado_atual : in  std_logic_vector(3 downto 0); -- estado atual (entrada de 4 bits)
		  tempo    		: out std_logic_vector(3 downto 0);  -- Tempo atual (0-9 segundos)
        t_estado     : out std_logic  -- vai para '1' ao atingir o valor correspondente       
    );
end component;
 
    -- Sinais Internos
    signal s_R_Molhado, s_R_Lavado, s_R_Enxaguado, s_R_Centrifugado : std_logic;
    signal s_estado_anterior_reg : std_logic_vector(3 downto 0);
    signal temporizador_count : unsigned(15 downto 0) := (others => '0');
    signal tempo_atingido : std_logic := '0'; 
    
    -- Sinais do temporizador
    signal tempo_atual : std_logic_vector (3 downto 0);
    signal sinal : std_logic;    
    signal tempori_sseg : std_logic_vector(6 downto 0);
    signal tempori_leds : std_logic_vector(3 downto 0);
  
    
 
begin
 
    -- Mapeamento de sensores
    S_Tampa <= O_SensorTampa;
    S_Cheio <= O_SensorCheio;
    S_Vazio <= O_SensorVazio;
 
    --Instanciacao identificacao de roupa
    id_roupa: identifica_roupa
        generic map (W => 4)
        port map (
            CLK => CLK,
            RST => RST,
            B_TipoRoupa => B_TipoRoupa,
            A_Molhar => A_Molhar,
            A_Lavar => A_Lavar,
            A_Enxaguar => A_Enxaguar,
            A_Centrifugar => A_Centrifugar,
            H_Controle => H_Controle,
            R_Molhado => s_R_Molhado,
            R_Lavado => s_R_Lavado,
            R_Enxaguado => s_R_Enxaguado,
            R_Centrifugado => s_R_Centrifugado
        );
 
    -- Conexao das saidas de status
    R_Molhado <= s_R_Molhado;
    R_Lavado <= s_R_Lavado;
    R_Enxaguado <= s_R_Enxaguado;
    R_Centrifugado <= s_R_Centrifugado;
 
    -- Instanciacao Controle motor (Escolhe Giro)
    ctrl_motor: escolhe_giro
        generic map (W => 2)
        port map (
            
            RST => RST,
            R_Molhado => s_R_Molhado,
            R_Lavado => s_R_Lavado,
            R_Enxaguado => s_R_Enxaguado,
            R_Centrifugado => s_R_Centrifugado,
            H_Motor => H_Motor,
            F_Motor => F_Motor
        );
 
    -- Instanciação do display
    disp: display
        port map (
            R_Molhado => s_R_Molhado,
            R_Lavado => s_R_Lavado,
            R_Enxaguado => s_R_Enxaguado,
            R_Centrifugado => s_R_Centrifugado,
            BCD_IN => tempo_atual,
            SSEG => tempori_sseg,
            leds => tempori_leds
        );
 
    -- Instanciação Temporizador
    tempori : temporizador
    	port map (
        clk => CLK,
        rst => RST, 
		  t_resetar => t_resetar,
		  estado_atual => Estado_Atual,
		  t_iniciar => t_iniciar,		  
        tempo => tempo_atual,
        t_estado => sinal
        );
        
        
    M_Leds(6 downto 0) <= tempori_sseg;
    M_Leds(10 downto 7) <= tempori_leds;
   
 
    -- Registro do estado anterior
    process(CLK, RST)
    begin
        if RST = '1' then
            s_estado_anterior_reg <= (others => '0');
        elsif rising_edge(CLK) then
            s_estado_anterior_reg <= Estado_Atual;
        end if;
    end process;
 
    Estado_Anterior <= s_estado_anterior_reg;
 
    -- Controle direto das valvulas e atuadores
    F_ValvulaEncher <= H_Encher;
    F_ValvulaEsvaziar <= H_Esvaziar;
    F_GavetaSabao <= H_Sabao;
    F_GavetaAmaciante <= H_Amaciante;
    F_Apito <= H_Apito;
 
	 T_Estado <= sinal;
end rtl;