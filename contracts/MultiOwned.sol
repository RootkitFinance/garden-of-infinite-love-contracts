// SPDX-License-Identifier: I-N-N-N-NFINITY!!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";

abstract contract MultiOwned is IMultiOwned {
    
    uint256 public override ownerCount = 1;

    mapping (uint256 => address) public override owners;
    mapping (address => uint256) public override ownerIndex;    

    constructor () {
        owners[1] = tx.origin;
        ownerIndex[tx.origin] = 1;
    }

    modifier ownerSOnly() {
        require (ownerIndex[msg.sender] != 0, "Owners only");
        _;
    }

    modifier ownerOnly() {
        require (ownerIndex[msg.sender] == 1, "Owner 1 only");
        _;
    }

    function isOwner(address owner) public virtual override view returns (bool){
        return ownerIndex[owner] != 0;
    }

    function transferOwnership(address newOwner) public virtual override ownerSOnly() {
        uint256 index = ownerIndex[msg.sender];
        address oldOwner =  owners[index];
        require (msg.sender == oldOwner);
        ownerIndex[oldOwner] = 0;
        require (ownerIndex[newOwner] == 0);
        owners[index] = newOwner;
        ownerIndex[newOwner] = index;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function addExtraOwners(address newOwner) public virtual override ownerOnly(){
        uint256 index = ownerCount;
        require (owners[index] == address(0));
        ownerCount++;
        require (ownerCount <= 23);
        owners[index] = newOwner;
        ownerIndex[newOwner] = index;
        emit OwnershipTransferred(address(0), newOwner);
    }
}