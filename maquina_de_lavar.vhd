--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

--maquina de lavar

library IEEE;
use IEEE.std_logic_1164.all;

entity maquina_de_lavar is
    port(
        CLOCK_50 : in std_logic;
        SW     : in  std_logic_vector(9 downto 0); --interruptores
        KEY  : in  std_logic_vector(1 downto 0); --botões
        LEDR : out std_logic_vector(9 downto 0); --leds
        HEX0 : out std_logic_vector(7 downto 0); --hex mais a direita
        HEX1 : out std_logic_vector(7 downto 0);
        HEX2 : out std_logic_vector(7 downto 0);
        HEX3 : out std_logic_vector(7 downto 0);
        HEX4 : out std_logic_vector(7 downto 0);
        HEX5 : out std_logic_vector(7 downto 0)  --hex mais a esquerda
        
    );
end maquina_de_lavar;

architecture arch of maquina_de_lavar is
 
    --para auxiliar ver o funcionamento na fpga
    component bcd7 is
        port(

            bcd_in: in std_logic_vector(3 downto 0);
            sseg: out std_logic_vector(7 downto 0)

        );
    end component;
	 --para fazer o debouncing dos controles
	 component filtro is
    generic(
        N_CICLOS : integer := 500000      
                                          
    );
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        entrada  : in  std_logic;         
        saida    : out std_logic          
    );
	 end component;
    --component do top level
        --controladora
    component controladora is
        port(
            clk: in std_logic;
            rst: in std_logic;
            
            s_tampa : in std_logic;
            b_inicio : in std_logic;
            s_cheio : in std_logic;
            s_vazio : in std_logic;
            
            t_estado : in std_logic;
            
            r_molhado : in std_logic;
            r_lavado : in std_logic;
            r_enxaguado : in std_logic;
            r_centrifugado : in std_logic;
            
            estado_anterior : in std_logic_vector(3 downto 0);

            A_Molhar : out std_logic;
            A_Lavar : out std_logic;
            A_Enxaguar : out std_logic;
            A_Centrifugar : out std_logic;
            
            h_led : out std_logic;
            h_controle : out std_logic;
            h_motor : out std_logic;
            h_apito : out std_logic;
            
            h_encher : out std_logic;
            h_esvaziar : out std_logic;
            h_sabao : out std_logic;
            h_amaciante : out std_logic;
            t_iniciar : out std_logic;
            t_resetar : out std_logic;
            estado_atual : out std_logic_vector(3 downto 0)
        );
    end component;
        --datapath
    component datapath is
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
    end component;
--fios internos
    --sinais entradas
    signal fio_clk:  std_logic; --entra
    signal fio_rst: std_logic; --entra

    signal fio_b_tiporoupa : std_logic_vector (1 downto 0); --entra
    signal fio_s_tampa :  std_logic; --entra
    signal fio_b_inicio :  std_logic; --entra
    signal fio_s_cheio :  std_logic; --entra
    signal fio_s_vazio :  std_logic; --entra
    --sinais internos
    signal fio_t_estado :  std_logic; --interno

    signal fio_r_molhado :  std_logic; --interno
    signal fio_r_lavado :  std_logic; --interno
    signal fio_r_enxaguado :  std_logic; --interno
    signal fio_r_centrifugado :  std_logic; --interno

    signal fio_estado_anterior :  std_logic_vector(3 downto 0); --interno

    signal fio_A_Molhar :  std_logic; --interno
    signal fio_A_Lavar :  std_logic; --interno
    signal fio_A_Enxaguar :  std_logic; --interno
    signal fio_A_Centrifugar :  std_logic; --interno

    signal fio_h_led :  std_logic; --interno
    signal fio_h_controle :  std_logic; --interno
    signal fio_h_motor :  std_logic; --interno
    signal fio_h_apito :  std_logic; --interno

    signal fio_h_encher :  std_logic; --interno
    signal fio_h_esvaziar :  std_logic; --interno
    signal fio_h_sabao :  std_logic; --interno
    signal fio_h_amaciante :  std_logic; --interno
    signal fio_t_iniciar :  std_logic; --interno
    signal fio_t_resetar :  std_logic; --interno
    signal fio_estado_atual :  std_logic_vector(3 downto 0); --interno
    -- sinais saidas
    signal fio_M_Leds :  std_logic_vector (10 downto 0 ); --sai
    signal fio_F_Motor :  std_logic_vector (1 downto 0); --sai
    signal fio_F_ValvulaEncher :  std_logic; --sai
    signal fio_F_ValvulaEsvaziar :  std_logic; --sai
    signal fio_F_GavetaSabao :  std_logic; --sai
    signal fio_F_GavetaAmaciante :  std_logic; --sai
    signal fio_F_Apito :  std_logic; --sai
    signal fio_sseg:  std_logic_vector(6 downto 0);--tirar
    -- sinais top level
    signal fio_bcd7_estado_atual: std_logic_vector (7 downto 0); --top
    signal fio_traduz_b_tiporoupa: std_logic_vector (3 downto 0); --top
    signal fio_bcd7_b_tiporoupa: std_logic_vector (7 downto 0); --top
    signal fio_traduz_f_motor: std_logic_vector (3 downto 0); --top
    signal fio_bcd7_f_motor:std_logic_vector (7 downto 0); --top

    signal key_prev0 : std_logic := '1';--top
	 signal key_prev1 : std_logic := '1';--top
	 
	 signal fio_sw0 : std_logic;
	 signal fio_sw1 : std_logic;
	 signal fio_sw2 : std_logic;
	 signal fio_sw3 : std_logic;
	 signal fio_sw4 : std_logic;
	 signal fio_sw98 : std_logic_vector(1 downto 0);
	 
    

begin

--instanciar componentes
    --controladora
    control : controladora port map (
        clk =>  fio_clk,
        rst=>fio_rst,
        s_tampa =>  fio_s_tampa ,
        b_inicio=>  fio_b_inicio,
        s_cheio =>  fio_s_cheio ,
        s_vazio =>  fio_s_vazio,
        t_estado =>  fio_t_estado ,
        r_molhado=>  fio_r_molhado,
        r_lavado =>fio_r_lavado ,
        r_enxaguado =>fio_r_enxaguado ,
        r_centrifugado =>  fio_r_centrifugado ,
        estado_anterior =>fio_estado_anterior ,
        A_Molhar=>  fio_A_Molhar,
        A_Lavar =>fio_A_Lavar ,
        A_Enxaguar =>fio_A_Enxaguar ,
        A_Centrifugar =>fio_A_Centrifugar ,
        h_led =>fio_h_led ,
        h_controle =>  fio_h_controle ,
        h_motor =>  fio_h_motor ,
        h_apito =>  fio_h_apito ,
        h_encher => fio_h_encher ,
        h_esvaziar =>  fio_h_esvaziar ,
        h_sabao =>fio_h_sabao ,
        h_amaciante=>  fio_h_amaciante,
        t_iniciar =>  fio_t_iniciar ,
        t_resetar =>fio_t_resetar ,
        estado_atual =>  fio_estado_atual
    );
    --datapath
    fluxo_dados: datapath port map (
        clk =>  fio_clk,
        rst=>fio_rst,
        b_tiporoupa => fio_b_tiporoupa ,
        o_sensortampa =>  fio_s_tampa ,       
        o_sensorcheio =>  fio_s_cheio ,
        o_sensorvazio =>  fio_s_vazio,
        t_estado =>  fio_t_estado ,
        r_molhado=>  fio_r_molhado,
        r_lavado =>fio_r_lavado ,
        r_enxaguado =>fio_r_enxaguado ,
        r_centrifugado =>  fio_r_centrifugado ,
        estado_anterior =>fio_estado_anterior ,
        A_Molhar=>  fio_A_Molhar,
        A_Lavar =>fio_A_Lavar ,
        A_Enxaguar =>fio_A_Enxaguar ,
        A_Centrifugar =>fio_A_Centrifugar ,
        h_led =>fio_h_led ,
        h_controle =>  fio_h_controle ,
        h_motor =>  fio_h_motor ,
        h_apito =>  fio_h_apito ,
        h_encher => fio_h_encher ,
        h_esvaziar =>  fio_h_esvaziar ,
        h_sabao =>fio_h_sabao ,
        h_amaciante=>  fio_h_amaciante,
        t_iniciar =>  fio_t_iniciar ,
        t_resetar =>fio_t_resetar ,
        estado_atual =>  fio_estado_atual ,
        M_Leds =>  fio_M_Leds ,
        F_Motor =>fio_F_Motor ,
        F_ValvulaEncher => fio_F_ValvulaEncher ,
        F_ValvulaEsvaziar =>  fio_F_ValvulaEsvaziar ,
        F_GavetaSabao =>fio_F_GavetaSabao ,
        F_GavetaAmaciante =>  fio_F_GavetaAmaciante ,
        F_Apito =>fio_F_Apito ,
        sseg=> fio_sseg
    );

--conectar as entradas
	--instanciar filtro para cada entrada
	filtroSW0 : filtro port map (fio_clk, fio_rst, SW(0), fio_SW0);
	filtroSW1 : filtro port map (fio_clk, fio_rst, SW(1), fio_SW1);
	filtroSW2 : filtro port map (fio_clk, fio_rst, SW(2), fio_SW2);
	filtroSW3 : filtro port map (fio_clk, fio_rst, SW(3), fio_SW3);
	filtroSW4 : filtro port map (fio_clk, fio_rst, SW(4), fio_SW4);
	filtroSW9 : filtro port map (fio_clk, fio_rst, SW(9), fio_SW98(1));
	filtroSW8 : filtro port map (fio_clk, fio_rst, SW(8), fio_SW98(0));
	
    fio_b_inicio <= fio_SW3;
    fio_s_tampa <= fio_SW0;
    fio_b_tiporoupa <= fio_SW98;
    fio_s_cheio <= fio_SW1;
    fio_s_vazio <= fio_SW2;
    --clock
    fio_clk <= CLOCK_50;
    --reset
    fio_rst <= fio_SW4;
    
--conectar as saidas
    HEX1 <= "11111111"; --displays de 7 segmentos nao usados
    HEX3 <= "11111111"; --displays de 7 segmentos nao usados
    HEX0(6 downto 0) <= fio_M_Leds(6 downto 0); -- tempo
    HEX0(7) <= '1';
    LEDR(3 downto 0) <= fio_M_Leds(10 downto 7); -- estado roupa

    bcd7_HEX5: bcd7 port map (fio_estado_atual, fio_bcd7_estado_atual);-- estado atual
    HEX5 <= fio_bcd7_estado_atual;
        --traduz b_tiporoupa de 2 para 4 bit
    with fio_b_tiporoupa select
                    fio_traduz_b_tiporoupa <= "0000" when "00", --so centrifuga
                                             "0001" when "01", --enxagua e centrifuga
                                             "0010" when "10", --lava, enxagua e centrifuga
                                             "0011" when "11", --molho, lava, enxagua e centrifuga
                                             "1100" when others;
    bcd7_HEX4: bcd7 port map (fio_traduz_b_tiporoupa, fio_bcd7_b_tiporoupa);-- tipo roupa
    HEX4 <= fio_bcd7_b_tiporoupa;
        --traduz b_tiporoupa de 2 para 4 bit
    with fio_f_motor select
                        fio_traduz_f_motor <= "0000" when "00",
                                             "0001" when "01",
                                             "0010" when "10",
                                             "0011" when "11",
                                             "1100" when others;
    bcd7_HEX2: bcd7 port map (fio_traduz_f_motor, fio_bcd7_f_motor);-- giro motor
    HEX2 <= fio_bcd7_f_motor;

    LEDR(9) <= fio_F_ValvulaEncher; --enchendo
    LEDR(8) <= fio_F_ValvulaEsvaziar; --esvaziando
    LEDR(7) <= fio_F_GavetaSabao; --colocando sabao
    LEDR(6) <= fio_F_GavetaAmaciante; --colocando amaciante
    LEDR(5) <= fio_F_Apito; --aptando

	 



end arch;