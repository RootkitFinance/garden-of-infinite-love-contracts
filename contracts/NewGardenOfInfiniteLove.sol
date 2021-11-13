//SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IERC20.sol";
import "./IGarden.sol";
import "./Octalily.sol";
import "./SafeMath.sol";

contract NewGardenOfInfiniteLove is IGarden {
    IERC20 public immutable rootkit;
    address private immutable dev3;
    address private immutable dev6;
    address private immutable dev9;
    address public feeSplitter;
    uint256 public costToPlantNewSeed; 
    // 6969e18 - 6969 upBNB 
    // 696969e12 - 0.69 ROOT
    // 696969e15 -  696 upTether

    mapping (address => FlowerData) public flowers;
    mapping (address => bool) bloomingFlowers;
    mapping (address => address[]) public pairedFlowers;
    mapping (address => uint256) public flowersOfPair;

    bool public override restrictedMode;

    struct FlowerData {
        address pairedAddress;
        address parentToken;
        address strainParent;
        uint256 burnRate;
        uint256 upPercent;
        uint256 upDelay;
        uint256 nonce;
    }
    event FlowerPlanted(address flower, address pairedToken);

    constructor(address _dev6, address _dev9, IERC20 _rootkit, uint256 _costToPlantNewSeed) {
        dev3 = msg.sender;
        dev6 = _dev6;
        dev9 = _dev9;
        rootkit = _rootkit;
        costToPlantNewSeed = _costToPlantNewSeed;
        restrictedMode = true;
    }

    function removeRestrictedMode() public {
        require (msg.sender == dev3);
        restrictedMode = false;
    }

    function setFeeSplitter(address _feeSplitter) public {
        require (msg.sender == dev3);
        feeSplitter = _feeSplitter;
    }

    function plantNewSeed(address pairedToken) public { // seed a fresh parent flower
        if (msg.sender != dev3){
            require (!restrictedMode);
            rootkit.transferFrom(msg.sender, address(this), costToPlantNewSeed); // it costs 0.69 ROOT to seed a new flower type
        }
        if (flowersOfPair[pairedToken] > 0) { return; }
        uint256 nonce = ++flowersOfPair[pairedToken];
        plantNewFlower(pairedToken, dev3, address(0), 1420, 420, 1690, nonce); 
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
        if (burnRate < 1420) {
            burnRate = 1420;
        }
        upPercent = upPercent + random(nonce, 7) * 100 - 300;
        if (upPercent < 420) {
            upPercent = 420;
        }

        if (burnRate < (upPercent + upPercent/2)) {
            burnRate = upPercent + upPercent/2;
        }

        upDelay = upDelay + random(nonce, 1369) - 693;
        if (upDelay < 1690) {
            upDelay = 1690;
        }

        return plantNewFlower(pairedToken, parentToken, strainParent, burnRate, upPercent, upDelay, nonce);
    }
        
    function plantNewFlower(address pairedToken, address parentToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay, uint256 nonce) internal returns (address) {        
        Octalily newFlower = new Octalily();
        newFlower.init(IERC20(pairedToken), burnRate, upPercent, upDelay, parentToken, strainParent, nonce, feeSplitter);
        newFlower.setInitialOwners(address(tx.origin), dev6, dev9);
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