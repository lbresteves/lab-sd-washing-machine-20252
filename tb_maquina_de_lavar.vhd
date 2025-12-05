--tb_maquina_de_lavar

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_maquina_de_lavar is
end tb_maquina_de_lavar;

architecture tb of tb_maquina_de_lavar is

component maquina_de_lavar is
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
end component;
    signal fio_clk:  std_logic; --entra
    signal fio_rst: std_logic; --entra
    signal fio_b_tiporoupa : std_logic_vector (1 downto 0); --entra
    signal fio_s_tampa :  std_logic; --entra
    signal fio_b_inicio :  std_logic; --entra
    signal fio_s_cheio :  std_logic; --entra
    signal fio_s_vazio :  std_logic; --entra
    signal fio_M_Leds :  std_logic_vector (10 downto 0 ); --sai
    signal fio_F_Motor :  std_logic_vector (1 downto 0); --sai
    signal fio_F_ValvulaEncher :  std_logic; --sai
    signal fio_F_ValvulaEsvaziar :  std_logic; --sai
    signal fio_F_GavetaSabao :  std_logic; --sai
    signal fio_F_GavetaAmaciante :  std_logic; --sai
    signal fio_F_Apito :  std_logic; --sai
    signal fio_sseg:  std_logic_vector(6 downto 0);--tirar
	
	 constant CLK_PERIOD : time := 10 ns; --passagem de tempo real é 1s
	 
	 signal resetar: std_logic;
	 signal B_TipoRoupa: std_logic_vector (1 downto 0);
	 
	 signal Valvula_Encher: std_logic;
	 signal Valvula_Esvaziar:std_logic;
	 signal Gaveta_Sabao:std_logic;
	 signal Gaveta_Amaciante:std_logic;
	 signal Apito: std_logic;
	 signal led4 : std_logic := '0';
	 
	 
	 signal TEMPO: std_logic_vector(7 downto 0);
	 signal fio_hex1: std_logic_vector(7 downto 0);
	 signal MOTOR: std_logic_vector(7 downto 0);
	 signal fio_hex3: std_logic_vector(7 downto 0);
	 signal TIPO_ROUPA: std_logic_vector(7 downto 0);
	 signal ESTADO: std_logic_vector(7 downto 0);
	 
begin
	
	
	
		 -- Clock process
   clk_process :process
   begin
     while now < 30 * CLK_PERIOD loop -- Simulate 30 clock cycles (30 * 1s)
       clk_s <= '0';
       wait for CLK_PERIOD / 2;
       clk_s <= '1';
       wait for CLK_PERIOD / 2;
     end loop;
   wait; -- End simulation

	

end tb;