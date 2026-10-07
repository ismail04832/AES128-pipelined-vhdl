library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.types_pkg.all;

package gf_pkg is

    function xtime(
        b : byte
    ) return byte;

    function mul2(
        b : byte
    ) return byte;

    function mul3(
        b : byte
    ) return byte;

end package gf_pkg;


package body gf_pkg is

    function xtime(
        b : byte
    ) return byte is

        variable result : byte;

    begin

        result := b(6 downto 0) & '0';

        if b(7) = '1' then
            result := result xor x"1B";
        end if;

        return result;

    end function;


    function mul2(
        b : byte
    ) return byte is
    begin

        return xtime(b);

    end function;


    function mul3(
        b : byte
    ) return byte is
    begin

        return xtime(b) xor b;

    end function;

end package body gf_pkg;
