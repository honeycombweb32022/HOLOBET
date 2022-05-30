import { ethers } from "hardhat";
import { BigNumber } from "@ethersproject/bignumber";
import {
    ether,
    wei,
    getLatestBlockTimestamp,
    getLatestBlockNumber,
    MAX_UINT_256,
    ZERO_ADDRESS,
    advanceBlock,
    advanceTimeAndBlock,
    ONE_DAY_SECONDS
} from "../test/utils";

async function main() {
  const Staking = await ethers.getContractFactory("Staking");
  const stake = await Staking.attach("0x60fF4B7754EAD488C5c6962b89d2A8B6fcF267C7");
  stake.startStaking(await getLatestBlockNumber());

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
