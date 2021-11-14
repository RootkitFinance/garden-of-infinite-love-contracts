// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./Octalily.sol";

contract FlowerFeeSplitter {    
    address public rootFeeder;
 
    constructor(address _rootFeeder) {
        rootFeeder = _rootFeeder;
    }

    function payFees(Octalily octalily) public {
        octalily.sell(octalily.balanceOf(address(this)));
        IERC20 paired = octalily.pairedToken();
        uint256 ownerCount = octalily.ownerCount();
        uint256 share = paired.balanceOf(address(this)) / 3 * 2 / ownerCount;

        for (uint256 i = 1; i <= ownerCount; i++) {
            paired.transfer(octalily.owners(i), share);
        }
        paired.transfer(rootFeeder, paired.balanceOf(address(this)));
    }
}