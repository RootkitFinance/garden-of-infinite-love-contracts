// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

interface IOctalily
{
    function letTheFlowersCoverTheEarth() external;
    function payFees() external;
    function upOnly() external;
    function buy(uint256 _amount) external;
    function sell(uint256 _amount) external;
    function sellOffspringToken (IOctalily lily) external;
    function balanceOf(address _account) external view returns (uint256);
}