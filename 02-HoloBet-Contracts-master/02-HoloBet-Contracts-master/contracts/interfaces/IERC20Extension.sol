// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20Extension is IERC20 {
    function burn(uint256 amount) external returns (bool); 
    function burnFrom(address from, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external returns (bool);

    function seedRound()    external view returns (uint256);
    function whiteList()    external view returns (uint256);
    function privateOne()   external view returns (uint256);
    function privateTwo()   external view returns (uint256);
    function privateThree() external view returns (uint256);

    event Burn(address indexed from, uint256 amount);
}