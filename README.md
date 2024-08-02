# Mishti Smart Contracts

Public smart contracts used by Mishti.

| Contract Name | Network | Address | Owner |
| --- | --- | --- | --- |
| PeerRegistry | Holesky | 0x64697be111A55070DA832e39272F7a297079C452 | n/a |
| AddressAccessManager | Holesky | 0x3182E2BE7D8155E9AcDB599e39Fc3D48A400C094 | 0xb18399Ce7899278C1E2dcDe1dbd00FBAb0C970DF |

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

With `script`...

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

With `create`...

```shell
$ forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/PeerRegistry.sol:PeerRegistry
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
