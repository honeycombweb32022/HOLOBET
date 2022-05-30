// SPDX-License-Idntifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// import all interfaces
import "./interfaces/IHolobetSwapFactory.sol";
import "./interfaces/IHolobetSwapRouter.sol";
import "./interfaces/IWHBT.sol";

contract AddLiquidity is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IHolobetSwapFactory public factory;
    IHolobetSwapRouter public router;
    IWHBT public whbt;

    constructor(
        IHolobetSwapFactory _factory,
        IHolobetSwapRouter _router,
        IWHBT _whbt //only use wrapped
    ) {
        // check if address is 0
        require(address(_factory) != address(0), "Invalid factory address");
        require(address(_router) != address(0), "Invalid router address");
        require(address(_whbt) != address(0), "Invalid whbt address");

        factory = _factory;
        router = _router;
        whbt = _whbt;
    }

    function withdrawToken(IERC20 token, address payable to) external payable onlyOwner {
        require(address(token) != address(0), "Invalid token address");
        require(to != address(0), "Invalid to address");
        IERC20(token).transfer(to, IERC20(token).balanceOf(address(this)));
    }

    function withdrawHBT(address payable to) external payable onlyOwner {
        require(to != address(0), "Invalid to address");
        to.transfer(address(this).balance);
    }

    function addLiquidity(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1
    ) external onlyOwner {
        if (token0 == address(0)) {
            IERC20(token1).approve(address(router), type(uint256).max);
            router.addLiquidityHBT{ value: amount0 }(token1, amount1, 0, 0, msg.sender, block.timestamp);
        } else if (token1 == address(0)) {
            IERC20(token0).approve(address(router), type(uint256).max);
            router.addLiquidityHBT{ value: amount1 }(token0, amount0, 0, 0, msg.sender, block.timestamp);
        } else {
            IERC20(token0).approve(address(router), type(uint256).max);
            IERC20(token1).approve(address(router), type(uint256).max);
            router.addLiquidity(token0, token1, amount0, amount1, 0, 0, msg.sender, block.timestamp);
        }
    }
}