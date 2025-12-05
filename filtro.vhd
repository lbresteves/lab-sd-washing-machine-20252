--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filtro is
    generic(
        N_CICLOS : integer := 500000      -- número de ciclos para validar
                                           
    );
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        entrada  : in  std_logic;          -- sinal ruidoso (do botão)
        saida    : out std_logic           -- sinal filtrado
    );
end entity filtro;

architecture rtl of filtro is

    signal entrada_sync  : std_logic := '0';
    signal entrada_ant   : std_logic := '0';
    signal contador      : unsigned(31 downto 0) := (others => '0');
    signal saida_reg     : std_logic := '0';

begin

    -- sincronização da entrada 
    process(clk)
    begin
        if rising_edge(clk) then
            entrada_sync <= entrada;
        end if;
    end process;

    -- filtro por estabilidade 
    process(clk, rst)
    begin
        if rst = '1' then
            contador    <= (others => '0');
            saida_reg   <= '0';
            entrada_ant <= '0';

        elsif rising_edge(clk) then

            if entrada_sync /= entrada_ant then
                -- entrada mudou, reinicia o contador
                contador <= (others => '0');
            else
                -- entrada permaneceu estável, incrementa
                if contador < N_CICLOS then
                    contador <= contador + 1;
                else
                    -- entrada estável tempo suficiente → atualiza saída
                    saida_reg <= entrada_sync;
                end if;
            end if;

            -- guarda o valor anterior
            entrada_ant <= entrada_sync;
        end if;
    end process;

    -- saída final
    saida <= saida_reg;

end architecture rtl;
