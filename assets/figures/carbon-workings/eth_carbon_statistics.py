import requests
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime, timedelta
import plotly.graph_objects as go
from plotly.subplots import make_subplots


# GET TOTAL NUMBER OF ETH VALIDATORS
# Thank youuuu https://ide.bitquery.io/ETH2-validators-deposits

# Define the GraphQL query and endpoint
url = "https://graphql.bitquery.io/"  # Assuming using Bitquery's GraphQL endpoint
headers = {
    "Content-Type": "application/json",
    "X-API-KEY": "BQYhJ6Qq8y077blrFExvfAC6NW5yquMv",  # Replace YOUR_BITQUERY_API_KEY with your actual API key
}

query = """
query ($network: Ethereum2Network!, $from: ISO8601DateTime, $till: ISO8601DateTime) {
  ethereum2(network: $network) {
    deposits(date: {since: $from, till: $till}) {
      count
      amount
      validators: count(uniq: validators)
    }
  }
}
"""


# Helper function to get the first and last days of the month
def month_range(year, month):
    start = datetime(year, month, 1)
    if month == 12:
        end = datetime(year + 1, 1, 1) - timedelta(days=1)
    else:
        end = datetime(year, month + 1, 1) - timedelta(days=1)
    return start, end


# Set up date range
start_date = datetime(2022, 1, 1)
end_date = datetime.today()
all_data = []

# Brute force API Loop over each month in the date range
current = start_date
while current < end_date:
    start, end = month_range(current.year, current.month)
    if end > end_date:
        end = end_date

    variables = {"network": "eth2", "from": start.isoformat(), "till": end.isoformat()}

    # Send the request
    response = requests.post(
        url, json={"query": query, "variables": variables}, headers=headers
    )
    data = response.json()

    if "errors" in data:
        raise Exception(data["errors"])

    # Extract data and add date
    validators_data = data["data"]["ethereum2"]["deposits"]
    for entry in validators_data:
        entry["date"] = start.strftime("%Y-%m")
        all_data.append(entry)

    current = end + timedelta(days=1)


# %% Create Total Validators Dataframe
validators_df = pd.DataFrame(all_data)

# Group by month and sum the validators count
validators_df = validators_df.groupby("date")["validators"].sum()

# Convert to DataFrame
validators_df = validators_df.reset_index()
validators_df["date"] = pd.to_datetime(validators_df["date"])
validators_df["total_validators"] = validators_df["validators"].cumsum()
validators_df = validators_df.set_index("date")

# Plot
plt.figure(figsize=(10, 5))
plt.plot(validators_df.index, validators_df["total_validators"])
plt.title("Number of Validators Over Time")
plt.xlabel("Date")
plt.ylabel("Number of Validators")
plt.grid(True)
plt.show()


# %% Get API for total energy use on Ethereum
# URL containing the JSON data
url = "https://ccaf.io/cbeci/api/eth/pos/charts/total_greenhouse_gas_emissions/monthly"

# Fetch the data
response = requests.get(url)
data = response.json()["data"]

# Extract timestamps and emission values from the JSON data
timestamps = [item["x"] for item in data]
emissions = [item["y"] for item in data]

# Convert UNIX timestamps to datetime objects for plotting
dates = [datetime.utcfromtimestamp(ts) for ts in timestamps]

# Create a plot
plt.figure(figsize=(10, 5))
plt.plot(dates, emissions, marker="o", linestyle="-", color="b")
plt.title("Monthly Ethereum Emissions Over Time")
plt.xlabel("Date")
plt.ylabel("Monthly Emissions (Tonnes CO2)")
plt.grid(True)
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# %% MERGE TOGETHER


emissions_df = pd.DataFrame(emissions)
emissions_df["date"] = pd.to_datetime(dates)
emissions_df = emissions_df.set_index("date")

validators_df["emissions_Tco2"] = emissions_df[0] * 1e4  # Kilotonnes to Tonnes
# Calculate CO2 per validator
validators_df["CO2_per_validator_per_epoch"] = (
    (validators_df["emissions_Tco2"] * 12) / 13
) / validators_df["total_validators"]
df = validators_df.query("'2022-05-01' <= date <= '2024-04-01'")


# %%

# Assuming your DataFrame df is already defined and includes columns for 'total_validators', 'emissions_Tco2', and 'CO2_per_validator'
height_px = 600
# Create subplots: two rows, with shared x-axis, specifying that the first row will have two y-axes
fig = make_subplots(
    rows=2,
    cols=1,
    shared_xaxes=True,
    vertical_spacing=0.1,
    subplot_titles=(
        "Total Validators and Annual network CO2 Emissions",
        "CO2 per Validator per 28 day Epoch",
    ),
    specs=[[{"secondary_y": True}], [{}]],
)  # Specifies that the first row has a secondary y-axis

# Add traces to the first subplot
# Total Validators
fig.add_trace(
    go.Scatter(
        x=df.index,
        y=df["total_validators"],
        name="Total Validators",
        mode="lines+markers",
        line=dict(color="blue"),
    ),
    row=1,
    col=1,
    secondary_y=False,
)

# Emissions trace
fig.add_trace(
    go.Scatter(
        x=df.index,
        y=df["emissions_Tco2"],
        name="Emissions (Tonnes CO2)",
        mode="lines+markers",
        line=dict(color="red"),
    ),
    row=1,
    col=1,
    secondary_y=True,
)

# Add the CO2 per validator trace to the second subplot
fig.add_trace(
    go.Scatter(
        x=df.index,
        y=df["CO2_per_validator_per_epoch"],
        name="CO2 per Validator",
        mode="lines+markers",
        line=dict(color="green"),
    ),
    row=2,
    col=1,  # Here secondary_y is False because only one y-axis is needed in the second row
)

# Update axes properties for the first subplot
fig.update_yaxes(
    title_text="Total Validators",
    secondary_y=False,
    row=1,
    col=1,
    tickfont=dict(color="blue"),
    titlefont=dict(color="blue"),
)
fig.update_yaxes(
    title_text="Ethereum Network Emissions<br>(Tonnes CO2 per Year)",
    secondary_y=True,
    row=1,
    col=1,
    tickfont=dict(color="red"),
    titlefont=dict(color="red"),
)

# Update axes properties for the second subplot
fig.update_yaxes(
    title_text="CO2 Emissions per Validator<br>(Tonnes CO2 per Epoch)",
    row=2,
    col=1,
    tickfont=dict(color="green"),
    titlefont=dict(color="green"),
)

# Update overall layout
fig.update_layout(height=height_px, showlegend=True)

fig.update_layout(
    legend=dict(
        x=0.5,  # Center the legend horizontally relative to the plot
        y=-0.1,  # Place the legend below the plot
        xanchor="center",  # Center the legend horizontally
        yanchor="top",  # Anchor the top of the legend to the specified `y`
        borderwidth=1,
        bordercolor="Black",
        bgcolor="White",
        traceorder="normal",
        orientation="h",  # Horizontal layout of legend items
    )
)


# Save plotly figures

width_px = 800
fig.write_image("figures/emissions_per_validator.png", width=width_px, height=height_px)
fig.write_html(
    "figures/emissions_per_validator.html", include_plotlyjs="cdn", full_html=False
)

# Show plot
fig.show(renderer="browser")


# %%

# Assuming your DataFrame df is already defined and includes columns for 'total_validators', 'emissions_Tco2', and 'CO2_per_validator'
height_px = 400
# Create subplots: two rows, with shared x-axis, specifying that the first row will have two y-axes
fig = make_subplots(
    rows=1,
    cols=1,
    shared_xaxes=True,
    vertical_spacing=0.1,
    subplot_titles=(
        "Total Validators and Annual network CO2 Emissions",
        "CO2 per Validator per 28 day Epoch",
    ),
    specs=[[{"secondary_y": True}]],
)  # Specifies that the first row has a secondary y-axis

# Add traces to the first subplot
# Total Validators
fig.add_trace(
    go.Scatter(
        x=df.index,
        y=df["total_validators"],
        name="Total Validators",
        mode="lines+markers",
        line=dict(color="blue"),
    ),
    row=1,
    col=1,
    secondary_y=False,
)

# Emissions trace
fig.add_trace(
    go.Scatter(
        x=df.index,
        y=df["emissions_Tco2"],
        name="Emissions (Tonnes CO2)",
        mode="lines+markers",
        line=dict(color="red"),
    ),
    row=1,
    col=1,
    secondary_y=True,
)

# Update axes properties for the first subplot
fig.update_yaxes(
    title_text="Total Validators",
    secondary_y=False,
    row=1,
    col=1,
    tickfont=dict(color="blue"),
    titlefont=dict(color="blue"),
)
fig.update_yaxes(
    title_text="Ethereum Network Emissions<br>(Tonnes CO2 per Year)",
    secondary_y=True,
    row=1,
    col=1,
    tickfont=dict(color="red"),
    titlefont=dict(color="red"),
)

# Update overall layout
fig.update_layout(height=height_px, showlegend=True)

fig.update_layout(
    legend=dict(
        x=0.5,  # Center the legend horizontally relative to the plot
        y=-0.1,  # Place the legend below the plot
        xanchor="center",  # Center the legend horizontally
        yanchor="top",  # Anchor the top of the legend to the specified `y`
        borderwidth=1,
        bordercolor="Black",
        bgcolor="White",
        traceorder="normal",
        orientation="h",  # Horizontal layout of legend items
    )
)


# Save plotly figures

width_px = 800
fig.write_image(
    "figures/emissions_per_validator_singeplot.png", width=width_px, height=height_px
)
fig.write_html(
    "figures/emissions_per_validator_singleplot.html",
    include_plotlyjs="cdn",
    full_html=False,
)

# Show plot
fig.show(renderer="browser")
