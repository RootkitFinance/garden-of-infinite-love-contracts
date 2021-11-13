
// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "../ERC20.sol";

contract RootKit is ERC20("RootKit", "ROOT") 
{ 
    constructor()
    {
        _mint(msg.sender, 10000 ether);
    }
}