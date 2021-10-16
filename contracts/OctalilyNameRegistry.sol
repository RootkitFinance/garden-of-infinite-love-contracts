// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./Octalily.sol";

contract OctalilyNameRegistry {

    mapping (address => bytes32) public names;
    event NameSet(address indexed octalilyAddress, bytes32 name);

    function setName(address octalilyAddress, bytes32 name) public {
        Octalily octalily = Octalily(octalilyAddress);
        require(msg.sender == octalily.owner(), "Owner only");
        require(names[octalilyAddress] == 0, "Already set");
        names[octalilyAddress] = name;
        emit NameSet(octalilyAddress, name);
    }
}
