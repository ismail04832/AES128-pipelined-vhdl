library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.types_pkg.all;
use work.gf_pkg.all;


entity mix_columns is
    Port (
        state_in  : in  std_logic_vector(127 downto 0);
        state_out : out std_logic_vector(127 downto 0)
    );
end mix_columns;



architecture behavioral of mix_columns is

begin

process(state_in)

 variable state : state_array;
 variable state_next : state_array;
  begin


  state := vector_to_state(state_in);
  
--colone0--
state_next(0) :=  mul2(state(0))
  xor mul3(state(1))
  xor state(2)
  xor state(3);

state_next(1) :=  
      state(0)
  xor mul2(state(1))
  xor mul3(state(2))
  xor state(3);

state_next(2) :=
      state(0)
  xor state(1)
  xor mul2(state(2))
  xor mul3(state(3));

state_next(3) :=
      mul3(state(0))
  xor state(1)
  xor state(2)
  xor mul2(state(3));

--colone1--

state_next(4) :=
      mul2(state(4))
  xor mul3(state(5))
  xor state(6)
  xor state(7);

state_next(5) :=
      state(4)
  xor mul2(state(5))
  xor mul3(state(6))
  xor state(7);

state_next(6) :=
      state(4)
  xor state(5)
  xor mul2(state(6))
  xor mul3(state(7));

state_next(7) :=
      mul3(state(4))
  xor state(5)
  xor state(6)
  xor mul2(state(7));
--colonne2--
state_next(8):=
     mul2(state(8))
  xor mul3(state(9))
  xor state(10)
  xor state(11);

state_next(9) :=
      state(8)
  xor mul2(state(9))
  xor mul3(state(10))
  xor state(11);

state_next(10) :=
      state(8)
  xor state(9)
  xor mul2(state(10))
  xor mul3(state(11));

state_next(11) :=
      mul3(state(8))
  xor state(9)
  xor state(10)
  xor mul2(state(11));
--clonne3--

state_next(12) :=
      mul2(state(12))
  xor mul3(state(13))
  xor state(14)
  xor state(15);

state_next(13) :=
      state(12)
  xor mul2(state(13))
  xor mul3(state(14))
  xor state(15);

state_next(14) :=
      state(12)
  xor state(13)
  xor mul2(state(14))
  xor mul3(state(15));

state_next(15) :=
      mul3(state(12))
  xor state(13)
  xor state(14)
  xor mul2(state(15));

state_out <= state_to_vector(state_next);
end process;
end behavioral ;
