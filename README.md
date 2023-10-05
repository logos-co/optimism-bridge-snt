# Bridging SNT with the Optimism SDK

This repository contains code to deploy SNT in Ethereum and bridge it to optimism.

Scripts:

```
$ MNEMONIC=$YOUR_MNEMONIC forge script script/DeployBridge.s.sol --fork-url $YOUR_RPC_URL --broadcast
```

Where

- `$YOUR_MNEMONIC` is the mnemonic that contains the account from which you want to deploy. The deploy script will use
  the first account derived from the mnemonic by default.
- `$YOUR_RPC_URL` is the RPC endpoint of the node you're connecting to.

You can omit the `--broadcast` option to simulate the deployment before actually performing it.

All tokens, even on Optimism, are [MiniMeToken variant](https://github.com/vacp2p/minime), meaning they save all
account's balance change on Ethereum state for democracy contract ballots. Learn more about MiniMeToken on the official
repository [vacpp2p/minime](https://github.com/vacp2p/minime).

# Differences from regular MiniMeToken

The MiniMeToken used in this repository is a fork of [the original](https://github.com/Giveth/minime). To learn about
the differences between the fork and the upstream repository, head over to its
[documentation](https://github.com/vacp2p/minime#readme).

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
