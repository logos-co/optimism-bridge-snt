// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { DeployBridge } from "../script/DeployBridge.s.sol";
import { DeploymentConfig } from "../script/DeploymentConfig.s.sol";

import { SNTOptimismController } from "../contracts/SNTOptimismController.sol";
import { OptimismMintableMiniMeToken } from "../contracts/optimism/OptimismMintableMiniMeToken.sol";

import { MiniMeToken } from "@vacp2p/minime/contracts/MiniMeToken.sol";

contract SNTOptimismControllerTest is Test {
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
        assertEq(address(tokenController.snt()), address(bridgeToken));
    }
}

contract ChangeControllerTest is SNTOptimismControllerTest {
    function setUp() public virtual override {
        SNTOptimismControllerTest.setUp();
    }

    function test_changeController() public {
        address payable newController = payable(address(0x123));
        vm.prank(tokenController.owner());
        tokenController.changeController(newController);
        assertEq(bridgeToken.controller(), newController);
    }
}

contract ClaimTokensTest is SNTOptimismControllerTest {
    function setUp() public virtual override {
        SNTOptimismControllerTest.setUp();
    }

    function test_ClaimERC20() public {
        vm.pauseGasMetering();
        vm.startPrank(tokenController.owner());
        MiniMeToken claimTest = new MiniMeToken(MiniMeToken(payable(address(0))), 0, "TestClaim", 18, "TST", true);
        claimTest.generateTokens(address(tokenController), 1234);

        assertEq(
            claimTest.balanceOf(address(tokenController)), 1234, "claimTest tokenController balance should be correct"
        );
        assertEq(claimTest.balanceOf(address(deployer)), 0, "claimTest deployer balance should be correct");

        vm.resumeGasMetering();
        tokenController.claimTokens(claimTest);
        vm.pauseGasMetering();

        vm.stopPrank();

        assertEq(
            claimTest.balanceOf(address(tokenController)), 0, "claimTest tokenController balance should be correct"
        );
        assertEq(claimTest.balanceOf(address(deployer)), 1234, "claimTest deployer balance should be correct");
        vm.resumeGasMetering();
    }

    function test_ClaimETH() public {
        vm.pauseGasMetering();
        vm.startPrank(tokenController.owner());
        vm.deal(address(tokenController), 1234);
        assertEq(address(tokenController).balance, 1234, "tokenController balance should be correct");
        assertEq(address(deployer).balance, 0, "deployer balance should be correct");

        vm.resumeGasMetering();
        tokenController.claimTokens(MiniMeToken(payable(address(0))));
        vm.pauseGasMetering();

        assertEq(address(tokenController).balance, 0, "tokenController balance should be correct");
        assertEq(address(deployer).balance, 1234, "deployer balance should be correct");

        vm.stopPrank();
        vm.resumeGasMetering();
    }
}

contract OnTransferTest is SNTOptimismControllerTest {
    function setUp() public virtual override {
        SNTOptimismControllerTest.setUp();
    }

    function test_onTransfer() public {
        assertEq(tokenController.onTransfer(address(0), address(0), 0), true);
    }
}

contract OnApproveTest is SNTOptimismControllerTest {
    function setUp() public virtual override {
        SNTOptimismControllerTest.setUp();
    }

    function test_onApprove() public {
        assertEq(tokenController.onApprove(address(0), address(0), 0), true);
    }
}

contract ProxyPaymentTest is SNTOptimismControllerTest {
    function setUp() public virtual override {
        SNTOptimismControllerTest.setUp();
    }

    function test_proxyPayment() public {
        assertEq(tokenController.proxyPayment(address(0)), false);
    }
}
