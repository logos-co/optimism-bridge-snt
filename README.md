# Bridging SNT with the Optimism SDK

This repository contains code to deploy SNT in Ethereum and bridge it to optimism.

Scripts:

`npx hardhat run scripts/deploySNT.js --network <network>` -> deploy to Optimism chain with the `contracts.json`
configured addresses.

`npx hardhat run scripts/deployOptimism.js --network <network>` -> deploy to an optimism chain with the `contracts.json`
configured addresses.

The script `node index.js` uses the configured goerli bridge to bridge 1 STT on Goerli into 1 SNT on Optimism-Goerli.

To everything work, .env needs to be created out of .env.example.

All tokens, even on Optimism, are MiniMeToken variant, meaning they save all account's balance change on Ethereum state
for democracy contract ballots. Learn more about MiniMeToken on the official repository
[Giveth/minime](https://github.com/Giveth/minime).

# Differences from regular MiniMeToken

1. There are 2 functions to mint/burn, one is mint() & generateTokens(), and other is burn() & destroyTokens(). One come
   from MiniMeToken inheritance, and other comes from IOptimismMintableERC20 inheritance. See more on point 2.
2. MiniMeToken controller (SNTPlaceHolder) is also deployed on Optimism, and it _could_ be replaced by another
   controller that _could_ call generateToken function, potentially breaking the bridge, however, if we don't do this
   change, than it should be fine.
3. MiniMeTokenFactory used in createCloneToken create new MiniMeTokens that are one inheritance down from
   OptimismMintableMiniMeToken, this is fine, just strange, but it couldnt be different, as clone tokens are not
   suppoused to be minted by bridge. This function is not even used by us.
4. MiniMeToken `version()` had to be renamed to `token_version()` due a conflict on inheritance and requirements of
   Optimism. Semver inheritance uses version() and this seems a requirement for Optimism.
