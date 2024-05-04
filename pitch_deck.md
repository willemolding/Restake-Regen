# 🌱 Restake//Regen Pitch Deck


An Eigenlayer AVS public good that allows Ethereum validators to pledge their commitment to offset either their own, or a fraction of the network's energy usage and carbon emissions by pledging to purchase and retire high-quality carbon credits.

<br>

*Developed by Dr. Willem Olding and Dr. Nic Pittman*
*As part of the Eth Global Sydney Hackathon*

---

### 🌏 Overview

Ethereums move to proof-of-stake (POS) cut its energy use by over [8000x](https://ethereum.org/en/energy-consumption/), however the POS network has a network of over 1 Million lightweight validator nodes running varying hardware, emitting roughly [2,000 Tonnes of CO2 annually across the network](https://ccaf.io/cbnsi/ethereum/ghg). 

---

Protocols like Celo [can claim to be carbon neutral](https://blog.celo.org/a-carbon-negative-blockchain-its-here-and-it-s-celo-60228de36490) because the protocol itself takes a small cut of every block rewards which goes to a carbon offset fund.

---

We can get a similar result on Ethereum using [Eigenlayer restaking and slashing mechanisms](https://www.blog.eigenlayer.xyz/ycie/) by defining an AVS (Actively Validated Service) that enforces their pledge to subsidise the carbon expense of running a node by retiring high quality [Toucan Biochar (CHAR) carbon credits](https://app.toucan.earth/) on Base L2.

---

### How it Works
A validator must contribute CHAR to the Restake//Regen Funding Pool in a block within each epoch, and a recipt of this proof is stored in the funding pool. After the Epoch, a whistleblower can challenge a validator through the Funding Pool, and claim they didn't make their promised contribution during the specified timeframe. If the validator did contribute, the receipt is checked and they won't be slashed. If there is no receipt during that epoch, they are slashed by the AVS. 

---

### Why Restake//Regen?

There are many reasons a validator may want to pledge their carbon neutrality or negativity with Restake//Regen

1. Risk Management
2. Cash Flow: Allows validators to amortise their carbon emission costs monthly rather than a one-off multi-year commitment.
3. Differentiation and Competitive Advantage
4. Meeting Social pressure
5. Long term viability of the Ethereum Network
7. Airdrop Farming

---

### Ethereum's Carbon Footprint
![emissions_per_validator_singleplot](https://hackmd.io/_uploads/H1SgMNmGC.png)

The number of validators and overall energy use is not constant over time and we can assume that the network carbon output will continue to go up in the future due to no maximum validator cap. 

---

We require an Oracle to distribute the monthly carbon emissions of Ethereum on chain to Restake//Regen. The average Ethereum validator carbon expense has dropped from 4kg CO2 / Validator / Epoch in April 2023, to ~1kg CO2 in April 2024, suggesting that the network and global energy mix is greening over time.

---

These offset numbers are negligable per validator, and we propose that validators may opt-in to 1x 5x, 10x, 100x, 1000x or 10,000x (roughly ~0.0001-1% of the total network) of their emissions to help green the network.

---

## Toucan CHAR Carbon Credits
Toucan is a well trusted carbon credit cryptocurrecy, who recently released high quality [CHAR](https://app.toucan.earth/) credits on Base L2 in March 2024, currently priced at ~$160 USD (May 4, 2024).
At todays price, the total Ethereum annual network carbon cost equates to: $320,000 per year, or <$0.32c per validator per year or ~2c per validator per 28 day epoch.

---


## Restake//Regen System Components

![Restake-Regen Network Architecture](https://hackmd.io/_uploads/H1WwMV7GC.svg)

There are three main components to the Restake//Regen AVS. 
1. Restake//Regen AVS (Ethereum L1)
2. Chainlink AnyAPI: Oracle for live carbon emissions estimates (Ethereum L1)
3. Funding Pool (Base L2)

---

### EigenLayer AVS
- Basic Setup to run the full Eigenlayer stack

### Pledge Registry
- Sign up to the AVS
- Opt-in to a specific % of the ethereum network (between 0.0001% and 1%)

### Service Manager
A minimal interface to be an Eigenlayer AVS

### Challenge Manager
Allows anyone to challenge if an operator has not made their pledged CHAR retirements and allows an operator to cancel a challenge via CCIP. Calls into ServiceManager to perform slashing.
 - Chainlink AnyAPI connection with the CBNSI Web2 API. 

### Funding Pool (Base L2)
 - `Contribute`
Allows operators to call the `Contribute` function to add CHAR tokens to the Funding Pool, and get a receipt for these CHAR tokens being retired on behalf of a operator. These tokens are pooled before burning (CHAR retirement must be in 1T increments). The Funding Pool then Stores the retirement and allows proofs of this contribution to be sent to L1, as to clear any challenges at a later date
- `Challenge`
Allows anyone, such as a whistleblower, to claim that an operator did not make their pledged commitment in a previous epoch, by checking the Retirement Receipts. Invokes the L1 Challenge Manager.
- `Retire`
Allows anyone to retire the entire FundingPool CHAR credits (Minimum 1T)
- `Retirement Receipts`
Storage of operator contribution receipts, to be used during Challenge acted on L1. 

### Chainlink Cross Chain Interoperability (CCIP)
We use the Chainlink CCIP to send Challenge and Pledge Receipt messages between Ethereum L1 and Base L2. 


### Worldcoin ID Points System
We use Worldcoin Proof of Personhood for sybil restistance to our non-linear points system.
Restake//Regen AVS stakers receive bonus points on on signup, and rewards over time for their ongoing climate pledge and retirement of CHAR carbon offsets.


---


### The AVS Slashing flow (from Base Sepolia to Sepolia)

1. Whistleblower calls contract on Base Sepolia passing epoch and operator address they want to attempt to slash
2. contract reads from storage the amount that operator deposited for the given epoch.
3. This is sent to the CCIP router with the target address given as our ChallengeManager contract on Sepolia L1
4. CCIP receiver calls into our L1 slasher contract with the "evidence". `ChallengeManager` contract checks if this constitutes a slashable offence (e.g. epoch has ended, amount is less than pledged by validator) and slashes the given validators staked Ethereum if they did not meet their pledge.

---

### Summary

Restake//Regen is an AVS which allows operators to sign up to pledge their commitment to a particular fraction of the total network carbon emissions.

Toucan CHAR is the high quality credit of choice, to offset the 2,000T CO2 of annual Ethereum carbon emissions 





