library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types_pkg is

    -- Définition d'un octet
    subtype byte is std_logic_vector(7 downto 0);
    -- Définition de sbox
   type sbox_array is array (0 to 255) of byte;
  --Définition f'un word--
   subtype word is std_logic_vector(31 downto 0);
-- definition sortie de key expansion--
type roundkey_array is array (0 to 10) of std_logic_vector(127 downto 0);
--defintion de tableu de word de key--
type word_array is array (0 to 43) of word;
    -- Définition du State AES (16 octets)
    type state_array is array (0 to 15) of byte;
  -- Définition du key --
  type key_array is array (0 to 15) of word;
    -- Conversion std_logic_vector -> state_array
    function vector_to_state(
        data : std_logic_vector(127 downto 0)
    ) return state_array;

    -- Conversion state_array -> std_logic_vector
    function state_to_vector(
        state : state_array
    ) return std_logic_vector;

end package types_pkg;


package body types_pkg is

    --------------------------------------------------------------------
    -- Conversion d'un vecteur 128 bits vers un tableau de 16 octets
    --------------------------------------------------------------------
    function vector_to_state(
        data : std_logic_vector(127 downto 0)
    ) return state_array is

        variable state : state_array;

    begin

        for i in 0 to 15 loop
            state(i) := data(127 - i*8 downto 120 - i*8);
        end loop;

        return state;

    end function;


    --------------------------------------------------------------------
    -- Conversion d'un tableau de 16 octets vers un vecteur 128 bits
    --------------------------------------------------------------------
    function state_to_vector(
        state : state_array
    ) return std_logic_vector is

        variable data : std_logic_vector(127 downto 0);

    begin

        for i in 0 to 15 loop
            data(127 - i*8 downto 120 - i*8) := state(i);
        end loop;

        return data;

    end function;

end package body types_pkg;
