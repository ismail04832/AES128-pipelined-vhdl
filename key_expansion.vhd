library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.types_pkg.all;
use work.gf_pkg.all;
use work.sbox_pkg.all;
use work.key_pkg.all;
entity key_expansion is
port(
key_in : in std_logic_vector(127 downto 0);
round_keys : out roundkey_array
);
end key_expansion;

architecture behavioral of key_expansion is
begin
process(key_in)


    variable words : word_array;
    variable temp  : word;
begin

words(0):= key_in(127 downto 96);
words(1):= key_in(95 downto 64);
words(2):= key_in(63 downto 32);
words(3):= key_in(31 downto 0);

for i in 4 to 43 loop
   temp:= words(i-1);
 if (i mod 4 = 0) then
       temp := rot_word(temp);

        temp := sub_word(temp);

        temp := temp XOR RCON(i/4);
end if;
words(i) :=  words(i-4) XOR temp;
end loop;

round_keys(0)  <= words(0)  & words(1)  & words(2)  & words(3);
round_keys(1)  <= words(4)  & words(5)  & words(6)  & words(7);
round_keys(2)  <= words(8)  & words(9)  & words(10) & words(11);
round_keys(3)  <= words(12) & words(13) & words(14) & words(15);
round_keys(4)  <= words(16) & words(17) & words(18) & words(19);
round_keys(5)  <= words(20) & words(21) & words(22) & words(23);
round_keys(6)  <= words(24) & words(25) & words(26) & words(27);
round_keys(7)  <= words(28) & words(29) & words(30) & words(31);
round_keys(8)  <= words(32) & words(33) & words(34) & words(35);
round_keys(9)  <= words(36) & words(37) & words(38) & words(39);
round_keys(10) <= words(40) & words(41) & words(42) & words(43);


end process;
end behavioral;




 