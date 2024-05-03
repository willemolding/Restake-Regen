import requests
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime, timedelta


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


# %%
# Create Total Validators Dataframe
validators_df = pd.DataFrame(all_data)

# Group by month and sum the validators count
validators_df = validators_df.groupby("date")["validators"].sum()

# Convert to DataFrame
validators_df = validators_df.reset_index()
validators_df["date"] = pd.to_datetime(validators_df["date"])
validators_df["total_validators"] = validators_df["validators"].cumsum()

# Plot
plt.figure(figsize=(10, 5))
plt.plot(validators_df["date"], validators_df["total_validators"])
plt.title("Number of Validators Over Time")
plt.xlabel("Date")
plt.ylabel("Number of Validators")
plt.grid(True)
plt.show()
