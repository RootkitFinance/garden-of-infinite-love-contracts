// SPDX-License-Identifier: I-N-N-N-N-NFINITYYY!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";

contract OctalilyNameDescriptionRegistry {

    mapping (address => bytes32) public names;
    mapping (address => bytes32) public descriptions;
    event NameSet(address indexed octalilyAddress, bytes32 name);
    event DescriptionSet(address indexed octalilyAddress, bytes32 description);

    function setName(address octalilyAddress, bytes32 name) public {
        IMultiOwned octalily = IMultiOwned(octalilyAddress);
        require(msg.sender == octalily.owners(1), "Owner only");
        names[octalilyAddress] = name;
        emit NameSet(octalilyAddress, name);
    }
    
    function setDescription(address octalilyAddress, bytes32 description) public {
        IMultiOwned octalily = IMultiOwned(octalilyAddress);
        require(msg.sender == octalily.owners(1), "Owner only");
        descriptions[octalilyAddress] = description;
        emit DescriptionSet(octalilyAddress, description);
    }
}