library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_aes_encrypt is
end tb_aes_encrypt;

architecture behavior of tb_aes_encrypt is

    -- Constantes de simulation
    constant CLK_PERIOD : time := 10 ns; -- Horloge à 100 MHz

    -- Signaux de contrôle et d'horloge
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal valid_in  : std_logic := '0';
    signal valid_out : std_logic;

    -- Signaux de données
    signal plain_text  : std_logic_vector(127 downto 0) := (others => '0');
    signal cipher_key  : std_logic_vector(127 downto 0) := (others => '0');
    signal cipher_text : std_logic_vector(127 downto 0);

begin

    ---------------------------------------------------------------------------
    -- Instanciation du Design Under Test (DUT)
    ---------------------------------------------------------------------------
    DUT : entity work.aes_encrypt
        port map(
            clk         => clk,
            rst         => rst,
            valid_in    => valid_in,
            plain_text  => plain_text,
            cipher_key  => cipher_key,
            valid_out   => valid_out,
            cipher_text => cipher_text
        );

    ---------------------------------------------------------------------------
    -- Génération de l'horloge (100 MHz)
    ---------------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    ---------------------------------------------------------------------------
    -- Process de Stimulus
    ---------------------------------------------------------------------------
    stimulus : process
    begin

        -- 1. Initialisation et Reset (Actif Haut)
        rst <= '1';
        valid_in <= '0';
        wait for CLK_PERIOD * 2;
        
        -- Relâchement du Reset
        rst <= '0';
        wait for CLK_PERIOD;

        -- 2. Injection du 1er bloc de test (NIST Known Answer Test)
        plain_text <= x"00112233445566778899AABBCCDDEEFF";
        cipher_key <= x"000102030405060708090A0B0C0D0E0F";
        valid_in   <= '1';
        wait for CLK_PERIOD;

        -- 3. Injection d'un 2ème bloc au cycle suivant (pour tester le débit du pipeline)
        plain_text <= x"3243f6a8885a308d313198a2e0370734";
        cipher_key <= x"2b7e151628aed2a6abf7158809cf4f3c";
        valid_in   <= '1';
        wait for CLK_PERIOD;

        -- Désactivation de valid_in
        valid_in <= '0';

        -- 4. Attente de la propagation à travers les 11 étages du pipeline
        wait for CLK_PERIOD * 15;

        -- Fin de la simulation
        wait;

    end process;

end behavior;
