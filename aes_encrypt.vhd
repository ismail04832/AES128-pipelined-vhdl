library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.types_pkg.all;

entity aes_encrypt is
    Port (
        clk         : in  STD_LOGIC;                     -- Horloge système
        rst         : in  STD_LOGIC;                     -- Reset asynchrone (Actif haut)
        valid_in    : in  STD_LOGIC;                     -- Indique si plain_text est valide
        plain_text  : in  STD_LOGIC_VECTOR(127 downto 0); -- Texte clair
        cipher_key  : in  STD_LOGIC_VECTOR(127 downto 0); -- Clé principale 128 bits
        valid_out   : out STD_LOGIC;                     -- Valide 11 cycles plus tard
        cipher_text : out STD_LOGIC_VECTOR(127 downto 0)  -- Texte chiffré
    );
end aes_encrypt;

architecture Pipelined of aes_encrypt is

    -- 1. Déclaration des composants internes
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

    -- 2. Déclarations des signaux pour le câblage combinatoire
    signal round_keys : roundkey_array;

    type state_wire_array is array (0 to 10) of std_logic_vector(127 downto 0);
    signal state_start : state_wire_array;
    signal state_sub   : state_wire_array;
    signal state_shift : state_wire_array;
    signal state_mix   : state_wire_array;

    -- 3. Registres de pipeline pour stocker les états intermédiaires (11 étages)
    type pipeline_reg_array is array (0 to 10) of std_logic_vector(127 downto 0);
    signal state_reg : pipeline_reg_array;
    
    -- Registre à décalage pour propager le signal de validité
    signal valid_pipeline : std_logic_vector(0 to 10);

begin

    ---------------------------------------------------------------------------
    -- Génération des 11 clés de tours
    ---------------------------------------------------------------------------
    KEY_EXP : key_expansion
        port map (
            key_in     => cipher_key,
            round_keys => round_keys
        );

    ---------------------------------------------------------------------------
    -- ÉTAGE 0 : Tour Initial (Round 0)
    ---------------------------------------------------------------------------
    ARK_INIT : add_round_key
        port map (
            state_in  => plain_text,
            round_key => round_keys(0),
            state_out => state_start(0)
        );

    -- Registre de pipeline du Tour 0
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg(0)      <= (others => '0');
            valid_pipeline(0) <= '0';
        elsif rising_edge(clk) then
            state_reg(0)      <= state_start(0);
            valid_pipeline(0) <= valid_in;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- ÉTAGES 1 à 9 : Tours Intermédiaires Pipelinés
    ---------------------------------------------------------------------------
    GEN_ROUNDS : for i in 1 to 9 generate

        -- Transformations combinatoires basées sur l'état enregistré au tour (i-1)
        SUB_I : sub_bytes
            port map (
                state_in  => state_reg(i-1),
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
                state_out => state_start(i)
            );

        -- Enregistrement synchrone de la sortie du tour i
        process(clk, rst)
        begin
            if rst = '1' then
                state_reg(i)      <= (others => '0');
                valid_pipeline(i) <= '0';
            elsif rising_edge(clk) then
                state_reg(i)      <= state_start(i);
                valid_pipeline(i) <= valid_pipeline(i-1);
            end if;
        end process;

    end generate GEN_ROUNDS;

    ---------------------------------------------------------------------------
    -- ÉTAGE 10 : Tour Final (Sans MixColumns)
    ---------------------------------------------------------------------------
    SUB_FINAL : sub_bytes
        port map (
            state_in  => state_reg(9),
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
            state_out => state_start(10)
        );

    -- Registre de sortie finale
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg(10)      <= (others => '0');
            valid_pipeline(10) <= '0';
        elsif rising_edge(clk) then
            state_reg(10)      <= state_start(10);
            valid_pipeline(10) <= valid_pipeline(9);
        end if;
    end process;

    -- Affectation des sorties
    cipher_text <= state_reg(10);
    valid_out   <= valid_pipeline(10);

end Pipelined;
