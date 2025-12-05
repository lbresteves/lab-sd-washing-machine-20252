library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is
end entity;

architecture tb of datapath_tb is

    -- Sinais do TB
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';

    signal B_TipoRoupa : std_logic_vector(1 downto 0) := "00";
    signal O_SensorTampa : std_logic := '1';
    signal O_SensorCheio : std_logic := '0';
    signal O_SensorVazio : std_logic := '1';

    signal A_Lavar       : std_logic := '0';
    signal A_Enxaguar    : std_logic := '0';
    signal A_Centrifugar : std_logic := '0';
    signal A_Molhar      : std_logic := '0';

    signal H_Led, H_Controle, H_Motor, H_Apito : std_logic := '0';
    signal H_Encher, H_Esvaziar, H_Sabao, H_Amaciante : std_logic := '0';

    signal T_Iniciar : std_logic := '0';
    signal T_Resetar : std_logic := '0';

    signal Estado_Atual : std_logic_vector(3 downto 0) := "0000";

    -- Saidas
    signal M_Leds : std_logic_vector(3 downto 0);
    signal F_Motor : std_logic_vector(1 downto 0);
    signal F_ValvulaEncher, F_ValvulaEsvaziar : std_logic;
    signal F_GavetaSabao, F_GavetaAmaciante : std_logic;
    signal F_Apito : std_logic;
    signal sseg : std_logic_vector(6 downto 0);

    signal Estado_Anterior : std_logic_vector(3 downto 0);
    signal S_Tampa, S_Cheio, S_Vazio : std_logic;
    signal R_Molhado, R_Lavado, R_Enxaguado, R_Centrifugado : std_logic;
    signal T_Estado : std_logic;

    constant clk_period : time := 20 ns;

begin


    clk_process : process
    begin
        while now < 2000 ns loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;


    uut: entity work.datapath
        port map(
            CLK => clk,
            RST => rst,

            B_TipoRoupa => B_TipoRoupa,
            O_SensorTampa => O_SensorTampa,
            O_SensorCheio => O_SensorCheio,
            O_SensorVazio => O_SensorVazio,

            A_Lavar => A_Lavar,
            A_Enxaguar => A_Enxaguar,
            A_Centrifugar => A_Centrifugar,
            A_Molhar => A_Molhar,

            H_Led => H_Led,
            H_Controle => H_Controle,
            H_Motor => H_Motor,
            H_Apito => H_Apito,

            H_Encher => H_Encher,
            H_Esvaziar => H_Esvaziar,
            H_Sabao => H_Sabao,
            H_Amaciante => H_Amaciante,

            T_Iniciar => T_Iniciar,
            T_Resetar => T_Resetar,
            Estado_Atual => Estado_Atual,

            M_Leds => M_Leds,
            F_Motor => F_Motor,
            F_ValvulaEncher => F_ValvulaEncher,
            F_ValvulaEsvaziar => F_ValvulaEsvaziar,
            F_GavetaSabao => F_GavetaSabao,
            F_GavetaAmaciante => F_GavetaAmaciante,
            F_Apito => F_Apito,
            sseg => sseg,

            Estado_Anterior => Estado_Anterior,
            S_Tampa => S_Tampa,
            S_Cheio => S_Cheio,
            S_Vazio => S_Vazio,

            R_Molhado => R_Molhado,
            R_Lavado => R_Lavado,
            R_Enxaguado => R_Enxaguado,
            R_Centrifugado => R_Centrifugado,

            T_Estado => T_Estado
        );


    stim : process
    begin
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        wait for 40 ns;

        ----------------------------------------------------------------
        -- Muda tipo de roupa
        ----------------------------------------------------------------
        B_TipoRoupa <= "01";
        H_Controle <= '1';  -- habilita modulo identifica_roupa
        A_Molhar   <= '1';
        wait for 80 ns;

        A_Molhar <= '0';
        A_Lavar <= '1';
        wait for 80 ns;

        A_Lavar <= '0';
        A_Enxaguar <= '1';
        wait for 80 ns;

        A_Enxaguar <= '0';
        A_Centrifugar <= '1';
        wait for 80 ns;

        ----------------------------------------------------------------
        -- Testa temporizador
        ----------------------------------------------------------------
        T_Iniciar <= '1';
        wait for 500 ns;
        T_Iniciar <= '0';

        ----------------------------------------------------------------
        -- Simula sensores da maquina
        ----------------------------------------------------------------
        O_SensorCheio <= '1';
        wait for 60 ns;
        O_SensorCheio <= '0';

        O_SensorVazio <= '0';
        wait for 60 ns;
        O_SensorVazio <= '1';

        ----------------------------------------------------------------
        wait;
    end process;

end architecture;
