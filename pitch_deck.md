---
slideOptions:
  transition: slide
---

# <img src="https://raw.githubusercontent.com/willemolding/Restake-Regen/main/assets/noun_art/head-earth_noun_logo.ico" alt="Noun Earth" style="width: 100px; height: 100px; vertical-align: middle;"> Restake//Regen


An Eigenlayer Actively Validated Service (AVS) that allows Ethereum validators to pledge and be held accountable to their commitment to offset a fraction of the network's carbon emissions.

<br>

<sub>*Developed by Dr. Willem Olding and Dr. Nic Pittman*
*As part of the Eth Global Sydney Hackathon*</sub>

---

### <img src="https://raw.githubusercontent.com/willemolding/Restake-Regen/main/assets/noun_art/head-earth_noun_logo.ico" alt="Noun Earth" style="width: 100px; height: 100px; vertical-align: middle;"> Overview 1

Protocols like Celo [can claim to be carbon neutral](https://blog.celo.org/a-carbon-negative-blockchain-its-here-and-it-s-celo-60228de36490) because the protocol takes a small cut of every block reward which goes to a carbon offset fund.

---

### <img src="https://raw.githubusercontent.com/willemolding/Restake-Regen/main/assets/noun_art/head-earth_noun_logo.ico" alt="Noun Earth" style="width: 100px; height: 100px; vertical-align: middle;"> Overview 2

Ethereum's move to proof-of-stake (PoS) cut its energy use by over [8000x](https://ethereum.org/en/energy-consumption/), however the PoS network has a growing network of over 1 million lightweight validator nodes running various hardware, emitting [~2,000 Tonnes of CO2 annually across the network](https://ccaf.io/cbnsi/ethereum/ghg). 

---

<div align="center">
  <img src="https://github.com/willemolding/Restake-Regen/blob/main/assets/figures/emissions_per_validator_singleplot.png?raw=true" width="70%" height="50%" alt="Emissions and Validators">
</div>
The number of validators and carbon emissions is not constant over time and the network carbon output will likely continue to grow in the future as the number of validators increases. 

---

## Toucan CHAR Carbon Credits
Toucan is a trusted carbon credit cryptocurrency and recently released high quality biochar [CHAR](https://app.toucan.earth/) credits on Base L2 in March 2024, currently priced at ~$160 USD (May 4, 2024).
At todays price, the total Ethereum annual network carbon cost equates to: 
- $320,000 per year
- <32c per validator per year, or
- ~2c per validator per 28 day epoch.

---

These offset numbers are negligable per validator, and we propose that operators may opt-in to 1x, 5x, 10x, 100x, 1000x or 10,000x (~0.0001-1% of the total network) of their emissions to help green the network.

---

## Restake//Regen Components

![Restake-Regen Network Architecture](https://github.com/willemolding/Restake-Regen/blob/main/assets/figures/network_diagram.excalidraw.svg?raw=True)

---

### Chainlink Cross Chain Interoperability (CCIP)
We use the Chainlink CCIP to send Challenge and Pledge receipt messages between Ethereum L1 and Base L2. 

---

We use a Chainlink AnyAPI Oracle of Carbon Emissions adapt the CHAR required each epoch so that the % network offset remains constant

---

### Worldcoin ID Points System
We use Worldcoin Proof of Personhood for Sybil resistance to our non-linear Net-zero Points system.


$$\textrm{NetZeroPoints} = \textrm{SignupBonus}+\int_{t_{signup}}^t \textrm{stake out}$$

---

![Restake-Regen Operator Flow](https://raw.githubusercontent.com/willemolding/Restake-Regen/main/assets/figures/operator_flow_diagram.excalidraw.svg)

---

![Restake-Regen Whistleblower Flow](https://raw.githubusercontent.com/willemolding/Restake-Regen/74102deddb53e276d05e7ccf347de96c89141536/assets/figures/whistleblower_flow_diagram.excalidraw.svg)


---

### <img src="https://raw.githubusercontent.com/willemolding/Restake-Regen/main/assets/noun_art/head-earth_noun_logo.ico" alt="Noun Earth" style="width: 100px; height: 100px; vertical-align: middle;"> Summary 3

We implemented carbon offsetting on Ethereum using [Eigenlayer restaking and slashing mechanisms](https://www.blog.eigenlayer.xyz/ycie/) by creating an Actively Validated Service (AVS). 

The Restake//Regen AVS, holds accountability to operators that pledge to offset their validator carbon emissions by retiring high quality [Toucan Biochar (CHAR) carbon credits](https://app.toucan.earth/) on Base L2.


---

---

### Why Restake//Regen?

Validators have compelling reasons to pledge towards carbon neutrality or even negativity, including:
1. Risk Management
2. Cash Flow: Allows validators to amortise their carbon emission costs monthly rather than a one-off multi-year commitment.
3. Differentiation and Competitive Advantage
4. Meeting Social pressure and personal ethics
5. Long term viability of the Ethereum Network
7. Airdrop Farming

---

There are three main components to the Restake//Regen AVS: 
1. Restake//Regen AVS (Ethereum L1)
2. Chainlink AnyAPI Oracle: Provides live carbon emissions estimates (Ethereum L1)
3. Funding Pool (Base L2)

---


#### AVS Slashing flow (from Base L2 Sepolia to L1 Sepolia)

1. Whistleblower calls Funding Pool `Challenge` contract on Base passing epoch and operator address they want to attempt to slash.
2. Contract reads contribution receipt from storage the amount that operator deposited for the given epoch.

---

#### AVS Slashing flow 2

3. Contribution Receipt is sent to the CCIP router with the target address given as our `ChallengeManager` contract on L1.
4. CCIP receiver calls into our L1 slasher contract with "evidence". `ChallengeManager` contract checks if this constitutes a slashable offence (e.g. epoch has ended, amount is less than pledged by validator) and slashes the given validators staked Ethereum if they did not meet their pledge.


---

## Contracts Summary

---

### EigenLayer AVS
- Basic Setup to run the full Eigenlayer stack

---

### Pledge Registry
- Sign up to the AVS
- Opt-in to a specific % of the Ethereum network (between 0.0001% and 1%)

---

### Service Manager
A minimal interface to be an Eigenlayer AVS

---

### Challenge Manager
Allows anyone to challenge if an operator has not made their pledged CHAR retirements and allows an operator to cancel a challenge via CCIP. Calls into ServiceManager to perform slashing.
 - Currently using a constant 2000T CO2/yr, but
 - Aim to use Chainlink AnyAPI connection with the CBNSI Web2 API. 

---

### Funding Pool (Base L2)
 - `Contribute`
Allows operators to call the `Contribute` function to add CHAR tokens to the Funding Pool, and get a receipt for these CHAR tokens being retired on behalf of a operator. These tokens are pooled before burning (CHAR retirement must be in 1T increments). The Funding Pool then Stores the retirement and allows proofs of this contribution to be sent to L1, as to clear any challenges at a later date

---

### Funding Pool (Base L2)

- `Challenge`
Allows anyone, such as a whistleblower, to claim that an operator did not make their pledged commitment in a previous epoch, by checking the Retirement Receipts. Invokes the L1 Challenge Manager.
- `Retire`
Allows anyone to retire the entire FundingPool CHAR credits (Minimum 1T)
- `Retirement Receipts`
Storage of operator contribution receipts, to be used during Challenge acted on L1. 