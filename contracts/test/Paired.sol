
// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "../ERC20.sol";

contract Paired is ERC20("Paired", "PAI") 
{ 
    constructor()
    {
        _mint(msg.sender, 10000 ether);
    }
}