// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { DeployBridge } from "../script/DeployBridge.s.sol";
import { DeploymentConfig } from "../script/DeploymentConfig.s.sol";

import { OptimismMintableMiniMeToken } from "../contracts/optimism/OptimismMintableMiniMeToken.sol";
import { SNTOptimismController } from "../contracts/SNTOptimismController.sol";

import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { ILegacyMintableERC20, IOptimismMintableERC20 } from "../contracts/optimism/IOptimismMintableERC20.sol";

contract OptmismMintableMiniMeTokenTest is Test {
    DeploymentConfig internal deploymentConfig;
    SNTOptimismController internal tokenController;
    OptimismMintableMiniMeToken internal bridgeToken;

    address internal deployer;

    address internal bridgeAddress;

    function setUp() public virtual {
        DeployBridge deployment = new DeployBridge();
        (deploymentConfig, bridgeToken, tokenController) = deployment.run();
        (deployer, bridgeAddress,,,,,,,) = deploymentConfig.activeNetworkConfig();
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
        assertEq(bridgeToken.version(), "1.0.1");
    }
}

contract ERC165Test is OptmismMintableMiniMeTokenTest {
    function setUp() public override {
        OptmismMintableMiniMeTokenTest.setUp();
    }

    function test_supportInterface() public {
        assertEq(bridgeToken.supportsInterface(type(IOptimismMintableERC20).interfaceId), true);
        assertEq(bridgeToken.supportsInterface(type(ILegacyMintableERC20).interfaceId), true);
        assertEq(bridgeToken.supportsInterface(type(IERC165).interfaceId), true);
    }
}

contract MintTest is OptmismMintableMiniMeTokenTest {
    event Mint(address indexed account, uint256 amount);

    function setUp() public override {
        OptmismMintableMiniMeTokenTest.setUp();
    }

    function test_RevertWhen_SenderIsNotBridge() public {
        vm.expectRevert(OptimismMintableMiniMeToken.OptimismMintableMiniMeToken_SenderNotBridge.selector);
        bridgeToken.mint(makeAddr("receiver"), 100);
    }

    function test_Mint() public {
        address receiver = makeAddr("receiver");

        vm.prank(bridgeAddress);
        vm.expectEmit(true, true, true, true);
        emit Mint(receiver, 100);
        bridgeToken.mint(receiver, 100);

        assertEq(bridgeToken.balanceOf(receiver), 100);
    }
}

contract BurnTest is OptmismMintableMiniMeTokenTest {
    event Burn(address indexed account, uint256 amount);

    function setUp() public override {
        OptmismMintableMiniMeTokenTest.setUp();
    }

    function test_RevertWhen_SenderIsNotBridge() public {
        vm.expectRevert(OptimismMintableMiniMeToken.OptimismMintableMiniMeToken_SenderNotBridge.selector);
        bridgeToken.burn(makeAddr("holder"), 100);
    }

    function test_Burn() public {
        address holder = makeAddr("holder");

        vm.prank(bridgeAddress);
        bridgeToken.mint(holder, 100);
        assertEq(bridgeToken.balanceOf(holder), 100);

        vm.prank(bridgeAddress);
        vm.expectEmit(true, true, true, true);
        emit Burn(holder, 100);
        bridgeToken.burn(holder, 100);

        assertEq(bridgeToken.balanceOf(holder), 0);
    }
}
