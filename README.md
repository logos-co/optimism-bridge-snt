[![codecov](https://codecov.io/gh/logos-co/optimism-bridge-snt/graph/badge.svg?token=T28C0VOKJC)](https://codecov.io/gh/logos-co/optimism-bridge-snt)

# Bridging SNT with the Optimism SDK

This repository contains code to deploy SNT in Ethereum and bridge it to optimism.

# Deployments

| **Contract**                | **Address**                                                                                                                                     | **Snapshot**                                                                                                 |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Optimism Mainnet**        |                                                                                                                                                 |                                                                                                              |
| OptimismMintableMiniMeToken | [`0x650AF3C15AF43dcB218406d30784416D64Cfb6B2`](https://optimistic.etherscan.io/address/0x650AF3C15AF43dcB218406d30784416D64Cfb6B2)              | [`1b3159a`](https://github.com/logos-co/optimism-bridge-snt/commit/1b3159ad4113378d95452866c0c43ca19a05aadd) |
| SNTOptimismController       | [`0x76352764590378011CAE677b50110Ae02eDE2b62`](https://optimistic.etherscan.io/address/0x76352764590378011CAE677b50110Ae02eDE2b62#readContract) | [`1b3159a`](https://github.com/logos-co/optimism-bridge-snt/commit/1b3159ad4113378d95452866c0c43ca19a05aadd) |
| **Optimism Goerli**         |                                                                                                                                                 |                                                                                                              |
| OptimismMintableMiniMeToken | [`0xcAD273fA2bb77875333439FDf4417D995159c3E1`](https://goerli-optimism.etherscan.io/address/0xcAD273fA2bb77875333439FDf4417D995159c3E1)         | [`dc28b89`](https://github.com/logos-co/optimism-bridge-snt/commit/dc28b89d6af0b8f48397b3efaea5e338496e40eb) |
| SNTOptimismController       | [`0x650AF3C15AF43dcB218406d30784416D64Cfb6B2`](https://goerli-optimism.etherscan.io/address/0x650AF3C15AF43dcB218406d30784416D64Cfb6B2)         | [`dc28b89`](https://github.com/logos-co/optimism-bridge-snt/commit/dc28b89d6af0b8f48397b3efaea5e338496e40eb) |
| **Optimism Sepolia**        |                                                                                                                                                 |                                                                                                              |
| OptimismMintableMiniMeToken | [`0x650AF3C15AF43dcB218406d30784416D64Cfb6B2`](https://optimistic.etherscan.io/address/0x650AF3C15AF43dcB218406d30784416D64Cfb6B2)              | [`1b3159a`](https://github.com/logos-co/optimism-bridge-snt/commit/1b3159ad4113378d95452866c0c43ca19a05aadd) |
| SNTOptimismController       | [`0x76352764590378011CAE677b50110Ae02eDE2b62`](https://optimistic.etherscan.io/address/0x76352764590378011CAE677b50110Ae02eDE2b62#readContract) | [`1b3159a`](https://github.com/logos-co/optimism-bridge-snt/commit/1b3159ad4113378d95452866c0c43ca19a05aadd) |
| **Optimism Goerli**         |                                                                                                                                                 |                                                                                                              |
| OptimismMintableMiniMeToken | [`0x0B5DAd18B8791ddb24252B433ec4f21f9e6e5Ed0`](https://optimism-sepolia.blockscout.com/address/0x0B5DAd18B8791ddb24252B433ec4f21f9e6e5Ed0)      | [`b6f50cf`](https://github.com/logos-co/optimism-bridge-snt/commit/b6f50cff2daf7552d88dea2c1d9fa41f2b46acf1) |
| SNTOptimismController       | [`0x35Cded11D75cC10d38ED4456b8caDC9F36E85E42`](https://optimism-sepolia.blockscout.com/address/0x35Cded11D75cC10d38ED4456b8caDC9F36E85E42)      | [`b6f50cf`](https://github.com/logos-co/optimism-bridge-snt/commit/b6f50cff2daf7552d88dea2c1d9fa41f2b46acf1) |

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
