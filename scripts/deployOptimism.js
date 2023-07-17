const hre = require("hardhat");
require('dotenv').config()

async function main() {
  const mainnet = network.config.chainId == 10;
  const bridgeAddress = "0x4200000000000000000000000000000000000010";//standard bridge
  const remoteToken = mainnet ? process.env.MAINNET_L1_ADDRESS : "0xd55245e63bDafAabac2530F70074A36D7899Ed72";

  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts to ${network.name} (${network.config.chainId}) with the account: ${deployer.address}`);
  
  //
  const miniMeTokenFactory = await (await ethers.getContractFactory("MiniMeTokenFactory")).attach("0x86e5c5c884740894644dad30021aaaade2b7babd") /*ethers.deployContract("MiniMeTokenFactory");
  await miniMeTokenFactory.waitForDeployment();*/
  
  //0x2b3845b982b147a0436e3766eae06936f4e271a0
  const miniMeToken = await (await ethers.getContractFactory("OptimismMintableMiniMeToken")).attach("0x2b3845b982b147a0436e3766eae06936f4e271a0");/*ethers.deployContract(
    "OptimismMintableMiniMeToken", [
      bridgeAddress,
      remoteToken,
      miniMeTokenFactory.target,
      ethers.ZeroAddress,
      0,
      mainnet ? "Status Network Token" :  "Status Test Token",
      18,
      mainnet ? "SNT" : "STT",
      true
    ]);
  await miniMeToken.waitForDeployment();*/

  // 
  const tokenController = await (await ethers.getContractFactory("SNTPlaceHolder")).attach("0x4Ef81bDfcbb003442869B53Bf81168c12e1746A8")/*ethers.deployContract(
    "SNTPlaceHolder", //we should never mint STT on optimism, that should be done by bridge only
    [
      deployer.address,
      miniMeToken.target
    ]
  );
  await tokenController.waitForDeployment();*/
  await miniMeToken.changeController(tokenController.target);
  console.log(
    `npx hardhat verify ${miniMeTokenFactory.target} `
  )
  console.log(
    `npx hardhat verify ${miniMeToken.target} ${bridgeAddress} ${remoteToken} ${miniMeTokenFactory.target} ${ethers.ZeroAddress} ${0} ${mainnet ? "Status Network Token" :  "Status Test Token"} ${18} ${mainnet ? "SNT" : "STT"} ${true}`
  )
  console.log(
    `npx hardhat verify ${tokenController.target} ${deployer.address} ${miniMeToken.target} `
  )
  
  console.log(
    `${mainnet ? "SNT" : "STT"} ${miniMeToken.target} controlled by ${await miniMeToken.controller()}`
  );
  console.log(
    `SNTPlaceHolder ${tokenController.target} owned by ${await tokenController.owner()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
