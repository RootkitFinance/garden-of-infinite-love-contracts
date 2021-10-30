// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";

contract FlowerOwnershipGiver {
    mapping (uint256 => address) public ownedFlowers;
    mapping (address => bool) public receivers;
    uint256 public availableFlowerIndex;
    uint256 public flowerCount;

    function claimFlowerOwnership(IMultiOwned flower) public {
        flower.claimOwnership();
        ownedFlowers[++flowerCount] = address(flower);
        if (availableFlowerIndex == 0) {
            availableFlowerIndex = 1;
        }
    }

    function giveMeFlower() public {
        require (!receivers[msg.sender], "Already received");
        require (flowerCount > 0, "No flowers available");  

        IMultiOwned flower = IMultiOwned(ownedFlowers[availableFlowerIndex]);

        if (flower.ownerCount() == 23) {
            require (++availableFlowerIndex <= flowerCount, "No flowers available");  
            flower = IMultiOwned(ownedFlowers[availableFlowerIndex]);
        }
       
        flower.addExtraOwners(flower.ownerCount() + 1, msg.sender);
        receivers[msg.sender] = true;
    }
}