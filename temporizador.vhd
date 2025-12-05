--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity temporizador is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        t_iniciar    : in  std_logic;  -- 1 = conta, 0 = pausa
        t_resetar    : in  std_logic;  -- reseta contador
        estado_atual : in  std_logic_vector(3 downto 0); -- estado atual (entrada de 4 bits)
		  tempo    		: out std_logic_vector(3 downto 0);  -- Tempo atual (0-9 segundos)
        t_estado     : out std_logic  -- vai para '1' ao atingir o valor correspondente
    );
end entity;

architecture arch of temporizador is

    signal div_cnt  : unsigned(31 downto 0) := (others => '0');
    signal tick_1s  : std_logic := '0';
    signal contador : unsigned(3 downto 0) := (others => '0');
    signal tempo_objetivo : unsigned(3 downto 0);  -- valor objetivo variável com base em estado_atual
	 signal acabou : std_logic := '0';

begin

    --------------------------------------------------------------------
    -- Gerador de pulso de 1 Hz
    --------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            div_cnt <= (others => '0');
            tick_1s <= '0';
        elsif rising_edge(clk) then
            if div_cnt = 49999999 then
                div_cnt <= (others => '0');
                tick_1s <= '1';
            else
                div_cnt <= div_cnt + 1;
                tick_1s <= '0';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Determinação do valor objetivo do contador com base em estado_atual
    --------------------------------------------------------------------
    process(estado_atual)
    begin
        -- Determina o valor objetivo (tempo alvo) dependendo do estado_atual
        case estado_atual is
            when "0011" =>  -- estado_atual = 3
                tempo_objetivo <= "0010";  -- 2 segundos
            when "0100" =>  -- estado_atual = 4
                tempo_objetivo <= "1001";  -- 9 segundos
            when "0101" =>  -- estado_atual = 5
                tempo_objetivo <= "1001";  -- 9 segundos
            when "0111" =>  -- estado_atual = 7
                tempo_objetivo <= "0010";  -- 2 segundos
            when "1000" =>  -- estado_atual = 8
                tempo_objetivo <= "0010";  -- 2 segundos
            when others =>  -- Para outros valores de estado_atual, não há contagem (desabilita t_estado)
                tempo_objetivo <= "0000";  -- Nenhum tempo válido
        end case;
    end process;

    --------------------------------------------------------------------
    -- Contador de 0 a 9, com iniciar/pausar e reset
    --------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            contador <= (others => '0');
				acabou <= '0';
        elsif rising_edge(clk) then

            if t_resetar = '1' then
                contador <= (others => '0');
					 acabou <= '0';

            elsif tick_1s = '1' and t_iniciar = '1' then
                -- só conta se t_iniciar = '1'
                if contador < tempo_objetivo then
                    contador <= contador + 1;
					 else
						  acabou <= '1';
                end if;
            end if;

        end if;
    end process;

    --------------------------------------------------------------------
    -- Saída: vai para '1' quando o contador atingir o valor objetivo
    --------------------------------------------------------------------
    t_estado <= acabou;
	 tempo <= std_logic_vector(contador);  -- Mostra o tempo atual (0-9)

end architecture;
