library IEEE;
use IEEE.std_logic_1164.all;

entity interface is
	port(
	CLOCK_50 : in std_logic;
    	SW	 : in  std_logic_vector(9 downto 0); --interruptores
        KEY  : in  std_logic_vector(1 downto 0); --botões
      	LEDR : out std_logic_vector(9 downto 0); --leds
		HEX0 : out std_logic_vector(7 downto 0); --hex mais a direita
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0);
		HEX5 : out std_logic_vector(7 downto 0)  --hex mais a esquerda
		
    );
end interface;
architecture nome_arq of interface is

	component display is
		port(
		R_Molhado : in std_logic;
        R_Lavado : in std_logic;
        R_Enxaguado : in std_logic;
        R_Centrifugado : in std_logic;
        bcd_in: in std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(6 downto 0);
        leds: out std_logic_vector(3 downto 0)
		 );
	end component;
	
	component temporizador_n is
	port(
			clk      : in  std_logic;           -- Clock de 50 MHz
        rst      : in  std_logic;           -- Reset assíncrono
        tempo    : out std_logic_vector(3 downto 0);  -- Tempo atual (0-9 segundos)
        sinal_9  : out std_logic  
		  );
	end component;
	
	type state_type is (ST0, ST1, ST2, ST3);
	signal LS, NS : state_type;
	signal led_state : std_logic := '0';
	signal key_prev : std_logic := '1';
	signal clk : std_logic;
	signal timer: std_logic_vector(3 downto 0);

begin

	DUT: display port map(SW(9),SW(8),SW(7),SW(6), timer, HEX0(6 downto 0), LEDR(7 downto 4));
	DUT2: temporizador_n port map(CLOCK_50, SW(4), timer, LEDR(8));
	clk <= CLOCK_50;
	
	--LEDR(8 downto 4) <= (others => '0'); 
	HEX0(7) <= '0';
	HEX1 <= "11111111";
	HEX2 <= "11111111";
	HEX3 <= "11111111";
	HEX4 <= "11111111";
	HEX5 <= "11111111";
	LEDR(9) <= led_state;
	
	luzes : process(LS) begin
		case LS is
			when ST0 =>
            	NS <= ST1;
				LEDR(0) <= '1';
				LEDR(1) <= '0';
                LEDR(2) <= '0';
                LEDR(3) <= '0';
			when ST1 =>
            	NS <= ST2;
				LEDR(0) <= '0';
				LEDR(1) <= '1';
                LEDR(2) <= '0';
                LEDR(3) <= '0';
            when ST2 =>
            	NS <= ST3;
				LEDR(0) <= '0';
				LEDR(1) <= '0';
                LEDR(2) <= '1';
                LEDR(3) <= '0';
            when ST3 =>
            	NS <= ST0;
				LEDR(0) <= '0';
				LEDR(1) <= '0';
                LEDR(2) <= '0';
                LEDR(3) <= '1';
			when others =>
				NS <= ST0;
				LEDR(0) <= '1';
				LEDR(1) <= '1';
                LEDR(2) <= '1';
                LEDR(3) <= '1';
		end case;
	end process luzes;
	
	mudar : process(clk) begin
		if rising_edge(clk) then
			
		if key_prev = '1' and key(0) = '0' then
			led_state <= not led_state;
			LS <= Ns;
		end if;
		key_prev <= key(0);
		
		end if;
	end process mudar;
end architecture;