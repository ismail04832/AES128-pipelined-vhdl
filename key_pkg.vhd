library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


library work;
use work.types_pkg.all;  
use work.sbox_pkg.all;   


package key_pkg is

    
    type rcon_array is array (1 to 10) of word;

    constant RCON : rcon_array := (
        1  => x"01000000",
        2  => x"02000000",
        3  => x"04000000",
        4  => x"08000000",
        5  => x"10000000",
        6  => x"20000000",
        7  => x"40000000",
        8  => x"80000000",
        9  => x"1B000000",
        10 => x"36000000"
    );

   
    function rot_word(w : word) return word;
    function sub_word(w : word) return word;

end package key_pkg;


package body key_pkg is

   
    function rot_word(w : word) return word is
        variable result : word;
    begin
        result := w(23 downto 0) & w(31 downto 24);
        return result;
    end function rot_word;

   
    function sub_word(w : word) return word is
        variable result : word;
    begin
        result := SBOX(to_integer(unsigned(w(31 downto 24))))
                & SBOX(to_integer(unsigned(w(23 downto 16))))
                & SBOX(to_integer(unsigned(w(15 downto 8))))
                & SBOX(to_integer(unsigned(w(7 downto 0))));
        return result;
    end function sub_word;

end package body key_pkg;
