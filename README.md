# 🌱 Restake//Regen

🧠 An Eigenlayer AVS public good that allows Ethereum validators to pledge their commitment to offset either their own or a fraction of the network's energy usage and carbon expenses by pledging to purchasing and retiring high-quality carbon credits.


## Overview

🌏 Despite Ethereums move to proof-of-stake cutting its energy use by over [8000x](https://ethereum.org/en/energy-consumption/), eth still has a network of over 1,000,000 lightweight nodes running varying hardware, emitting roughly [2,000 Tonnes of CO2 annually](https://ccaf.io/cbnsi/ethereum/ghg). 

Protocols like Celo [can claim to be carbon neutral](https://blog.celo.org/a-carbon-negative-blockchain-its-here-and-it-s-celo-60228de36490) because the protocol itself takes a small cut of every block rewards which goes to a carbon offset fund.

Adding this to Ethereum is impossible without a hard-fork however we can get a similar result using Eigenlayer restaking and slashing mechanisms by defining an AVS (Actively Validated Service) that enforces their pledge to subsidising the energy usage of running a node by retiring high quality[ Toucan Biochar (CHAR) carbon credits](https://app.toucan.earth/) on Base L2.

Validators register (opt-in) with the AVS with a self-selected % pledge of the total etherium network (between 0.0001% and 1%) and then each epoch (28 days with 13 months a year per the [International Fixed Calendar](https://en.wikipedia.org/wiki/International_Fixed_Calendar)) they must send the required amount of CHAR to the Restake//Regen Funding Pool contract, which is then offset every 1T accumulated by anyone. The offset amount required is defined by a custom [Chainlink Any API](https://docs.chain.link/any-api/get-request/examples/array-response#example) oracle linked to the [Cambridge Blockchain Network Sustainability Index API]( https://ccaf.io/cbnsi/ethereum/ghg).

A validator must contribute CHAR to the Restake//Regen Funding Pool in a block within each epoch, and a recipt of this proof is stored in the funding pool. At any time, anyone (i.e. a whistleblower) can challenge a validator through the Funding Pool, and claim they didn't make their promised contribution. If the validator did contribute, the receipt is checked and they wont be slashed. If there is no receipt during that epoch, they are slashed by the AVS. 

## Understanding Ethereum's Carbon Footprint
The Ethereum network has recently grown past 1,000,000 active validators with emissions totalling around 2000T CO2/Yr. Ethereum network Energy and CO2 is difficult to estimate, however is predicted and distributed by the Cambridge Blockchain Network Sustainability Index (CBNSI) provides live estimates of both energy use and carbon expendature [with a thorough methodology to account for global electricity mixes](https://ccaf.io/cbnsi/ethereum/ghg/methodology).
Using open source Eth Validator Data from [Bitquery](https://ide.bitquery.io/ETH2-validators-deposits) and the CBNSI Eth CO2 emissions [Data](https://ccaf.io/cbnsi/ethereum/ghg) and [API](https://ccaf.io/cbeci/api/eth/pos/charts/total_greenhouse_gas_emissions/monthly).

There is technically no upper maximum to number of Eth validators, thus we can assume that the network energy is going to go up over time.
However, we can see in Figure 1 that the average Ethereum validator carbon expense has dropped from 0.004TCO2 (4kg CO2) / Validator / Epoch in April 2023, to 0.001TCO2 (~1kg CO2) in April 2024, suggesting that the network is greening over time. 
These numbers are negigble and we propose that validators may opt-in to 1x,5x,10x, 100x or 1000x of their emissions to help green the network.
With ~1,111,489 active validators 

![Emissions per Validator](figures/emissions_per_validator.png)
Figure 1: (a) Total Ethereum Emissions and Validators, (b) Emissions per Validator per Epoch
Data Sources: 

## Toucan
Toucan is a well trusted carbon credit cryptocurrecy system based on bridged, real world offsets from Vera and Gold Standard.
Toucan deployed their high quality [CHAR](https://app.toucan.earth/) credits on Base L2 in March 2024, currently priced at ~$160 USD (May 4, 2024).
The total Ethereum annual network carbon cost equates to roughly $320,000 per year, or <$0.32c per validator per year or ~2c per validator per epoch .


## System Components

![Restake-Regen Network Architecture](figures/network_diagram.excalidraw.svg)


### EigenLayer AVS
- Basic Setup to run the full Eigenlayer stack

### Pledge Registry
- Sign up to the AVS
- Opt-in to a specific % of the ethereum network (between 0.0001% and 1%)

### Service Manager
A minimal interface to be an Eigenlayer AVS

### Challenge Manager
Allows anyone to challenge if an operator has not made their required retirements and allows an operator to cancel a challenge via CCIP. Calls into ServiceManager to perform slashing.
 - Chainlink AnyAPI connection with CBNSI. 

### Funding Pool (Base)
Allows anyone to call the `contribute` function to gain a receipt of the CHAR tokens being retired on behalf of a staker/operator. These tokens are pooled before burning (retirement must be in 1T increments). Stores the retirement and allows proofs of this to be sent to L1 to clear challenges at a later date
 - Contribute
 - Challenge
 - Retire
 - Retirement Receipts


### Worldcoin ID Points System
We use Worldcoin Proof of Personhood for sybil restistance to our non-linear points system.
...... Restake//Regen AVS stakers receive bonus points on on signup, and rewards over time for their ongoing climate pledge and retirement of CHAR carbon offsets.

### Slashing flow (from Base Sepolia to Sepolia)

Base Sepolia

- Slasher calls into contract on Base Sepolia passing epoch and validator/operator address they want to attempt to slash
- contract reads from storage the amount that operator deposited for the given epoch
- This is sent to the CCIP router with the target address given as our ChallengeManager contract on Sepolia L1

---

Sepolia L1

- CCIP receiver calls into our slasher contract with the "evidence". ChallengeManager contract checks if this constitues a slashable offence (e.g. epoch has ended, amount is less than pledged by validator) and slashes the given validator if required.

