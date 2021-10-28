// SPDX-License-Identifier: I-N-N-N-N-NFINITYYY!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";
import "./IOwned.sol";

contract NameDescriptionRegistry {

    mapping (address => string) public names;
    mapping (address => string) public descriptions;

    event NameSet(address indexed contractAddress, string name);
    event DescriptionSet(address indexed contractAddress, string description);

    function setMultiOwnedName(address contractAddress, string calldata name) public {
        require(bytes(name).length <= 32, "Too long");   
        IMultiOwned multiOwned = IMultiOwned(contractAddress);
        require(msg.sender == multiOwned.owners(1), "Owner only");
        names[contractAddress] = name;
        emit NameSet(contractAddress, name);
    }
    
    function setMultiOwnedDescription(address contractAddress, string calldata description) public {
        IMultiOwned multiOwned = IMultiOwned(contractAddress);
        require(msg.sender == multiOwned.owners(1), "Owner only");
        descriptions[contractAddress] = description;
        emit DescriptionSet(contractAddress, description);
    }

    function setOwnedName(address contractAddress, string calldata name) public {
        require(bytes(name).length <= 32, "Too long");    
        IOwned owned = IOwned(contractAddress);
        require(msg.sender == owned.owner(), "Owner only");
        names[contractAddress] = name;
        emit NameSet(contractAddress, name);
    }
    
    function setOwnedDescription(address contractAddress, string calldata description) public {
        IOwned owned = IOwned(contractAddress);
        require(msg.sender == owned.owner(), "Owner only");
        descriptions[contractAddress] = description;
        emit DescriptionSet(contractAddress, description);
    }
}