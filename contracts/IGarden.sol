// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

interface IGarden
{
    function spreadTheLove(address pairedToken) external;
    function restrictedMode() external view returns (bool);
}