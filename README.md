# Pipelined AES-128 encryption core

A VHDL implementation of the AES-128 encryption datapath with a register after each round. The [top-level entity](aes_encrypt.vhd) takes a 128-bit plaintext block and key and propagates a validity bit alongside the state.

| Stage | Datapath |
|---|---|
| 0 | Combine the plaintext with the initial round key. |
| 1–9 | Apply SubBytes, ShiftRows, MixColumns and AddRoundKey. |
| 10 | Apply SubBytes, ShiftRows and the final AddRoundKey. |

## Interface and key handling

Assert `valid_in` when presenting a block on `plain_text`. Sample `cipher_text` when `valid_out` is asserted. The active-high asynchronous reset clears the pipeline registers. The [key expansion logic](key_expansion.vhd) drives all rounds from the current `cipher_key`, so keep the key stable until every block using it has left the pipeline.

## Related RTL projects

[RISC-V processor](https://github.com/ismail04832/risc-v) · [Bus encoding and assertions](https://github.com/ismail04832/CRT) · [Dual-clock FIFO](https://github.com/ismail04832/asynch_fifo) · [OFDM cyclic-prefix metric](https://github.com/ismail04832/detection-prefixe-_cyclique) · [RTL exercises](https://github.com/ismail04832/Training)
