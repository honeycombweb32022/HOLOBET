import { ethers } from "hardhat";

// Deployment scripts for token contracts
async function main() {
  const TokenContract = await ethers.getContractFactory("TokenContract");
  const token = await TokenContract.deploy("Trappist Token", "TRP");
  
  await token.deployed();

  console.log("token contract deployed to", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
