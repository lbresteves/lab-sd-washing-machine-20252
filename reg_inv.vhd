--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_inv is
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
end reg_inv;


architecture arch of reg_inv is

	signal s_reg : std_logic_vector(3 downto 0);

begin
	reg: process(CLK, RST) begin
        if RST = '1' then
            s_reg <= (others => '1'); -- Reseta para "1111"
        elsif rising_edge(CLK) then
            if LD = '1' then
                s_reg <= REG_IN;
            else
                for i in 0 to 3 loop
                	if s_reg(i) = '0' then -- Verifica se o bit já não é 1
                    	if INV(i) = '1' then
                        	s_reg(i) <= '1'; -- Inverte apenas esse bit
                        end if;
                    else
                        null; 
                    end if;
                end loop;
            end if;
            
        end if;
    end process;
    REG_OUT <= s_reg;
end arch;