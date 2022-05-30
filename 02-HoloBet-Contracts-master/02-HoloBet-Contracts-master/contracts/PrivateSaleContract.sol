// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./TokenLocker.sol";
import "./interfaces/IERC20Extension.sol";
import "./interfaces/IMultisigWallet.sol";
import "./interfaces/ITokenLocker.sol";

contract PrivateSaleContract {
    IERC20Extension public token;  // token to receive from 
    mapping(address => uint256) public enrolledAddress;
    address[] private enrolled;
    address private owner;

    IMultisigWallet private treasuryWallet;
    ITokenLocker private tokenLocker;
    IERC20 private usdc;

    // accept only usdc
    // address private USDC_ADDRESS = address(0);
    bool private finished = false;
    uint256 public allocated;
    uint256 private startTime;
    uint256 private endTime;

    uint256 public lockId;

    uint256 private duration;
    uint256 private periodicity;
    uint256 private cliffTime;

    struct Round {
        string name;
        uint totalRaise;
        uint sellPrice;
        bool status;
        bool completed;
    }

    Round private round;
    constructor(
        address _token, 
        address _treasuryWallet,
        address _tokenLocker, // Implementation for locker
        address _usdc,
        string memory _name,
        uint _totalRaise, 
        uint _sellPrice)
    {
        owner = msg.sender;
        token = IERC20Extension(_token);

        // USDC_ADDRESS = _usdc;
        usdc = IERC20(_usdc);

        round = Round({name: _name, totalRaise: _totalRaise, sellPrice: _sellPrice, status: true, completed: false });

        treasuryWallet = IMultisigWallet(_treasuryWallet);

        // clone new token locker here and assign to tokenlocker
        address lockerClone = Clones.clone(_tokenLocker);
        tokenLocker = ITokenLocker(lockerClone);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sale: only owner can call.");
        _;
    }

    // This for manual closure
    function closeSale() public onlyOwner {
        require(round.completed != true, "Sale: Already closed");
        round.completed = true;
        round.status = false; // live status
    }

    function openSale() public onlyOwner {
        startTime = block.timestamp;
        endTime = startTime + 5 minutes;
    }

    // TGE claims - 10%
    function claim() public {
        require(endTime <= block.timestamp, "Sale is in progress");
        require(enrolledAddress[msg.sender] > 0, "Sale: User does not have any allocation");

        uint256 currentAllocation = enrolledAddress[msg.sender];
        enrolledAddress[msg.sender] = 0;
        IERC20Extension(token).mint(msg.sender, currentAllocation);
        
    }

    // TGE Claims - 90%
    function release() public {
        require(endTime <= block.timestamp, "Sale is in progress");
        require(cliffTime <= block.timestamp, "Vesting schedule not reached");
        // lockIds = ITokenLocker(tokenLocker).getLockIds(msg.sender);
        // uint available = ITokenLocker(tokenLocker).getAvailableAmount(lockId);
        // require (available >= 0, "Sale: User does not have any allocation");

        ITokenLocker(tokenLocker).releaseAllAvailableTokensToBeneficiary(msg.sender);
    }

    function changeOwnership(address _newOwner) public onlyOwner{
       owner = _newOwner;
    }

    function deposite(uint value) public {
        // can peform deposite only when sale is in progress.
        require(endTime > 0, "Sale: Not started");
        require(block.timestamp <= endTime, "Token sale had already closed");

        uint currentAllocation = SafeMath.div(SafeMath.mul(SafeMath.div(value, 1e6), 1e18), round.sellPrice);
        uint seedAllocation = IERC20Extension(token).seedRound();
        require((allocated + currentAllocation) < seedAllocation, "Sale: Allocation for this round already reached");
        require(enrolledAddress[msg.sender] <= 0, "Sale: Current Wallet already contains an allocation");

        // 10% for TGE after sale
        uint current = SafeMath.mul(SafeMath.div(SafeMath.mul(SafeMath.div(currentAllocation, 1e3), 1000), 10), 1e18);
        // 90% for vesting
        uint vestingAmount = SafeMath.mul(SafeMath.div(SafeMath.mul(SafeMath.div(currentAllocation, 1e3), 9000), 10), 1e18);
        // Mint this amount here and approve token locker
        IERC20Extension(token).mint(address(this), vestingAmount);

        enrolledAddress[msg.sender] = current;
        IERC20(usdc).transferFrom(msg.sender, address(treasuryWallet), value);
        allocated += currentAllocation;

        uint256 currentTime = block.timestamp;
        duration = currentTime + 10 minutes;
        periodicity = currentTime + 2 minutes;
        cliffTime = currentTime + 5 minutes;

        IERC20Extension(token).approve(address(tokenLocker), vestingAmount);
        // call token locker here to to lock tokens
        ITokenLocker(tokenLocker).lockTokens(
            token, 
            msg.sender, 
            duration, 
            periodicity, 
            vestingAmount, 
            cliffTime
        );
    }
}