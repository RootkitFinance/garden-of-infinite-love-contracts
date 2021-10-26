// SPDX-License-Identifier: I-N-N-N-N-NFINITYYY!!
pragma solidity ^0.7.6;

import "./Octalily.sol";

contract OctalilyNameDescriptionRegistry {

    mapping (address => bytes32) public names;
    mapping (address => bytes32) public descriptions;
    event NameSet(address indexed octalilyAddress, bytes32 name);
    event DescriptionSet(address indexed octalilyAddress, bytes32 description);

    function setName(address octalilyAddress, bytes32 name) public {
        Octalily octalily = Octalily(octalilyAddress);
        require(msg.sender == octalily.owner(), "Owner only");
        names[octalilyAddress] = name;
        emit NameSet(octalilyAddress, name);
    }
    
    function setDescription(address octalilyAddress, bytes32 description) public {
        Octalily octalily = Octalily(octalilyAddress);
        require(msg.sender == octalily.owner(), "Owner only");
        descriptions[octalilyAddress] = description;
        emit DescriptionSet(octalilyAddress, description);
    }
}