// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";

contract OctalilyNameRegistry {

    mapping (address => bytes32) public names;
    event NameSet(address indexed octalilyAddress, bytes32 name);

    function setName(address octalilyAddress, bytes32 name) public {
        IMultiOwned octalily = IMultiOwned(octalilyAddress);
        require(msg.sender == octalily.owners(1), "Owner only");
        require(names[octalilyAddress] == 0, "Already set");
        names[octalilyAddress] = name;
        emit NameSet(octalilyAddress, name);
    }
}
