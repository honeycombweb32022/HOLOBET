// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/proxy/Clones.sol"; //1167
import "./interfaces/ITokenLocker.sol";

contract TokenLockerTest {
    // call token locker from here and deposite amount for the user
    // give this contract some tokens
    // add some beneficiary

    // call lock token function
    ITokenLocker private locker;  
    address private baseLocker;
    IERC20 private token;

    constructor(address _locker, address _token) {
        // clone token locker here
        baseLocker = _locker;
        token = IERC20(_token);
        // locker = ITokenLocker(_locker);
    }

    // decimal of 18
    function deposite(uint256 amount, address beneficiary) external {
        // clone token locker here
        address lockerAddress = Clones.clone(baseLocker);
        locker = ITokenLocker(lockerAddress);

        // call locker functionalitiy

        uint timestamp = block.timestamp;

        // should I give approval to withdraw amount from this contract

        locker.lockTokens(
            token,
            beneficiary,
            timestamp + 30 minutes,
            timestamp + 5 minutes,
            amount,
            timestamp + 15 minutes
        );
    }
}
