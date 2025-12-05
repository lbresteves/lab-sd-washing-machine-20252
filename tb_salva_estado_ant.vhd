--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Juniors

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_estado_salvo is
end;

architecture tb of tb_estado_salvo is

    component estado_salvo is
        port(
            clk           : in  std_logic;
            reset         : in  std_logic;
            S_Tampa       : in  std_logic;
            Estado_Atual  : in  std_logic_vector(3 downto 0);

            A_Lavar       : out std_logic;
            A_Enxaguar    : out std_logic;
            A_Centrifugar : out std_logic;
            A_Molhar      : out std_logic;

            H_Led         : out std_logic;
            H_Controle    : out std_logic;
            H_Motor       : out std_logic;
            H_Apito       : out std_logic;
            H_Encher      : out std_logic;
            H_Esvaziar    : out std_logic;
            H_Sabao       : out std_logic;
            H_Amaciante   : out std_logic;

            T_Iniciar     : out std_logic;
            T_Resetar     : out std_logic;

            Estado_Out    : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal S_Tampa      : std_logic := '1';
    signal Estado_Atual : std_logic_vector(3 downto 0) := "0000";

    signal A_Lavar, A_Enxaguar, A_Centrifugar, A_Molhar : std_logic;
    signal H_Led, H_Controle, H_Motor, H_Apito          : std_logic;
    signal H_Encher, H_Esvaziar, H_Sabao, H_Amaciante   : std_logic;
    signal T_Iniciar, T_Resetar                         : std_logic;
    signal Estado_Out                                   : std_logic_vector(3 downto 0);
    
    constant clk_period : time := 10 ns;

begin

    -- DUT
    dut: estado_salvo
        port map(
            clk           => clk,
            reset         => reset,
            S_Tampa       => S_Tampa,
            Estado_Atual  => Estado_Atual,

            A_Lavar       => A_Lavar,
            A_Enxaguar    => A_Enxaguar,
            A_Centrifugar => A_Centrifugar,
            A_Molhar      => A_Molhar,

            H_Led         => H_Led,
            H_Controle    => H_Controle,
            H_Motor       => H_Motor,
            H_Apito       => H_Apito,
            H_Encher      => H_Encher,
            H_Esvaziar    => H_Esvaziar,
            H_Sabao       => H_Sabao,
            H_Amaciante   => H_Amaciante,

            T_Iniciar     => T_Iniciar,
            T_Resetar     => T_Resetar,

            Estado_Out    => Estado_Out
        );

    -- Clock
    clk_process : process
    begin
    	while now < 400 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus
    stim: process
    begin

        reset <= '1';
        wait for 2 ns;
        reset <= '0';

        -- S0, S1, S2, S3
        Estado_Atual <= "0000"; wait for 2 ns;
        Estado_Atual <= "0001"; wait for 2 ns;
        Estado_Atual <= "0010"; wait for 2 ns;
        Estado_Atual <= "0011"; wait for 2 ns;

        -- Abre tampa (congela)
        S_Tampa <= '0';
        wait for 5 ns;
        Estado_Atual <= "0100";
        wait for 4 ns;

        -- Fecha tampa
        S_Tampa <= '1';
        wait for 2 ns;

        -- S4, S5, S6, S7
        Estado_Atual <= "0100"; wait for 2 ns;
        Estado_Atual <= "0101"; wait for 2 ns;
        Estado_Atual <= "0110"; wait for 2 ns;
        Estado_Atual <= "0111"; wait for 2 ns;

        -- S8
        Estado_Atual <= "1000"; wait for 2 ns;

        -- Abre tampa no final
        S_Tampa <= '0';
        wait for 3 ns;
        Estado_Atual <= "1001"; wait for 2 ns;

        wait;

    end process;

end architecture;
