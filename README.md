[![codecov](https://codecov.io/gh/logos-co/optimism-bridge-snt/graph/badge.svg?token=T28C0VOKJC)](https://codecov.io/gh/logos-co/optimism-bridge-snt)

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

1. MiniMeToken uses generateTokens and destroyTokens operated by controller for mint and burn. OptimismMintableMiniMeToken uses mint and burn operated by bridge. 
2. MiniMeToken `version()` had to be renamed to `token_version()` due a conflict on inheritance and requirements of
   Optimism. Semver inheritance uses version() and this seems a requirement for Optimism.
