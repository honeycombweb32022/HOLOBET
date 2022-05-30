import { ethers } from "hardhat";

async function main(): any {
  const Wallet = await ethers.getContractFactory("WalletContract");

  // provide address for signing
  const wallet = await Wallet.deploy([
    "0x4db8bcCF4385C7AA46F48eb42f70FA41Df917b44",
    "0x287f0B854a2Ba9Dc3E8572c68bDabD949819F119",
    "0xEab2B6b5a76d5878a7B5D97d7F6812Da09A30953",
    "0xCa2A82ea8e2890A476B6Ab1A109139087f831c47",
    "0x3AB8866082dcef761FB61F48aaBe7C5741fae889"
  ], 3);

  await wallet.deployed();

}

main().catch((error: any) => {
  console.error(error);
  process.exitCode = 1;
});
