library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.types_pkg.all;

entity aes_encrypt is
    Port (
        plain_text  : in  STD_LOGIC_VECTOR(127 downto 0);
        cipher_key  : in  STD_LOGIC_VECTOR(127 downto 0);
        cipher_text : out STD_LOGIC_VECTOR(127 downto 0)
    );
end aes_encrypt;

architecture Structural of aes_encrypt is

    -- 1. Déclarations des composants internes
    component key_expansion is
        port(
            key_in     : in  std_logic_vector(127 downto 0);
            round_keys : out roundkey_array
        );
    end component;

    component add_round_key is
        port(
            state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
            round_key : in  STD_LOGIC_VECTOR(127 downto 0);
            state_out : out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component sub_bytes is
        port(
            state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
            state_out : out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component ShiftRow is
        port(
            state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
            state_out : out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component mix_columns is
        port(
            state_in  : in  STD_LOGIC_VECTOR(127 downto 0);
            state_out : out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    -- 2. Déclarations des signaux pour le câblage
    signal round_keys : roundkey_array;
    
    -- Tableaux de bus 128 bits pour relier les étapes entre les 10 tours
    type state_wire_array is array (0 to 10) of std_logic_vector(127 downto 0);
    signal state_start : state_wire_array;
    signal state_sub   : state_wire_array;
    signal state_shift : state_wire_array;
    signal state_mix   : state_wire_array;

begin

    ---------------------------------------------------------------------------
    -- Génération des 11 clés de tours à partir de la clé initiale
    ---------------------------------------------------------------------------
    KEY_EXP : key_expansion
        port map (
            key_in     => cipher_key,
            round_keys => round_keys
        );

    ---------------------------------------------------------------------------
    -- Tour Initial (Round 0) : Seul AddRoundKey est exécuté
    ---------------------------------------------------------------------------
    ARK_INIT : add_round_key
        port map (
            state_in  => plain_text,
            round_key => round_keys(0),
            state_out => state_start(1)
        );

    ---------------------------------------------------------------------------
    -- Tours Intermédiaires (Rounds 1 à 9)
    -- Enchaînement : SubBytes -> ShiftRow -> MixColumns -> AddRoundKey
    ---------------------------------------------------------------------------
    GEN_ROUNDS : for i in 1 to 9 generate

        SUB_I : sub_bytes
            port map (
                state_in  => state_start(i),
                state_out => state_sub(i)
            );

        SHIFT_I : ShiftRow
            port map (
                state_in  => state_sub(i),
                state_out => state_shift(i)
            );

        MIX_I : mix_columns
            port map (
                state_in  => state_shift(i),
                state_out => state_mix(i)
            );

        ARK_I : add_round_key
            port map (
                state_in  => state_mix(i),
                round_key => round_keys(i),
                state_out => state_start(i+1)
            );

    end generate GEN_ROUNDS;

    ---------------------------------------------------------------------------
    -- Tour Final (Round 10) : Sans l'étape MixColumns
    -- Enchaînement : SubBytes -> ShiftRow -> AddRoundKey
    ---------------------------------------------------------------------------
    SUB_FINAL : sub_bytes
        port map (
            state_in  => state_start(10),
            state_out => state_sub(10)
        );

    SHIFT_FINAL : ShiftRow
        port map (
            state_in  => state_sub(10),
            state_out => state_shift(10)
        );

    ARK_FINAL : add_round_key
        port map (
            state_in  => state_shift(10),
            round_key => round_keys(10),
            state_out => cipher_text
        );

end Structural;
