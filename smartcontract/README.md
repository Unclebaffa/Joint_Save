# JointSave – Smart Contracts (Stellar Soroban)

Soroban smart contracts powering JointSave on the Stellar network.

## Contracts

| Contract | Description |
|---|---|
| `factory` | Registry for all deployed JointSave pools |
| `rotational` | Rotational savings pool – members take turns receiving payouts |
| `target` | Goal-based savings pool – funds unlock when target is reached |
| `flexible` | Flexible deposit/withdraw pool with optional yield distribution |

## Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) with `wasm32-unknown-unknown` target
- [Stellar CLI](https://developers.stellar.org/docs/tools/developer-tools/cli/install-cli)

```bash
rustup target add wasm32-unknown-unknown
```

## Build

```bash
stellar contract build
```

Compiled `.wasm` files land in `target/wasm32-unknown-unknown/release/`.

## Deploy (Testnet)

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

Copy the output contract IDs into your frontend `.env`.

## API Reference

Full API reference for all four contracts — functions, events, storage keys, error conditions, and CLI examples:

**[docs/contract-api.md](../docs/contract-api.md)**

## Network

- **Testnet RPC:** `https://soroban-testnet.stellar.org`
- **Explorer:** [Stellar Expert (testnet)](https://stellar.expert/explorer/testnet)
- **Horizon:** `https://horizon-testnet.stellar.org`
