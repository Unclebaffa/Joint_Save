# JointSave 🌐
### Community Savings Circles on Stellar

[![CI – Build & Test Soroban Contracts](https://github.com/Sendi0011/Joint_Save/actions/workflows/test.yml/badge.svg)](https://github.com/Sendi0011/Joint_Save/actions/workflows/test.yml)

**JointSave** is a decentralized community savings platform built on **Stellar**, enabling trusted groups to automate contributions, payouts, and transparency using Soroban smart contracts.

---

## Live Demo

🚀 **[https://joint-save.vercel.app](https://joint-save.vercel.app)**

📹 **Demo Video:** [Watch Full MVP Functionality](https://youtu.be/Iuy-As9im7A)

---

## Level 5 - Blue Belt Submission

JointSave is submitted for the Stellar Level 5 - Blue Belt challenge, demonstrating a fully functional MVP with real testnet user validation.

### Submission Requirements

✅ **Live Demo:** [https://joint-save.vercel.app](https://joint-save.vercel.app)

✅ **Demo Video:** [Full MVP Functionality Walkthrough](https://youtu.be/Iuy-As9im7A)

✅ **Architecture Documentation:** [View on Google Docs](https://docs.google.com/document/d/15R4P8vy8DM_45jT5TpaPjyVN7Mw9LPyjgvFtXSuO-Wg/edit?usp=sharing)

✅ **User Feedback Documentation:** [View Feedback Spreadsheet](https://docs.google.com/spreadsheets/d/13hchVp0uGfw8B7mP0K19QWGn_tazvk12X0q2Z0VH-og/edit?usp=sharing)

✅ **Verified Testnet Users (5+):**
1. `GDQJRFOQEYO4CPXJMHOJXW6IOJ2Y3JGBLXWCWMFYNP6FRUTTMQTPXVS6` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GDQJRFOQEYO4CPXJMHOJXW6IOJ2Y3JGBLXWCWMFYNP6FRUTTMQTPXVS6)
2. `GCHFYDDD4BZIZF63HZKYMUCF6EGI3S4JOAUCHSMRN7XDXJRRT` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GCHFYDDD4BZIZF63HZKYMUCF6EGI3S4JOAUCHSMRN7XDXJRRT)
3. `GAB7HJJ0xd5Ff4A4458BC8d2684A452C0C57531731410F3f4` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GAB7HJJ0xd5Ff4A4458BC8d2684A452C0C57531731410F3f4)
4. `GDBMOOICQXCNUTYH7XFZ2XCGR7GYLG5UKHG5VRMWEL3YZ255LXBHMV6L` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GDBMOOICQXCNUTYH7XFZ2XCGR7GYLG5UKHG5VRMWEL3YZ255LXBHMV6L)
5. `GACSPDJNNJNQ3M3LPEUKFEY5NUTAGSF2YEVGIAHCDTFTDAWAKVQQ3FGG` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GACSPDJNNJNQ3M3LPEUKFEY5NUTAGSF2YEVGIAHCDTFTDAWAKVQQ3FGG)
6. `GAIOENLFBEJWPPSUTOHQF4Z2J7S5KRB4REBCM3UVLZIXYHUBWGQUR23R` - [View on Stellar Expert](https://stellar.expert/explorer/testnet/account/GAIOENLFBEJWPPSUTOHQF4Z2J7S5KRB4REBCM3UVLZIXYHUBWGQUR23R)

### User Feedback Summary

Based on feedback collected from 6+ real testnet users, the following insights were gathered:

**Key Feedback Points:**
- Users requested better progress tracking visualization for savings goals
- Need for clearer indication of deposit status in rotational pools
- Request for transaction history with more detailed information
- Desire for mobile notifications when payout rounds are ready
- Suggestion to add estimated completion dates for target pools

**Implemented Improvements:**

1. **Enhanced Progress Tracking**
   - Added visual progress bars to group cards showing percentage toward target
   - Implemented real-time balance updates from on-chain state
   - Color-coded progress indicators (red < 30%, yellow 30-70%, green > 70%)
   - Live on-chain balance enrichment in My Groups dashboard
   - Real-time state fetching for accurate financial data display

### Planned Improvements (Next Phase)

Based on user feedback, the following enhancements are planned for the next development phase:

1. **Advanced Progress Visualization**
   - Add milestone markers on progress bars
   - Show projected completion dates based on current contribution rate
   - Implement animated progress transitions for better UX
   - Add comparison charts showing individual vs. group progress

2. **Enhanced Deposit Status Indicators**
   - Real-time deposit confirmation badges
   - Visual timeline showing who has deposited in current round
   - Push notifications for pending deposits
   - Reminder system for upcoming deposit deadlines

3. **Comprehensive Transaction History**
   - Detailed transaction explorer with filters (date, type, amount)
   - Export transaction history to CSV/PDF
   - Visual charts showing contribution patterns over time
   - Integration with Stellar Explorer for full transaction details

4. **Mobile Notifications System**
   - Browser push notifications for payout rounds
   - Email notifications for important events
   - Customizable notification preferences
   - SMS alerts for critical actions (optional)

5. **Smart Deadline Estimations**
   - AI-powered completion date predictions
   - Historical data analysis for accuracy
   - Adjustable projections based on member behavior
   - Visual countdown timers for target pools

6. **User Experience Improvements**
   - Onboarding tutorial for first-time users
   - Interactive tooltips explaining pool mechanics
   - Dark mode optimization
   - Accessibility enhancements (WCAG 2.1 AA compliance)

All improvements will be tracked and implemented with proper git commits linked in future updates.

---

## Overview

Across the world, millions of people rely on informal savings groups to pool money and support one another. While these systems foster trust and cooperation, they often face problems like missed payments, fraud, and lack of transparency.

**JointSave solves this by putting savings groups onchain — on Stellar.**
Funds are managed by Soroban smart contracts, ensuring automation, transparency, and fairness for everyone.

---

## Key Features

- **Rotational Mode** – Members take turns receiving the full pool payout.
- **Target Pool Mode** – Groups save toward a shared goal.
- **Flexible Pool Mode** – Members deposit anytime and optionally earn yield.
- **Inter-Contract Calls** – Factory contract registers and coordinates all pool contracts on-chain.
- **Onchain Trust** – Every group is governed by a Soroban smart contract escrow.
- **Transparent Tracking** – Every transaction is verifiable on Stellar.
- **Auto Enforcement** – Late deposits are flagged; missed rounds trigger penalties.

---

## Tech Stack

**Smart Contracts (Rust / Soroban)**
- `jointsave-factory` – Registry for all deployed pools (inter-contract coordination)
- `jointsave-rotational` – Rotational savings pool
- `jointsave-target` – Goal-based savings pool
- `jointsave-flexible` – Flexible deposits with optional yield

**Frontend**
- **Next.js** + **Tailwind CSS** – Responsive, mobile-first interface
- **Stellar Wallets Kit** – Freighter and multi-wallet support
- **Stellar SDK** – Soroban contract interaction
- **Supabase** – Off-chain metadata storage

**Infrastructure**
- **Stellar Network** – Fast, low-cost, and energy-efficient
- **Soroban** – Stellar's smart contract platform
- **Vercel** – Frontend deployment
- **GitHub Actions** – CI/CD pipeline

---

## Deployed Contracts (Stellar Testnet)

| Contract | Address / Hash |
|---|---|
| JointSave Factory | `CBZNGP52FLFZ4BOGC265FUAMP5KFMAYPQK3KTI5UHMYVMM3QCST3IMRI` |
| Rotational Pool WASM | `d350a325d8734263a3d7150c875555d8956e13a527fb3497d5141b8b3f3d2c74` |
| Target Pool WASM | `133a62226501fc5443e70007d79deeeb0b33fdf8c85c7fcd3cf16293bb5c7292` |
| Flexible Pool WASM | `df6ff088fd79f13d8d03e72160434517fdb4a83b8c7bfdd887be4369805e0d6b` |

**Deployment Date:** 2026-04-16  
**Network:** Stellar Testnet (`Test SDF Network ; September 2015`)

---

## Inter-Contract Calls

The Factory contract acts as the central registry. After deploying each pool contract separately, the pool is registered with the factory via `register_rotational`, `register_target`, or `register_flexible`. This creates an inter-contract relationship where:

1. Factory stores all pool contract IDs on-chain
2. Frontend queries the factory to discover all active pools
3. Pool contracts are deployed from WASM hashes stored in the factory registry

---

## CI/CD Pipeline

Two GitHub Actions workflows are configured:

- **`test.yml`** – Runs on every push/PR: builds all 4 Soroban contracts and verifies WASM artifacts
- **`deploy.yml`** – Manual trigger: builds and deploys all contracts to Stellar Testnet

![CI/CD Pipeline Overview](docs/ci-screenshot.png)
![CI/CD Pipeline Details](docs/ci-screenshot-details.png)

---

## Mobile Responsive Design

JointSave is fully mobile responsive with:
- Collapsible navigation with hamburger menu on mobile
- Responsive grid layouts (1 col mobile → 3 col desktop)
- Touch-friendly tab navigation in the dashboard
- Fluid typography and spacing via Tailwind CSS

![Mobile – Landing Page](docs/mobile-screeshot-landing.png)
![Mobile – How It Works](docs/mobile-screenshot-how-it-works.png)
![Mobile – Create Savings](docs/mobile-screenshot-create-saving-page.png)
![Mobile – Group View](docs/mobile-screenshot-group.png)

---

## Getting Started

### Smart Contracts

```bash
cd smartcontract
rustup target add wasm32-unknown-unknown
stellar contract build
./scripts/deploy.sh
```

### Frontend

```bash
cd frontend
npm install
cp .env.example .env.local
# Fill in your Supabase and Stellar contract IDs
npm run dev
```

### Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
NEXT_PUBLIC_STELLAR_RPC_URL=https://soroban-testnet.stellar.org
NEXT_PUBLIC_STELLAR_HORIZON_URL=https://horizon-testnet.stellar.org
NEXT_PUBLIC_FACTORY_CONTRACT_ID=CBZNGP52FLFZ4BOGC265FUAMP5KFMAYPQK3KTI5UHMYVMM3QCST3IMRI
NEXT_PUBLIC_TOKEN_CONTRACT_ID=native
```

---

## Roadmap

**Phase 1 – MVP (Current)**
- Group creation & contributions on Stellar
- Rotational / Target / Flexible modes
- Wallet connection and basic dashboard
- Factory inter-contract registry
- CI/CD pipeline

**Phase 2 – Enhancement**
- Yield integrations with Stellar DeFi
- Mobile app
- Group chat
- Reputation system

**Phase 3 – Scale**
- Social onboarding
- Fiat on-ramp
- Microloan marketplace
- DAO governance

---

Built with ❤️ for communities worldwide. Powered by Stellar.
