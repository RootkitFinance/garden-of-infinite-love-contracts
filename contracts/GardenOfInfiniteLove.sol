//SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IERC20.sol";
import "./IGarden.sol";
import "./Octalily.sol";
import "./SafeMath.sol";

contract GardenOfInfiniteLove is IGarden {
    IERC20 public immutable rootkit;
    address private immutable dev3;
    address private immutable dev6;
    address private immutable dev9;
    address public feeSplitter;
    uint256 public costToPlantNewSeed; 
    // 6969e18 - 6969 upBNB 
    // 696969e12 - 0.69 ROOT
    // 696969e15 -  696 upTether

    mapping (address => address[]) public pairedFlowers; // paired -> array of flowers
    mapping (address => uint256) public flowersOfPair;

    bool public override restrictedMode;

    event FlowerPlanted(address flower, address pairedToken);
    event FlowersConnected(address flower, address newConnection);

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
        Octalily newFlower = plantNewFlower(pairedToken, dev3, 1420, 420, 1690, 369, nonce); 
        newFlower.connectFlower(dev3);
    }

    function spreadTheLove(address pairedToken) public override { // Adds a petal/connection
        require (!restrictedMode || msg.sender == dev3);

        uint256 length = pairedFlowers[pairedToken].length;
        require (length > 0);

        Octalily parent = length > 4 ? Octalily(pairedFlowers[pairedToken][length - 3]) : Octalily(pairedFlowers[pairedToken][0]);
        address strainParent = pairedFlowers[pairedToken][0];

        uint256 nonce = ++flowersOfPair[pairedToken];
        (uint256 burnRate, uint256 upPercent, uint256 upDelay) = randomizeFlowerStats(parent.burnRate(), parent.upPercent(), parent.upDelay(), nonce);
       
        Octalily newFlower = plantNewFlower(pairedToken, strainParent, burnRate, upPercent, upDelay, 369, nonce);
        newFlower.connectFlower(strainParent);
    }

    function connectFlowers(Octalily flower, address newConnection) public {
        require (msg.sender == dev6 || msg.sender == dev9 || msg.sender == dev3);
        flower.connectFlower(newConnection);
        emit FlowersConnected(address(flower), newConnection);
    }

    function randomizeFlowerStats(uint256 burnRate, uint256 upPercent, uint256 upDelay, uint256 nonce) internal view returns (uint256, uint256, uint256) {
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

        return (burnRate, upPercent, upDelay);
    }
        
    function plantNewFlower(address pairedToken, address strainParent, uint256 burnRate, uint256 upPercent, uint256 upDelay, uint256 rootflectionFeeRate, uint256 nonce) internal returns (Octalily) {        
        Octalily newFlower = new Octalily();
        
        newFlower.init(IERC20(pairedToken), burnRate, upPercent, upDelay, rootflectionFeeRate, strainParent, nonce, feeSplitter);
        newFlower.addExtraOwners(dev6);
        newFlower.addExtraOwners(dev9);

        address flower = address(newFlower);        
        pairedFlowers[pairedToken].push(flower);
        emit FlowerPlanted(flower, pairedToken);
        return newFlower;
    }

    function random(uint256 nonce, uint256 max) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce))) % max + 1;
    }

    function recoverTokens(IERC20 token) public {
        require (msg.sender == dev6 || msg.sender == dev9 || msg.sender == dev3);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}