// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IERC20.sol";

interface IOctalily is IERC20
{
    function connectFlower(address newConnection) external;
    function upOnly() external;
    function buy(uint256 _amount) external;
    function sell(uint256 _amount) external;
    function sellOffspringToken (IOctalily lily) external;
    function payFees() external;
}