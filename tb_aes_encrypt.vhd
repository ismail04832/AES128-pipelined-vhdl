library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_aes_encrypt is
end tb_aes_encrypt;

architecture behavior of tb_aes_encrypt is

    signal plain_text  : std_logic_vector(127 downto 0);
    signal cipher_key  : std_logic_vector(127 downto 0);
    signal cipher_text : std_logic_vector(127 downto 0);

begin

    DUT : entity work.aes_encrypt
        port map(
            plain_text  => plain_text,
            cipher_key  => cipher_key,
            cipher_text => cipher_text
        );

    stimulus : process
    begin

        plain_text <= x"00112233445566778899AABBCCDDEEFF";
        cipher_key <= x"000102030405060708090A0B0C0D0E0F";

        wait for 100 ns;

        wait;

    end process;

end behavior;
