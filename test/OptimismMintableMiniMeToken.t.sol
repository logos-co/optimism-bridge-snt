// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { DeployBridge } from "../script/DeployBridge.s.sol";
import { DeploymentConfig } from "../script/DeploymentConfig.s.sol";

import { OptimismMintableMiniMeToken } from "../contracts/optimism/OptimismMintableMiniMeToken.sol";
import { SNTPlaceHolder } from "../contracts/SNTPlaceHolder.sol";

contract OptmismMintableMiniMeTokenTest is Test {
    DeploymentConfig internal deploymentConfig;
    SNTPlaceHolder internal tokenController;
    OptimismMintableMiniMeToken internal bridgeToken;

    address internal deployer;

    function setUp() public virtual {
        DeployBridge deployment = new DeployBridge();
        (deploymentConfig, bridgeToken, tokenController) = deployment.run();
        (deployer,,,,,,,,) = deploymentConfig.activeNetworkConfig();
    }

    function testDeployment() public {
        (
            ,
            address _bridgeAddress,
            address _remoteTokenAddress,
            address _parentTokenAddress,
            uint256 _parentSnapShotBlock,
            string memory _tokenName,
            uint8 _decimals,
            string memory _tokenSymbol,
            bool _transferEnabled
        ) = deploymentConfig.activeNetworkConfig();

        assertEq(bridgeToken.controller(), address(tokenController));
        assertEq(bridgeToken.l2Bridge(), _bridgeAddress);
        assertEq(bridgeToken.bridge(), _bridgeAddress);
        assertEq(bridgeToken.l1Token(), _remoteTokenAddress);
        assertEq(bridgeToken.remoteToken(), _remoteTokenAddress);

        assertEq(address(bridgeToken.parentToken()), _parentTokenAddress);
        assertEq(bridgeToken.parentSnapShotBlock(), _parentSnapShotBlock);
        assertEq(bridgeToken.name(), _tokenName);
        assertEq(bridgeToken.decimals(), _decimals);
        assertEq(bridgeToken.symbol(), _tokenSymbol);
        assertEq(bridgeToken.transfersEnabled(), _transferEnabled);
    }
}
