import streamlit as st
import requests
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import pandas as pd
import plotly.express as px
from calendar import month_abbr


# %% Get API for total energy use on Ethereum
# URL containing the JSON data


def load_energy_use(
    url="https://ccaf.io/cbeci/api/eth/pos/charts/total_greenhouse_gas_emissions/monthly",
):

    # Fetch the data
    response = requests.get(url)
    data = response.json()["data"]

    # Extract timestamps and emission values from the JSON data
    timestamps = [item["x"] for item in data]
    emissions = [item["y"] for item in data]

    # Convert UNIX timestamps to datetime objects for plotting
    dates = [datetime.utcfromtimestamp(ts) for ts in timestamps]

    eth_emissions = pd.DataFrame(
        {
            "Date": pd.to_datetime(dates),  # Ensuring dates are in datetime format
            "Monthly Emissions": emissions,
        }
    )
    return eth_emissions


# %% LOAD DATA

eth_emissions = load_energy_use().iloc[:-1]
eth_emissions["Monthly Emissions"] = (
    eth_emissions["Monthly Emissions"] * 1000
)  # from Kt to 2
this_year = datetime.now().year
this_month = datetime.now().month

# Determine the default index for the radio button
# It should be the previous month, considering the year rollover
default_month_index = this_month - 2
this_year = datetime.now().year
this_month = datetime.now().month
month_abbr = month_abbr[1:]


# %% Start FE

st.write("## Restake//Regen Validator Dashboard")

col1, col2 = st.columns(2)
report_month_str = col1.radio("", month_abbr, index=this_month - 2, horizontal=True)
report_year = col2.selectbox("", range(this_year, this_year - 2, -1))
report_month = month_abbr.index(report_month_str) + 1

# Display the selected year and month
col2.text(f"Selected Date: {report_year} {report_month_str}")

# Filtering data based on selected year and month
filtered_data = eth_emissions[eth_emissions["Date"].dt.year == report_year]
filtered_data = filtered_data[filtered_data["Date"].dt.month == report_month]


col1, col2 = st.columns(2)
pledge_contribution_decimal = col1.selectbox(
    "Choose your contribution level (% of Ethereum Network):",
    options=[1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001],
    index=4,
)

char_price = col2.slider(
    "CHAR Price:",
    min_value=100,
    max_value=1000,
    value=158,
    step=1,
)

cost_in_char = filtered_data["Monthly Emissions"].iloc[0] * pledge_contribution_decimal
cost_in_usdc = (
    filtered_data["Monthly Emissions"].iloc[0]
    * pledge_contribution_decimal
    * char_price
)
num_validators = 1e6

avg_validator = filtered_data["Monthly Emissions"].iloc[0] / num_validators
validators_offset = cost_in_char / avg_validator


# Check if there is data to display, and show it
if not filtered_data.empty:
    #    st.write(filtered_data)
    st.write(f"### Total Tonnes CO2 this epoch: {cost_in_char} CHAR")
    st.write(f"### Total Cost this epoch: ${cost_in_usdc} USD")
    st.write(f"### # Validators Offset: {int(validators_offset)}")
#  st.write(f"Total Tonnes of CO2 required, Eth Tokens: {cost_in_eth}")

else:
    st.write("No data available for the selected month and year.")


# Display the figure using Streamlit

fig = px.line(
    eth_emissions,
    x="Date",
    y="Monthly Emissions",
    title="Monthly Ethereum Emissions Over Time",
    markers=True,
    labels={"Monthly Emissions": "Monthly Emissions (Tonnes CO2)"},
)

# Setting up the x-axis to rotate the date labels and making the layout tight
fig.update_layout(
    xaxis_tickangle=-45,
    xaxis_title="Date",
    yaxis_title="Monthly Emissions (Tonnes CO2)",
    template="plotly_white",
)


st.plotly_chart(fig)

# Live price NOT WORKING GRRR
# from web3 import Web3

# # Connect to the node (this is an example URL, replace it with your actual node URL)
# web3 = Web3(Web3.HTTPProvider('https://base-mainnet.g.alchemy.com/v2/BtNaIZ0ChAVK3RL49_D9w3tQE4WTvuQl'))
# contract_address = '0x20b048fA035D5763685D695e66aDF62c5D9F5055'
# contract = web3.eth.contract(address=contract_address, abi=[{
#     "name": "getReserves",
#     "inputs": [],
#     "outputs": [{"type": "uint112"}, {"type": "uint112"}, {"type": "uint32"}],
#     "stateMutability": "view",
#     "type": "function"
# }])
# reserves = contract.functions.getReserves().call()
# # Assuming token0 is the token of interest and token1 is the quote token (like ETH)
# token0_reserve, token1_reserve = reserves[0], reserves[1]
# price = token1_reserve / token0_reserve
# print(f'The price of token0 in terms of token1 is {price}')
