// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;
pragma abicoder v2;

import "./IERC20.sol";
import "./IGarden.sol";
import "./Octalily.sol";
import "./SafeMath.sol";

contract GardenOfInfiniteLove is IGarden {
    IERC20 public immutable rootkit;
    address private immutable dev3;
    address private immutable dev6;
    address private immutable dev9;
    address private immutable rootkitFeed;

    mapping (address => FlowerData) public flowers;
    mapping (address => bool) bloomingFlowers;
    mapping (address => address[]) public pairedFlowers;
    mapping (address => uint256) public flowersOfPair;

    struct FlowerData {
        address pairedAddress;
        address parentToken;
        address strainParent;
        uint256 burnRate;
        uint256 upPercent;
        uint256 upDelay;
        uint256 nonce;
    }

    constructor(address _dev6, address _dev9, IERC20 _rootkit ,address _rootkitFeed) {
        dev3 = msg.sender;
        dev6 = _dev6;
        dev9 = _dev9;
        rootkit = _rootkit;
        rootkitFeed = _rootkitFeed;
    }

    event FlowerPlanted(address flower, address pairedToken);

    function plantNewSeed(address pairedToken) public { // seed a fresh parent flower
        if (msg.sender != dev3){
            rootkit.transferFrom(msg.sender, address(this), 696969e15); // it costs 696 upTether to seed a new flower type
        }
        if (flowersOfPair[pairedToken] > 0) { return; }
        uint256 nonce = ++flowersOfPair[pairedToken];
        plantNewFlower(pairedToken, dev3, address(0), 690, 420, 690, nonce); 
    }

    function spreadTheLove() public override returns (address) { // Any flower can spawn another flower for free
        address spreader = msg.sender;
        require (bloomingFlowers[spreader]);
        FlowerData memory parentFlowerData = flowers[spreader];
        return randomizeFlowerStats(
            parentFlowerData.pairedAddress, spreader, parentFlowerData.strainParent, 
            parentFlowerData.burnRate, parentFlowerData.upPercent, parentFlowerData.upDelay);
    }

    function randomizeFlowerStats(address pairedToken, address parentToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay) internal returns (address) {
        uint256 nonce = ++flowersOfPair[pairedToken];
        burnRate = burnRate + random(nonce, 369) - 123;
        if (burnRate < 420) {
            burnRate = 420;
        }
        upPercent = upPercent + random(nonce, 7) * 100 - 300;
        if (upPercent < 300) {
            upPercent = 300;
        }
        if (upPercent > burnRate) {
            upPercent = burnRate - 111;
        }
        upDelay = upDelay + random(nonce, 369) - 180;
        if (upDelay < 210) {
            upDelay = 210;
        }

        return plantNewFlower(pairedToken, parentToken, strainParent, burnRate, upPercent, upDelay, nonce);
    }
        
    function plantNewFlower(address pairedToken, address parentToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay, uint256 nonce) internal returns (address) {        
        Octalily newFlower = new Octalily(IERC20(pairedToken), burnRate, upPercent, upDelay, dev3, dev6, dev9, parentToken, strainParent, nonce, address(tx.origin), rootkitFeed);
        address flower = address(newFlower);
        flowers[flower] = FlowerData({
            pairedAddress: pairedToken,
            parentToken : parentToken,
            strainParent : newFlower.strainParent(),
            burnRate: burnRate,
            upPercent: upPercent,
            upDelay: upDelay,
            nonce: nonce
        });

        bloomingFlowers[flower] = true;
        pairedFlowers[pairedToken].push(flower);
        emit FlowerPlanted(flower, pairedToken);
        return flower;
    }

    function random(uint256 nonce, uint256 max) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce))) % max + 1;
    }

    function recoverTokens(IERC20 token) public {
        require (msg.sender == dev6 || msg.sender == dev9 || msg.sender == dev3);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}