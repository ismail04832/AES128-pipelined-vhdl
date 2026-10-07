library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.types_pkg.all;
use work.sbox_pkg.all;

entity sub_bytes is
    Port (
        state_in  : in  std_logic_vector(127 downto 0);
        state_out : out std_logic_vector(127 downto 0)
    );
end sub_bytes;

architecture Behavioral of sub_bytes is
begin

    process(state_in)

        variable state      : state_array;
        variable state_next : state_array;

    begin

        state := vector_to_state(state_in);

        for i in 0 to 15 loop
            state_next(i) := SBOX(to_integer(unsigned(state(i))));
        end loop;

        state_out <= state_to_vector(state_next);

    end process;

end Behavioral;