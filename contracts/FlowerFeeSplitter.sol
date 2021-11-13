// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

// import "./Octalily.sol";

// contract FlowerFeeSplitter {    
//     address public rootFeeder;
    
//     constructor(address _rootFeeder) {
//         rootFeeder = _rootFeeder;
//     }

//     function payFees(Octalily octalily) public {
//         uint256 collectedFees = octalily.balanceOf(address(this));
//         uint256 ownerCount = octalily.ownerCount();
//         uint256 petalCount = octalily.petalCount();
//         uint256 share = collectedFees / (ownerCount + petalCount + 3); // ownerCount + petalCount + strainParent + rootkitFeed + parentFlower
   
//         for (uint256 i = 1; i <= petalCount; i++) {
//             octalily.transfer(octalily.theEightPetals(i), share);
//         }

//         octalily.transfer(octalily.parentFlower(), share);
//         octalily.transfer(octalily.strainParent(), share);

//         octalily.sell(share*(ownerCount + 1));
//         IERC20 paired = octalily.pairedToken();
//         uint256 pairedBalance = paired.balanceOf(address(this));
//         share = pairedBalance/(ownerCount + 1);

//         for (uint256 i = 1; i <= ownerCount; i++) {
//             paired.transfer(octalily.owners(i), share);
//         }

//         paired.transfer(rootFeeder, paired.balanceOf(address(this)));
//     }
// }