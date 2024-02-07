# Bitcoin Donation App

# Development & Deployment
## Running the project locally
If you want to test your project locally, you can use the following commands:

1. Install dependencies
```bash
npm install
```

2. Follow the instructions in the backend canisters' Readmes

3. Start the local replica (if you haven't started it yet)
```bash
npm run dev
```

Note: this starts a replica which includes the canisters state stored from previous sessions.
If you want to start a clean local IC replica (i.e. all canister state is erased) run instead:
```bash
npm run erase-replica
```

4. Deploy your canisters to the replica
```bash
dfx generate
dfx deploy
```
--> Access frontend at http://localhost:4943/?canisterId=ryjl3-tyaaa-aaaaa-aaaba-cai

Needs to be redeployed after every change to reflect changes

Alternative: Run a local vite UI (note that this had issues communicating to the backend canister for some setups in the past)
```bash
npm run vite
```
--> runs on port 3000; access routes like "http://172.30.141.44:3000/#/route" (same as on Mainnet)

Hot reloads with every UI change

## Deployment to the Internet Computer
```bash
npm install

dfx start --background
```

Deploy to Mainnet (live IC):
Ensure that all changes needed for Mainnet deployment have been made (e.g. define HOST in store.ts)

Production Canisters:
```bash
dfx deploy --network ic donation_frontend
```

In case there are authentication issues, you could try this command
(Note that only authorized identities which are set up as canister controllers may deploy the production canisters)
```bash
dfx deploy --network ic --wallet "$(dfx identity --network ic get-wallet)"
```

# Additional Notes
## Cycles for Production Canisters
Fund wallet with cycles (from ICP): https://medium.com/dfinity/internet-computer-basics-part-3-funding-a-cycles-wallet-a724efebd111

Top up cycles:
```bash
dfx identity --network=ic get-wallet
dfx wallet --network ic balance
dfx canister --network ic status donation_frontend
dfx canister --network ic --wallet 3v5vy-2aaaa-aaaai-aapla-cai deposit-cycles 300000000000 donation_frontend
```
