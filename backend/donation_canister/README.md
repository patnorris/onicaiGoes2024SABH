# Donation Canister

This canister is a slightly modified version of [basic_bitcoin](https://github.com/dfinity/examples/tree/master/motoko/basic_bitcoin) smart contract, which leverages the [ECDSA API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-ecdsa_public_key)
and [Bitcoin API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-bitcoin-api) of the Internet Computer.


## Step 0: Set up a local Bitcoin network

- Install the [IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install/index.mdx).
- [Set up a local Bitcoin network](https://internetcomputer.org/docs/current/tutorials/developer-journey/level-4/4.3-ckbtc-and-bitcoin/#setting-up-a-local-bitcoin-network):

  NOTE: On mac I have not been able to get it to run, due to security checks...

  ```bash
  # On linux, you can run
  make install-bitcoin-core

  # then start it with:
  make bitcoin-core-start
  ```

## Step 1: Building and deploying donations canister

### Clone the repository

```bash
git clone https://github.com/patnorris/onicaiGoes2024SABH

# initialize the submodules
cd onicaiGoes2024SABH
git submodule update --init --recursive

cd backend/donation_canister
```

Note on the submodule:

- The donation_canister depends on [motoko-bitcoin](https://github.com/tgalal/motoko-bitcoin)
- I added it to the repo as a submodule with:
  ```bash
  # from root of repository
  git submodule add https://github.com/tgalal/motoko-bitcoin.git motoko-bitcoin
  ```

### Create a conda environment

Not yet needed really, but I anticipate writing python test scripts

```bash
conda create --name 2024SABH python=3.10
conda activate 2024SABH

pip install -r requirements.txt
```

### Local Network

We use multiple canisters that we deploy separately on a shared local network. Create a file `~/.config/dfx/networks.json` to enable sharing of the local bitcoin canister:

File: ~/.config/dfx/networks.json
Note: log_level options are: "critical", "error", "warning", "info", "debug", "trace"

```json
{
  "local": {
    "bitcoin": {
      "enabled": true,
      "log_level": "error",
      "nodes": ["127.0.0.1:18444"]
    }
  }
}
```

### Deploy donation_canister locally

[Reference](https://internetcomputer.org/docs/current/tutorials/developer-journey/level-4/4.3-ckbtc-and-bitcoin/#deploying-the-example-canister)

```bash
# From the bitcoin-25.0 folder, start the local bitcoin instance
./bin/bitcoind -conf=$(pwd)/bitcoin.conf -datadir=$(pwd)/data --port=18444

# Start the local dfx network
dfx start --clean

# From the backend/donation_canister folder:
dfx deploy donation_canister --argument '(variant { regtest })'

# Add the donation_tracker_canister as a controller, for access to the `send` method
dfx canister update-settings --add-controller be2us-64aaa-aaaaa-qaabq-cai donation_canister

# Generate the bindings used by the frontend
dfx generate
```

### Exercise it with dfx

```bash
# generate a P2PKH address
$ dfx canister call donation_canister get_p2pkh_address
("mkkzk2xTQcrrRYv8FPnj22ujHhkZwsETtX")

# receiving BTC
# From bitcoin-25.0 issue this command, replacing BTC_ADDRESS with yours
./bin/bitcoin-cli -conf=$(pwd)/bitcoin.conf generatetoaddress 1 BTC_ADDRESS
# eg.
$ ./bin/bitcoin-cli -conf=$(pwd)/bitcoin.conf generatetoaddress 1 mkkzk2xTQcrrRYv8FPnj22ujHhkZwsETtX
[
  "220f4001f27c9d1c274eb0cf85419815bba0bb6ebd9d0e09a84003651ecea151"
]

# check your BTC balance
dfx canister call donation_canister get_balance '("BTC_ADDRESS")'
# eg.
$ dfx canister call donation_canister get_balance '("mkkzk2xTQcrrRYv8FPnj22ujHhkZwsETtX")'
(5_000_000_000 : nat64)
```

---

### Deploy donation_canister to the Internet Computer

```bash
dfx deploy --network=ic -m reinstall donation_canister --argument '(variant { testnet })'

# Add the donation_tracker_canister as a controller, for access to the `send` method
dfx canister --network=ic update-settings --add-controller fj5jn-2qaaa-aaaag-acmfq-cai donation_canister
```

#### What this does

- `dfx deploy` tells the command line interface to `deploy` the smart contract
- `--network=ic` tells the command line to deploy the smart contract to the mainnet ICP blockchain
- `--argument '(variant { testnet })'` passes the argument `Testnet` to initialize the smart contract, telling it to connect to the Bitcoin testnet

**We're initializing the canister with `variant { testnet }`, so that the canister connects to the the [Bitcoin testnet](https://en.bitcoin.it/wiki/Testnet). To be specific, this connects to `Testnet3`, which is the current Bitcoin test network used by the Bitcoin community.**

If successful, you should see an output that looks like this:

```bash
Deploying: donation_canister
Building canisters...
...
Deployed canisters.
URLs:
Candid:
    donation_canister: https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=<YOUR-CANISTER-ID>
```

Your canister is live and ready to use! You can interact with it using either the command line, or using the Candid UI, which is the link you see in the output above.

In the output above, to see the Candid Web UI for your bitcoin canister, you would use the URL `https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=<YOUR-CANISTER-ID>`. Here are the two methods you will see:

- `public_key`
- `sign`

## Step 2: Generating a Bitcoin address

Bitcoin has different types of addresses (e.g. P2PKH, P2SH). Most of these
addresses can be generated from an ECDSA public key. The example code
showcases how your canister can generate a [P2PKH address](https://en.bitcoin.it/wiki/Transaction#Pay-to-PubkeyHash) using the [ecdsa_public_key](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-ecdsa_public_key) API.

On the Candid UI of your canister, click the "Call" button under `get_p2pkh_address` to
generate a P2PKH Bitcoin address.

Or, if you prefer the command line:

```bash
dfx canister --network=ic call donation_canister get_p2pkh_address
```

- The Bitcoin address you see will be different from the one above, because the
  ECDSA public key your canister retrieves is unique.

- We are generating a Bitcoin testnet address, which can only be
  used for sending/receiving Bitcoin on the Bitcoin testnet.

## Step 3: Receiving bitcoin

Now that the canister is deployed and you have a Bitcoin address, it's time to receive
some testnet bitcoin. You can use one of the Bitcoin faucets, such as [coinfaucet.eu](https://coinfaucet.eu),
to receive some bitcoin.

Enter your address and click on "Send testnet bitcoins". In the example below we will use Bitcoin address `n31eU1K11m1r58aJMgTyxGonu7wSMoUYe7`, but you would use your own address. The canister will be receiving 0.011 test BTC on the Bitcoin Testnet.

Once the transaction has at least one confirmation, which can take a few minutes,
you'll be able to see it in your canister's balance.

## Step 4: Checking your bitcoin balance

You can check a Bitcoin address's balance by using the `get_balance` endpoint on your canister.

In the Candid UI, paste in your canister's address, and click on "Call".

Alternatively, make the call using the command line. Be sure to replace `mheyfRsAQ1XrjtzjfU1cCH2B6G1KmNarNL` with your own generated P2PKH address:

```bash
dfx canister --network=ic call donation_canister get_balance '("mheyfRsAQ1XrjtzjfU1cCH2B6G1KmNarNL")'
```

Checking the balance of a Bitcoin address relies on the [bitcoin_get_balance](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-bitcoin_get_balance) API.

## Step 5: Sending bitcoin

You can send bitcoin using the `send` endpoint on your canister.

In the Candid UI, add a destination address and an amount to send. In the example
below, we're sending 4'321 Satoshi (0.00004321 BTC) back to the testnet faucet.

Via command line, the same call would look like this:

```bash
dfx canister --network=ic call donation_canister send '(record { destination_address = "tb1ql7w62elx9ucw4pj5lgw4l028hmuw80sndtntxt"; amount_in_satoshi = 4321; })'
```

The `send` endpoint is able to send bitcoin by:

1. Getting the percentiles of the most recent fees on the Bitcoin network using the [bitcoin_get_current_fee_percentiles API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-bitcoin_get_current_fee_percentiles).
2. Fetching your unspent transaction outputs (UTXOs), using the [bitcoin_get_utxos API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-bitcoin_get_utxos).
3. Building a transaction, using some of the UTXOs from step 2 as input and the destination address and amount to send as output.
   The fee percentiles obtained from step 1 is used to set an appropriate fee.
4. Signing the inputs of the transaction using the [sign_with_ecdsa API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-sign_with_ecdsa).
5. Sending the signed transaction to the Bitcoin network using the [bitcoin_send_transaction API](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-bitcoin_send_transaction).

The `send` endpoint returns the ID of the transaction it sent to the network.
You can track the status of this transaction using a block explorer. Once the
transaction has at least one confirmation, you should be able to see it
reflected in your current balance.

## References

- [basic_bitcoin](https://github.com/dfinity/examples/tree/master/motoko/basic_bitcoin)
- [bitcoin-integration](https://internetcomputer.org/how-it-works/bitcoin-integration/)
- [ckbtc-and-bitcoin](https://internetcomputer.org/docs/current/tutorials/developer-journey/level-4/4.3-ckbtc-and-bitcoin/)
- [Deploying your first Bitcoin dapp](https://internetcomputer.org/docs/current/samples/deploying-your-first-bitcoin-dapp).
- [Developing Bitcoin dapps locally](https://internetcomputer.org/docs/current/developer-docs/integrations/bitcoin/local-development).