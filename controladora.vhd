--Turma PN5 
--grupo:
--Leticia Braga Esteves
--Isabela Marcondes dos Santos
--Itamar Rodrigues Soares Junior

library IEEE;
use IEEE.std_logic_1164.all;

entity controladora is 
port(
      clk: in std_logic;
      rst: in std_logic;
      
      s_tampa : in std_logic;
      b_inicio : in std_logic;
      s_cheio : in std_logic;
      s_vazio : in std_logic;
      
      t_estado : in std_logic;
      
      r_molhado : in std_logic;
      r_lavado : in std_logic;
      r_enxaguado : in std_logic;
      r_centrifugado : in std_logic;
      
      estado_anterior : in std_logic_vector(3 downto 0);

      A_Molhar : out std_logic; 
      A_Lavar : out std_logic;
      A_Enxaguar : out std_logic;
      A_Centrifugar : out std_logic;
      
      h_led : out std_logic;
      h_controle : out std_logic;
      h_motor : out std_logic;
      h_apito : out std_logic;
      
      h_encher : out std_logic;
      h_esvaziar : out std_logic;
      h_sabao : out std_logic;
      h_amaciante : out std_logic;
      t_iniciar : out std_logic;
      t_resetar : out std_logic;
      estado_atual : out std_logic_vector(3 downto 0)
);
end controladora;

architecture fsm of controladora is

    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, s12, S13);
    signal PS, NS : state_type;

    function state_to_vector(state : state_type) return std_logic_vector is
    begin
        case state is
            when S0 => return "0000";
            when S1 => return "0001";
            when S2 => return "0010";
            when S3 => return "0011";
            when S4 => return "0100";
            when S5 => return "0101";
            when S6 => return "0110";
            when S7 => return "0111";
            when S8 => return "1000";
            when S9 => return "1001";
            when S10 => return "1010";
				when S11 => return "1011";
				when S12 => return "1100";
				when S13 => return "1101";
            when others => return "1111";
        end case;
    end function;
    
begin
 
    sync_proc: process(clk, rst)
    begin
        if rst = '1' then
            PS <= S0;
        elsif rising_edge(clk) then
            PS <= NS;
        end if;
    end process;

    comb_proc: process(PS, s_tampa, b_inicio, s_cheio, s_vazio,
                      r_lavado, r_molhado, r_enxaguado, r_centrifugado,
                      t_estado, estado_anterior)
    begin
    
        A_Lavar <= '0';
        A_Enxaguar <= '0';
        A_Centrifugar <= '0';
        A_Molhar <= '0';
        h_led <= '0';
        h_controle <= '0';
        h_motor <= '0';
        h_apito <= '0';
        h_encher <= '0';
        h_esvaziar <= '0';
        h_sabao <= '0';
        h_amaciante <= '0';
        t_iniciar <= '0';
        t_resetar <= '1';
        NS <= PS;
        
        case PS is
        
            when S0 =>
					  A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '0';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';	
                if s_tampa = '1' and b_inicio = '1' then
                    NS <= S1;
                end if;
                
            when S1 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '1';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and b_inicio = '0' then
                    NS <= S2;
                end if;

            when S2 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '1';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and s_cheio = '1' and r_lavado = '0' then
                    NS <= S3;
                elsif s_tampa = '1' and s_cheio = '1' and r_lavado = '1' then
                    NS <= S7;
                end if;
                
            when S3 =>
                A_Lavar <= '1';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '1';
					  h_amaciante <= '0';
					  t_iniciar <= '1';
					  t_resetar <= '0';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and t_estado = '1' then
                    NS <= S9;
                end if;

            when S4 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '1';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '1';
					  t_resetar <= '0';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and t_estado = '1' then
                    NS <= S6;
                end if;

            when S5 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '0';
					  h_controle <= '0';
					  h_motor <= '1';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '1';
					  t_resetar <= '0';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and t_estado = '1' and r_molhado = '1' and r_enxaguado = '0'and r_centrifugado = '0' then
                    NS <= S6;
					 elsif s_tampa = '1' and t_estado = '1' and r_molhado = '1' and r_enxaguado ='1' and r_centrifugado = '0' then
                    NS <= S13;
                elsif s_tampa = '1' and t_estado = '1' and r_molhado = '1' and r_centrifugado = '1' then
                    NS <= S12;
                elsif s_tampa = '1' and t_estado = '1' and r_molhado = '0' then
                    NS <= S11;
                end if;

            when S6 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '1';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and s_vazio = '1' and r_enxaguado = '0' then
                    NS <= S2;
                elsif s_tampa = '1' and s_vazio = '1' and r_enxaguado = '1' then
                    NS <= S9;
                end if;

            when S7 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '1';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '1';
					  t_iniciar <= '1';
					  t_resetar <= '0';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and t_estado = '1' then
                    NS <= S9;
                end if;

            when S8 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '1';
					  t_resetar <= '0';
                if s_tampa = '0' then
                    NS <= S0;
                elsif s_tampa = '1' and t_estado = '1' then
                    NS <= S0;
                end if;

            when S9 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
                NS <= S5;

            when S10 =>
                A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '0';
                if s_tampa = '1' then
                    case estado_anterior is
                        when "0000" => NS <= S0;
                        when "0001" => NS <= S1;
                        when "0010" => NS <= S2;
                        when "0011" => NS <= S3;
                        when "0100" => NS <= S4;
                        when "0101" => NS <= S5;
                        when "0110" => NS <= S6;
                        when "0111" => NS <= S7;
                        when "1000" => NS <= S8;
                        when "1001" => NS <= S9;
                        when others => NS <= S0;
                    end case;
                end if;
				when S11 => 
					A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
					 NS <= S4;
				when S12 => 
					A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '0';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
					 NS <= S8;
				when S13 => 
					A_Lavar <= '0';
					  A_Enxaguar <= '0';
					  A_Centrifugar <= '1';
					  A_Molhar <= '0';
					  h_led <= '1';
					  h_controle <= '0';
					  h_motor <= '0';
					  h_apito <= '0';
					  h_encher <= '0';
					  h_esvaziar <= '0';
					  h_sabao <= '0';
					  h_amaciante <= '0';
					  t_iniciar <= '0';
					  t_resetar <= '1';
					 NS <= S6;
            when others =>
                NS <= S0;
                
        end case;
        
        if s_tampa = '0' and PS /= S0 and PS /= S1 and PS /= S8 then
            NS <= S10;
        end if;
        
        estado_atual <= state_to_vector(PS);
        
    end process;

end fsm;
