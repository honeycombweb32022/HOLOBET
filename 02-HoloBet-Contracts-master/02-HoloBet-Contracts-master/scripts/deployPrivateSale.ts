import { ethers } from "hardhat";

// Deployment scripts for token contracts
async function main() {
  const PrivateSale = await ethers.getContractFactory("FlatPrivateSaleContract");
  const sale = await PrivateSale.deploy("0x79F00B25bAd83e86274d6841517D13b97c667B56");
  await sale.deployed();

  console.log("Private sale contract deployed to:", sale.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
