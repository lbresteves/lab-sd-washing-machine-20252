--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity estado_salvo is
    port(
        clk   : in std_logic;
        reset : in std_logic;

        -- 1 = Tampa fechada / 0 = aberta
        S_Tampa     : in std_logic;

        -- Estado vindo da FSM principal
        Estado_Atual : in std_logic_vector(3 downto 0);

        -- Saidas da máquina
        A_Lavar      : out std_logic;
        A_Enxaguar   : out std_logic;
        A_Centrifugar: out std_logic;
        A_Molhar     : out std_logic;

        H_Led        : out std_logic;
        H_Controle   : out std_logic;
        H_Motor      : out std_logic;
        H_Apito      : out std_logic;
        H_Encher     : out std_logic;
        H_Esvaziar   : out std_logic;
        H_Sabao      : out std_logic;
        H_Amaciante  : out std_logic;

        T_Iniciar    : out std_logic;
        T_Resetar    : out std_logic;

        Estado_Out   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of estado_salvo is

    -- Registrador que guarda o estado anterior
    signal estado_ant : std_logic_vector(3 downto 0);

    -- Estado efetivamente usado (atual ou anterior)
    signal estado_sel : std_logic_vector(3 downto 0);

begin

    -- REGISTRADOR DO ESTADO ANTERIOR

    process(clk, reset)
    begin
        if reset = '1' then
            estado_ant <= "0000";   
        elsif rising_edge(clk) then
            if S_Tampa = '1' then  
                estado_ant <= Estado_Atual;
            end if;               
        end if;
    end process;



    -- Selecao do estado efetivo

    estado_sel <= Estado_Atual when S_Tampa = '1'
                  else estado_ant;


    -- SAiDAS

    -- A_Lavar
    with estado_sel select
        A_Lavar <= '1' when "0011",     -- S3
                    '0' when others;

    -- A_Enxaguar
    with estado_sel select
        A_Enxaguar <= '1' when "0111",  -- S7
                       '0' when others;

    -- A_Centrifugar
    with estado_sel select
        A_Centrifugar <= '1' when "0110", -- S6
                          '0' when others;

    -- A_Molhar
    with estado_sel select
        A_Molhar <= '1' when "0100",  -- S4
                      '0' when others;

    -- H_Led
    with estado_sel select
        H_Led <= '0' when "0000",      -- S0
                 '1' when others;

    -- H_Controle
    with estado_sel select
        H_Controle <= '1' when "0001",  -- S1
                       '0' when others;

    -- H_Motor
    with estado_sel select
        H_Motor <= '1' when "0101",  -- S5
                    '0' when others;

    -- H_Apito
    with estado_sel select
        H_Apito <= '1' when "1000",  -- S8
                    '0' when others;

    -- H_Encher
    with estado_sel select
        H_Encher <= '1' when "0010", -- S2
                     '0' when others;

    -- H_Esvaziar
    with estado_sel select
        H_Esvaziar <= '1' when "0110", -- S6
                        '0' when others;

    -- H_Sabao
    with estado_sel select
        H_Sabao <= '1' when "0011",  -- S3
                    '0' when others;

    -- H_Amaciante
    with estado_sel select
        H_Amaciante <= '1' when "0111", -- S7
                        '0' when others;

    -- T_Iniciar
    with estado_sel select
        T_Iniciar <= '1' when "0011" | "0111", -- S3, S7
                      '0' when others;

    -- T_Resetar
    with estado_sel select
        T_Resetar <= '1' when "0000" | "0001" | "0010" | "0101" | "0110" | "1001",
                      '0' when others;

    Estado_Out <= estado_sel;

end architecture;
