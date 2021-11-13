
// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "../Rootflector.sol";

contract RootflectorTest is Rootflector("Rootflector", "Rootflector") 
{ 
    constructor()
    {
        _mint(msg.sender, 10000 ether);
    }
}