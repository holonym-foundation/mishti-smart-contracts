# Mishti Smart Contracts

Public smart contracts used by Mishti.

| Contract Name | Network | Address | Owner |
| --- | --- | --- | --- |
| PeerRegistry | Holesky | 0x8E12AbF829493206e8188E68fc56a56cAA67aeD6 | n/a |

## Mishti Decryption Contracts

Contracts that determine how many Mishti decryption credits an address has.

| Contract Name | Network | Address | Owner |
| --- | --- | --- | --- |
| AuthorityWithDailyRateLimitV2 | Holesky | 0xE6BaB4228Ad23D59A1F1D69f1Cb14C2Ba29D91e9 | 0xb18399Ce7899278C1E2dcDe1dbd00FBAb0C970DF |
| MishtiDecryptionCredits (DEPRECATED) | Holesky | 0x5c0BD67f439fCd9D48D7033670e0eE1aF52F45c0 | 0xb18399Ce7899278C1E2dcDe1dbd00FBAb0C970DF |

<hr/>

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
