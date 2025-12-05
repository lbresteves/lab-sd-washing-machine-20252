--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_temporizador is
end tb_temporizador;

architecture sim of tb_temporizador is

    signal clk_tb          : std_logic := '0';
    signal rst_tb          : std_logic := '0';
    signal t_iniciar_tb    : std_logic := '0';
    signal t_resetar_tb    : std_logic := '0';
    signal estado_atual_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal t_estado_tb     : std_logic;

    constant clk_period : time := 10 ns;

begin

    UUT : entity work.temporizador
        generic map(
            FREQ_HZ => 1,   -- 1 ciclo = 1 segundo simulado
            W_CONT  => 8
        )
        port map(
            clk          => clk_tb,
            rst          => rst_tb,
            t_iniciar    => t_iniciar_tb,
            t_resetar    => t_resetar_tb,
            estado_atual => estado_atual_tb,
            t_estado     => t_estado_tb
        );


    clk_process : process
    begin
        while now < 500 ns loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;


    stim_proc : process
    begin
        -- reset
        rst_tb <= '1';
        wait for 20 ns;
        rst_tb <= '0';

        -- TESTE 1: estado 0000 (tempo alvo = 5)
        estado_atual_tb <= "0000";
        t_iniciar_tb <= '1';

        wait for 200 ns; -- tempo suficiente para chegar no alvo

        t_iniciar_tb <= '0';

        -- TESTE 2: reset
        t_resetar_tb <= '1';
        wait for 20 ns;
        t_resetar_tb <= '0';

        -- estado 0011 (tempo alvo = 4)
        estado_atual_tb <= "0011";
        t_iniciar_tb <= '1';

        wait for 150 ns;

        t_iniciar_tb <= '0';

        wait;
    end process;

end architecture;
