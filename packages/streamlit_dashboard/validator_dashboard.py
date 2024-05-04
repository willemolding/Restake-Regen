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


eth_emissions = load_energy_use().iloc[:-1]

# Create a Plotly Express line chart
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

# Display the figure using Streamlit
st.plotly_chart(fig)

this_year = datetime.now().year
this_month = datetime.now().month

# Determine the default index for the radio button
# It should be the previous month, considering the year rollover
default_month_index = this_month - 2
this_year = datetime.now().year
this_month = datetime.now().month
report_year = st.selectbox("", range(this_year, this_year - 2, -1))
month_abbr = month_abbr[1:]
report_month_str = st.radio("", month_abbr, index=this_month - 2, horizontal=True)
report_month = month_abbr.index(report_month_str) + 1


# Display the selected year and month
st.text(f"Selected Date: {report_year} {report_month_str}")

# Filtering data based on selected year and month
filtered_data = eth_emissions[eth_emissions["Date"].dt.year == report_year]
filtered_data = filtered_data[filtered_data["Date"].dt.month == report_month]

pledge_contribution = st.slider(
    "Select an Eth Carbon Offset Pledge % of the entire network:",
    min_value=0.00001,
    max_value=1,
    value=0.0001,  # Default value to start with, you can change this as needed
    step=0.00001,
    format="%.5f%%",  # Formatting to show the values as percentages with five decimal places
)

char_price = st.slider(
    "Select an Eth Carbon Offset Pledge % of the entire network:",
    min_value=100,
    max_value=1000,
    value=158,
    step=1,
)


# Check if there is data to display, and show it
if not filtered_data.empty:
    st.write(filtered_data)
    st.write(filtered_data["Monthly Emissions"].iloc[0])
else:
    st.write("No data available for the selected month and year.")


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
