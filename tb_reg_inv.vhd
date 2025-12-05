--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Juniors

library IEEE;
use IEEE.std_logic_1164.all;


entity tb_reg_inv is
end tb_reg_inv;

architecture tb of tb_reg_inv is

component reg_inv is

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

end component;
--sinais básicos como reset e clock
    signal rst_s : std_logic;
    signal clk_s : std_logic;
    constant CLK_PERIOD : time := 20 ns;
--sinais especificos
    signal ld_s :std_logic;
    signal inv_s : std_logic_vector(3 downto 0);
    signal reg_in_s :std_logic_vector(3 downto 0);
    signal reg_out_s : std_logic_vector(3 downto 0);


begin
	DUT: reg_inv port map (clk_s, rst_s, ld_s, inv_s, reg_in_s, reg_out_s);

sinais : process begin
	rst_s <= '1';
	ld_s <= '1';
    inv_s <= "1100";
    reg_in_s <= "0011";
    wait for 15 ns;
    rst_s <= '0';
    ld_s <= '1';
    inv_s <= "0011";
    reg_in_s <= "0000";
    wait for CLK_PERIOD;
    ld_s <= '0';
    inv_s <= "0000";
    reg_in_s <= "0000";
    wait for CLK_PERIOD;
    
    inv_s <= "0001";
    reg_in_s <= "0000";
    wait for CLK_PERIOD;
   
    inv_s <= "0011";
    reg_in_s <= "0000";
    wait for CLK_PERIOD;
    
    inv_s <= "0111";
    reg_in_s<= "1100";
    wait;
end process;

-- Clock process
clk_process :process begin
	while now < 200 ns loop -- simula 20 ciclos de clock
       clk_s <= '0';
       wait for CLK_PERIOD / 2;
       clk_s <= '1';
       wait for CLK_PERIOD / 2;
    end loop;
    wait; -- End simulation
   
end process;    
    

end architecture tb;