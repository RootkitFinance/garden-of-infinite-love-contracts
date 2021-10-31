// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IMultiOwned.sol";
import "./Owned.sol";

contract FlowerOwnershipGiver is Owned {
    mapping (uint256 => address) public ownedFlowers;
    mapping (address => uint256) public receivedFlowers;

    uint256 public availableFlowerIndex;
    uint256 public flowerCount;
    uint256 public maxAllowedFlowers = 1;
    uint256 public maxOwnershipIndex = 15;

    function increaseMaxAllowedFlowers() public ownerOnly() {
        maxAllowedFlowers++;
    }

    function setMaxOwnershipIndex(uint256 _maxOwnershipIndex) public ownerOnly() {
        maxOwnershipIndex = _maxOwnershipIndex;
    }

    function claimFlowerOwnership(IMultiOwned flower) public ownerOnly() {
        flower.claimOwnership();
        ownedFlowers[++flowerCount] = address(flower);
        if (availableFlowerIndex == 0) {
            availableFlowerIndex = 1;
        }
    }

    function reclaimFlower(IMultiOwned flower) public ownerOnly() {
        require (flower.ownerCount() == maxOwnershipIndex, "Ownership slots are still available");
        flower.transferOwnership(msg.sender);
    }

    function giveMeFlower() public {
        require (receivedFlowers[msg.sender] < maxAllowedFlowers, "Max allowance reached");
        require (flowerCount > 0, "No flowers available");  

        IMultiOwned flower = IMultiOwned(ownedFlowers[availableFlowerIndex]);

        if (flower.ownerCount() == maxOwnershipIndex) {
            require (++availableFlowerIndex <= flowerCount, "No flowers available");  
            flower = IMultiOwned(ownedFlowers[availableFlowerIndex]);
        }
       
        flower.addExtraOwners(flower.ownerCount() + 1, msg.sender);
        receivedFlowers[msg.sender]++;
    }

    function recoverTokens(IERC20 token) public ownerOnly() {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function recoverChainToken() public ownerOnly() {
        msg.sender.transfer(address(this).balance);
    }

    receive() external payable {
    }
}