// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;
pragma abicoder v2;

import "./IERC20.sol";
import "./IGarden.sol";
import "./Octalily.sol";

contract GardenOfInfiniteLove is IGarden {

    IERC20 public immutable rootkit;
    address private immutable dev3;
    address private immutable dev6;
    address private immutable dev9;
    address private immutable rootkitFeed;

    mapping (address => FlowerData) public flowers;
    mapping (address => bool) bloomingFlowers;

    struct FlowerData {
        address pairedAddress;
        address parentToken;
        address strainParent;
        uint256 burnRate;
        uint256 upPercent;
        uint256 upDelay;
        uint256 nonce;
    }

    mapping (address => uint256) flowersOfPair;


    constructor(address _dev6, address _dev9, IERC20 _rootkit ,address _rootkitFeed) {
        dev3 = msg.sender;
        dev6 = _dev6;
        dev9 = _dev9;
        rootkit = _rootkit;
        rootkitFeed = _rootkitFeed;
    }

    event FlowerPlanted(address flower, address pairedToken);

    function plantNewSeed(address pairedToken) public { // start a fresh parent flower
    if (msg.sender != dev3){
            rootkit.transferFrom(msg.sender, address(this), 69e16); // it costs 0.69 ROOT to start a virus with a new variant pair
        }
        if (flowersOfPair[pairedToken] > 0) { return; }
        uint256 nonce = ++flowersOfPair[pairedToken];
        plantNewFlower(pairedToken, dev6, dev9, 690, 420, 690, nonce); 
    }

    function spreadTheLove() public override { // flower spawns another flower
        address spreader = msg.sender;
        require (bloomingFlowers[spreader]);
        FlowerData memory parentFlowerData = flowers[spreader];
        randomizeFlowerStats(
            parentFlowerData.pairedAddress, spreader, parentFlowerData.strainParent, 
            parentFlowerData.burnRate, parentFlowerData.upPercent, parentFlowerData.upDelay);
    }

    function randomizeFlowerStats(address pairedToken, address parentToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay) internal {
        uint256 nonce = ++flowersOfPair[pairedToken];
        burnRate = burnRate + random(nonce, 369) - 246;
        burnRate = burnRate < 420 ? 420 : burnRate;
        upPercent = upPercent + random(nonce, 6) * 100 - 400;
        upPercent = upPercent > burnRate + 111 ? burnRate - 111 : upPercent;
        upDelay = upDelay + random(nonce, 369) - 246;
        upDelay = upDelay < 69 ? 69 : upDelay;

        plantNewFlower(pairedToken, parentToken, strainParent, burnRate, upPercent, upDelay, nonce);
    }
        
    function plantNewFlower(address pairedToken, address parentToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay, uint256 nonce) internal {        
        Octalily newFlower = new Octalily(IERC20(pairedToken), burnRate, upPercent, upDelay, dev3, dev6, dev9, parentToken, strainParent, nonce, address(tx.origin), rootkitFeed);
        address flower = address(newFlower);
        flowers[flower] = FlowerData({

            pairedAddress: pairedToken,
            parentToken : parentToken,
            strainParent : strainParent,
            burnRate: burnRate,
            upPercent: upPercent,
            upDelay: upDelay,
            nonce: nonce
        });

        bloomingFlowers[flower];
        emit FlowerPlanted(flower, pairedToken);
    }

    function random(uint256 nonce, uint256 max) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce))) % max + 1;
    }

    function recoverTokens(IERC20 token) public {
        require (msg.sender == dev6 || msg.sender == dev9 || msg.sender == dev3);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}