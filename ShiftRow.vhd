library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.types_pkg.all;

entity ShiftRow is
    Port (
        state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
        state_out : out STD_LOGIC_VECTOR(127 downto 0)
    );
end ShiftRow;

architecture Behavioral of ShiftRow is
begin

    process(state_in)

        variable state      : state_array;
        variable state_next : state_array;

    begin

        -- Conversion du vecteur vers le tableau
        state := vector_to_state(state_in);

        ------------------------------------------------------------------
        -- ShiftRows
        ------------------------------------------------------------------

        -- Ligne 0
        state_next(0)  := state(0);
        state_next(4)  := state(4);
        state_next(8)  := state(8);
        state_next(12) := state(12);

        -- Ligne 1
        state_next(1)  := state(5);
        state_next(5)  := state(9);
        state_next(9)  := state(13);
        state_next(13) := state(1);

        -- Ligne 2
        state_next(2)  := state(10);
        state_next(6)  := state(14);
        state_next(10) := state(2);
        state_next(14) := state(6);

        -- Ligne 3
        state_next(3)  := state(15);
        state_next(7)  := state(3);
        state_next(11) := state(7);
        state_next(15) := state(11);

        -- Conversion du tableau vers le vecteur
        state_out <= state_to_vector(state_next);

    end process;

end Behavioral;