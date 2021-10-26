// SPDX-License-Identifier: I-N-N-N-N-NFINITYYY!!
pragma solidity ^0.7.6;

import "./Octalily.sol";

contract OctalilyNameDescriptionRegistry {

    struct OctalilyNameDescription{
      bytes32 name;
      bytes32 description;
    }

    mapping (address => OctalilyNameDescription[]) public nameDescriptions;    
    event NameDescriptionSet(address indexed octalilyAddress, bytes32 name, bytes32 description);

    function setNameDescription(address octalilyAddress, bytes32 name, bytes32 description) public {
        Octalily octalily = Octalily(octalilyAddress);
        require(msg.sender == octalily.owner(), "Owner only");
        nameDescriptions[octalilyAddress].push(OctalilyNameDescription(name,description));
        emit NameDescriptionSet(octalilyAddress, name, description);
    }
}