library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity add_round_key is
    Port (
        state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
        round_key : in  STD_LOGIC_VECTOR(127 downto 0);
        state_out : out STD_LOGIC_VECTOR(127 downto 0)
    );
end add_round_key;


architecture behavioral of add_round_key is
begin

state_out <= state_in xor round_key;
  end behavioral;