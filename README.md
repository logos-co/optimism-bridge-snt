# Bridging SNT with the Optimism SDK

This repository contains code to deploy SNT in Ethereum and bridge it to optimism.

Scripts:

`npx hardhat run scripts/deploySNT.js --network <network>` -> deploy to Optimism chain with the `contracts.json` configured addresses.

`npx hardhat run scripts/deployOptimism.js --network <network>` -> deploy to an optimism chain with the `contracts.json` configured addresses.

The script `node index.js` uses the configured goerli bridge to bridge 1 STT on Goerli into 1 SNT on Optimism-Goerli.

To everything work, .env needs to be created out of .env.example.

All tokens, even on Optimism, are MiniMeToken variant, meaning they save all account's balance change on Ethereum state for democracy contract ballots. Learn more about MiniMeToken on the official repository [Giveth/minime](https://github.com/Giveth/minime).