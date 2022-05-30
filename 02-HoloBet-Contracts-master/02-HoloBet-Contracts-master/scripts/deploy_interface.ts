// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { ether } from "../test/utils";
import { PoolFactory } from "../typechain";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');


  // Token contract address : 0xf4A821Bb43A03F3d9a622e3f144594C02b9Ae7D1

  //Token Locker deployment
  const TokenLockerContract = await ethers.getContractFactory("TokenLocker");
//   const TokenLocker = await TokenLockerContract.deploy();


  //Staking Contract
  const StakingContract = await ethers.getContractFactory("Staking");
//   const Staking = await StakingContract.deploy();

const TokenContract = await ethers.getContractFactory("TokenContract");
// const hbtToken = TokenContract.attach("0xf4A821Bb43A03F3d9a622e3f144594C02b9Ae7D1");
const hbtToken = TokenContract.attach("0x79F00B25bAd83e86274d6841517D13b97c667B56");


//LP Mining
const LockUpMiningContract = await ethers.getContractFactory("LockUpMining");
const LockUpMining = await LockUpMiningContract.deploy(hbtToken.address, 1020,1209600);


// Private Sale 
const PrivateSaleContract = await ethers.getContractFactory("PrivateSaleContract");
const PrivateSale = await PrivateSaleContract.deploy(hbtToken.address);


//Multi-sig wallet
// Added 3 test net wallet address. Required 2 signatures
const accounts = ["0xb05535C9102dCD2c6c0eefA9E62063545CB1078F", "0x51A87084D84d62BB6D498Ad2A6523a38701E7eBf", "0x0cBED455d2ED02b7B40A576798D295E684cB65F0"];

const WalletContractContract = await ethers.getContractFactory("WalletContract");
const WalletContract = await WalletContractContract.deploy(accounts, 2);


//HBT config
// const LockUpMining = LockUpMiningContract.attach("0xb408ED8DA6204FF40B454F3AbcBb7DedA0572301");
const Staking =  StakingContract.attach("0x004206C1aFFB3217954D67ae5f7189807c14Bf08");

const HBTConfigContract = await ethers.getContractFactory("HBTConfig");
// const HBTConfig = await HBTConfigContract.deploy(Staking.address,LockUpMining.address,hbtToken.address, 1000, "0x0cBED455d2ED02b7B40A576798D295E684cB65F0", 15);


// Pool factory 
// Attaching HBT config from testnet to Poolfactory
const HBTConfig =  HBTConfigContract.attach("0xf1f0A769170Cf991926D36512DCc6819C5671C47");

const PoolFactoryContract = await ethers.getContractFactory("PoolFactory");
// const PoolFactory = await PoolFactoryContract.deploy(HBTConfig.address);


//Pool contract
const PoolFactory =  PoolFactoryContract.attach("0x861B099B4839AcA983F17272c5B45a89F406e7E5");

const PoolContract = await ethers.getContractFactory("Pool");
const Pool = await PoolContract.deploy(PoolFactory.address, 100, hbtToken.address, 1000);

await PoolFactory.deployed();


  console.log("Staking deployed to:", PoolFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
