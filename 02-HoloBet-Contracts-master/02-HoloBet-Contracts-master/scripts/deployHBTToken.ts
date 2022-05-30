import { ethers } from "hardhat";

// Deployment scripts for token contracts
async function main(): any {
  const TokenContract = await ethers.getContractFactory("HBTTokenContract");
  const token = await TokenContract.deploy(
    "Holobet Token", 
    "HBT", 
    ethers.utils.parseUnits("40000000", 18), 
    ethers.utils.parseUnits("1000000000", 18));
  await token.deployed();

  console.log("HBT token contract deployed to:", token.address);
}

main().catch((error: any) => {
  console.error(error);
  process.exitCode = 1;
});
