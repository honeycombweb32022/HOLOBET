// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITokenLocker {
    function getAvailableAmount(uint256 lockId) external view returns (uint256);
    function getLockIds(address beneficiary) external view returns (uint256);
    function releaseFromLockId(uint256 lockId) external;
    function releaseToBeneficiaryFromLockId(uint256 lockId, address beneficiary) external;
    function releaseAllAvailableTokens() external;
    function releaseAllAvailableTokensToBeneficiary(address beneficiary) external;
    function batchReleaseAllAvailableTokensToBeneficiaries(address[] calldata beneficiary) external;
    function batchLockTokens(IERC20[] calldata tokens, address[] calldata beneficiaries, uint256[] calldata durations, uint256[] calldata peridicities, uint256[] calldata amounts, uint256[] calldata cliffTimes) external;
    function lockTokens(IERC20 token, address beneficiary, uint256 duration, uint256 periodicity, uint256 amount, uint256 cliffTime) external;
}
