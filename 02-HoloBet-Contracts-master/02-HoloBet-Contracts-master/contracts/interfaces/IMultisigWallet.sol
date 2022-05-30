// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMultisigWallet {
    function withdraw(address to, address token, uint256 value, bytes memory data) external;
    function withdraw(address to, uint256 value, bytes memory data) external;
    function confirmTransaction(uint txIndex) external;
    function executeTransaction(uint txIndex) external;
    function revokeConfirmation(uint txIndex) external;
}