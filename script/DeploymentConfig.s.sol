//// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.19 <=0.9.0;

import { Script } from "forge-std/Script.sol";

contract DeploymentConfig is Script {
    error DeploymentConfig_InvalidDeployerAddress();
    error DeploymentConfig_NoConfigForChain(uint256);

    struct NetworkConfig {
        address deployer;
        address bridgeAddress;
        address remoteTokenAddress;
        address parentTokenAddress;
        uint256 parentSnapShotBlock;
        string tokenName;
        uint8 decimals;
        string tokenSymbol;
        bool transferEnabled;
    }

    NetworkConfig public activeNetworkConfig;

    address private deployer;

    // solhint-disable-next-line var-name-mixedcase
    address internal SNT_ADDRESS_MAINNET = 0x744d70FDBE2Ba4CF95131626614a1763DF805B9E;
    // solhint-disable-next-line var-name-mixedcase
    address internal SNT_ADDRESS_GOERLI = 0x3D6AFAA395C31FCd391fE3D562E75fe9E8ec7E6a;
    // solhint-disable-next-line var-name-mixedcase
    address internal SNT_ADDRESS_SEPOLIA = 0xE452027cdEF746c7Cd3DB31CB700428b16cD8E51;
    // solhint-disable-next-line var-name-mixedcase
    address internal STANDARD_BRIDGE_ADDRESS = 0x4200000000000000000000000000000000000010;

    constructor(address _broadcaster) {
        if (_broadcaster == address(0)) revert DeploymentConfig_InvalidDeployerAddress();
        deployer = _broadcaster;
        if (block.chainid == 31_337) {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else if (block.chainid == 11_155_420) {
            activeNetworkConfig = getOptimismSepoliaConfig();
        } else if (block.chainid == 420) {
            activeNetworkConfig = getOptimismGoerliConfig();
        } else if (block.chainid == 10) {
            activeNetworkConfig = getOptimismConfig();
        } else {
            revert DeploymentConfig_NoConfigForChain(block.chainid);
        }
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        address mockBridgeAddress = makeAddr("mockBridgeAddress");
        address mockRemoteTokenAddress = makeAddr("mockRemoteTokenAddress");

        return NetworkConfig({
            deployer: deployer,
            bridgeAddress: mockBridgeAddress,
            remoteTokenAddress: mockRemoteTokenAddress,
            parentTokenAddress: address(0),
            parentSnapShotBlock: 0,
            tokenName: "Status Test Token",
            decimals: 18,
            tokenSymbol: "SNT",
            transferEnabled: true
        });
    }

    function getOptimismGoerliConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployer: deployer,
            bridgeAddress: STANDARD_BRIDGE_ADDRESS,
            remoteTokenAddress: SNT_ADDRESS_GOERLI,
            parentTokenAddress: address(0),
            parentSnapShotBlock: 0,
            tokenName: "Status Test Token",
            decimals: 18,
            tokenSymbol: "STT",
            transferEnabled: true
        });
    }

    function getOptimismSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployer: deployer,
            bridgeAddress: STANDARD_BRIDGE_ADDRESS,
            remoteTokenAddress: SNT_ADDRESS_SEPOLIA,
            parentTokenAddress: address(0),
            parentSnapShotBlock: 0,
            tokenName: "Status Test Token",
            decimals: 18,
            tokenSymbol: "STT",
            transferEnabled: true
        });
    }

    function getOptimismConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            deployer: deployer,
            bridgeAddress: STANDARD_BRIDGE_ADDRESS,
            remoteTokenAddress: SNT_ADDRESS_MAINNET,
            parentTokenAddress: address(0),
            parentSnapShotBlock: 0,
            tokenName: "Status Network Token",
            decimals: 18,
            tokenSymbol: "SNT",
            transferEnabled: true
        });
    }

    // This function is a hack to have it excluded by `forge coverage` until
    // https://github.com/foundry-rs/foundry/issues/2988 is fixed.
    // See: https://github.com/foundry-rs/foundry/issues/2988#issuecomment-1437784542
    // for more info.
    // solhint-disable-next-line
    function test() public { }
}
