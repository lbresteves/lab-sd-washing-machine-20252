--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controladora_tb is
end;

architecture tb of controladora_tb is

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';

    signal s_tampa  : std_logic := '1';
    signal b_inicio : std_logic := '0';
    signal s_cheio  : std_logic := '0';
    signal s_vazio  : std_logic := '0';

    signal t_estado : std_logic := '0';

    signal r_molhado      : std_logic := '0';
    signal r_lavado       : std_logic := '0';
    signal r_enxaguado    : std_logic := '0';
    signal r_centrifugado : std_logic := '0';

    signal estado_anterior : std_logic_vector(3 downto 0) := (others => '0');

    signal A_Molhar       : std_logic;
    signal A_Lavar        : std_logic;
    signal A_Enxaguar     : std_logic;
    signal A_Centrifugar  : std_logic;

    signal h_led       : std_logic;
    signal h_controle  : std_logic;
    signal h_motor     : std_logic;
    signal h_apito     : std_logic;
    signal h_encher    : std_logic;
    signal h_esvaziar  : std_logic;
    signal h_sabao     : std_logic;
    signal h_amaciante : std_logic;

    signal t_iniciar : std_logic;
    signal t_resetar : std_logic;

    signal estado_atual : std_logic_vector(3 downto 0);

begin

    clk_process : process
      constant clk_period : time := 20 ns;
      begin
          while now < 2000 ns loop
              clk <= '0';
              wait for clk_period / 2;
              clk <= '1';
              wait for clk_period / 2;
          end loop;
          wait;
  end process;

    uut: entity work.controladora
        port map(
            clk => clk,
            rst => rst,
            s_tampa => s_tampa,
            b_inicio => b_inicio,
            s_cheio => s_cheio,
            s_vazio => s_vazio,
            t_estado => t_estado,
            r_molhado => r_molhado,
            r_lavado => r_lavado,
            r_enxaguado => r_enxaguado,
            r_centrifugado => r_centrifugado,
            estado_anterior => estado_anterior,

            A_Molhar => A_Molhar,
            A_Lavar => A_Lavar,
            A_Enxaguar => A_Enxaguar,
            A_Centrifugar => A_Centrifugar,
            h_led => h_led,
            h_controle => h_controle,
            h_motor => h_motor,
            h_apito => h_apito,
            h_encher => h_encher,
            h_esvaziar => h_esvaziar,
            h_sabao => h_sabao,
            h_amaciante => h_amaciante,
            t_iniciar => t_iniciar,
            t_resetar => t_resetar,
            estado_atual => estado_atual
        );


    stim: process
    begin
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 50 ns;

        -- TAMPA FECHADA + BOTAO INICIAR  S1
        b_inicio <= '1';
        wait for 50 ns;
        b_inicio <= '0';

        -- VAI PARA S2 (enchendo)
        wait for 200 ns;
        s_cheio <= '1';
        wait for 40 ns;
        s_cheio <= '0';

        -- SIMULA CICLO DE LAVAR (S3)
        t_estado <= '1';
        wait for 20 ns;
        t_estado <= '0';
        wait for 100 ns;

        -- AVANCA PARA MOTOR (S5)
        r_molhado <= '1';
        wait for 100 ns;

        -- SIMULA CENTRIFUGACAO
        r_centrifugado <= '1';
        wait for 200 ns;

        -- VAI PARA S8 (apito / fim)
        
        t_estado <= '1';
        wait for 50 ns;
        t_estado <= '0';

        -- ABRE A TAMPA NO MEIO (vai para PAUSA S10)
        s_tampa <= '0';
        wait for 100 ns;

        -- FECHA TAMPA (volta ao estado anterior)
        s_tampa <= '1';
        estado_anterior <= "0101"; -- volta para S5
        wait for 150 ns;
        wait;
    end process;

end architecture;
