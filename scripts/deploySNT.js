// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const mainnet = network.config.chainId == 1

  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts to ${network.name} (${network.config.chainId}) with the account: ${deployer.address}`);
  const miniMeTokenFactory = await ethers.deployContract("MiniMeTokenFactory");
  await miniMeTokenFactory.waitForDeployment();
  const miniMeToken = await ethers.deployContract(
    optimism ? "MintableMiniMeTokenOptimism" : "MiniMeToken", (optimism ? [] : []).concat([
      miniMeTokenFactory.target,
      ethers.ZeroAddress,
      0,
      mainnet ? "Status Network Token" :  "Status Test Token",
      18,
      mainnet ? "SNT" : "STT",
      true
    ]));
  await miniMeToken.waitForDeployment();
  const tokenController = await ethers.deployContract(
    mainnet ? "SNTPlaceHolder" : "SNTFaucet",
    [
      deployer.address,
      miniMeToken.target
    ]
  );
  await tokenController.waitForDeployment();
  await miniMeToken.changeController(tokenController.target);

  console.log(
    `${mainnet ? "SNT" : "STT"} ${miniMeToken.target} controlled by ${await miniMeToken.controller()}`
  );
  console.log(
    `${mainnet ? "SNTPlaceHolder" : "SNTFaucet"} ${tokenController.target} owned by ${await tokenController.owner()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
