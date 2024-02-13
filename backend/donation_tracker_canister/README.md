# Donation Tracker Canister

### Setup

Install mops (https://mops.one/docs/install)
Install motoko dependencies:

```bash
mops install
```

### Deploy

We assume you already have the `backend/donation_canister` deployed.

Then you deploy the donation_tracker_canister with:

```bash
# Generate the bindings
dfx generate

# -----------------------
# During deployment, you must pass the DONATION_CANISTER_ID:
# - local     : get the canister id from the donation_canister deployment step
# - ic mainnet: "ekral-oiaaa-aaaag-acmda-cai"

# local
dfx deploy donation_tracker_canister --argument '("bkyz2-fmaaa-aaaaa-qaaaq-cai")'
dfx canister call donation_tracker_canister initRecipients

# IC mainnet
dfx deploy --ic donation_tracker_canister --argument '("ekral-oiaaa-aaaag-acmda-cai")'
dfx canister --ic call donation_tracker_canister initRecipients

```

### Test with pytest

**Create a conda environment**

```bash
conda create --name 2024SABH python=3.10
conda activate 2024SABH

pip install -r requirements.txt
```

**Run tests**

Run the tests with the same identity that you used to deploy the canister.
Your identity must be a controller for some of the tests:

```bash
# local
pytest

# ic mainnet
pytest --network ic
```