// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <=0.9.0;

import { MiniMeBase } from "@vacp2p/minime/contracts/MiniMeBase.sol";
import { BaseScript } from "./Base.s.sol";
import { DeploymentConfig } from "./DeploymentConfig.s.sol";
import { OptimismMintableMiniMeToken } from "../contracts/optimism/OptimismMintableMiniMeToken.sol";
import { SNTPlaceHolder } from "../contracts/SNTPlaceHolder.sol";

contract DeployBridge is BaseScript {
    function run() public returns (DeploymentConfig, OptimismMintableMiniMeToken, SNTPlaceHolder) {
        DeploymentConfig deploymentConfig = new DeploymentConfig(broadcaster);
        (
            address deployer,
            address bridgeAddress,
            address remoteTokenAddress,
            address parentTokenAddress,
            uint256 parentSnapShotBlock,
            string memory tokenName,
            uint8 decimals,
            string memory tokenSymbol,
            bool transferEnabled
        ) = deploymentConfig.activeNetworkConfig();

        vm.startBroadcast(deployer);
        OptimismMintableMiniMeToken bridgeToken = new OptimismMintableMiniMeToken(
            bridgeAddress,
            remoteTokenAddress,
            MiniMeBase(payable(parentTokenAddress)),
            parentSnapShotBlock,
            tokenName,
            decimals,
            tokenSymbol,
            transferEnabled
        );
        SNTPlaceHolder tokenController = new SNTPlaceHolder(payable(address(bridgeToken)));
        bridgeToken.changeController(payable(address(tokenController)));
        vm.stopBroadcast();
        return (deploymentConfig, bridgeToken, tokenController);
    }
}
