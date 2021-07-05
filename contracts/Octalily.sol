// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IERC20.sol"; 
import "./Owned.sol";
import "./IGarden.sol";
import "./IOctalily.sol";

contract Octalily is Owned, IOctalily {
 
    mapping (address => uint256) internal _balanceOf;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    uint256 public totalSupply;
    uint256 public price;
    uint256 public lastUpTime;

    string public name = "Octalilly"; 
    string public symbol = "ORLY";
    uint8 public decimals = 18;

    address constant feeCollection = 0x6969696969696969696969696969696969696969;

    //fee collectors
    address public immutable rootkitFeed;
    address private immutable dev3;
    address private immutable dev6;
    address private immutable dev9;
    address public immutable parentFlower;
    address public immutable strainParent;
    address public owner2;
    bool public owner2Locked;
    address public owner3;
    bool public owner3Locked;
    // owner is 9th collector

    function sharingIsCaring(address _owner2, address _owner3) public ownerOnly { // owner can share 2/3 of their fees, split between 2 address or given all to 1
        if (!owner2Locked) { owner2 = _owner2; }
        if (!owner3Locked) { owner3 = _owner3; }
    }

    function lockOwners(bool OTwo, bool OThree) public ownerOnly { // fees can be locked, make your loved ones secure
        if (!owner2Locked) { owner2Locked = OTwo; }
        if (!owner3Locked) { owner3Locked = OThree; }
    }


    //flower stats
    IGarden public immutable garden;
    IERC20 public immutable pairedToken; // token needed to mint and burn
    uint256 public immutable burnRate;   // % of tokens burned on every tx --> 100 = 1.00 ( div 10k)
    uint256 public immutable totalFees;
    uint256 public immutable upPercent;
    uint256 public immutable upDelay;
    uint256 public immutable nonce;

    // petal connections
    mapping (uint256 => address) public theEightPetals;
    uint8 petalCount;
    bool public flowerBloomed;
    bool public wavelength;


    function letTheFlowersCoverTheEarth() public override {
        require (!flowerBloomed);
        garden.spreadTheLove();
        petalCount++;
        theEightPetals[petalCount] = msg.sender; // @ DEV: need to get the new flower address here
    }

    constructor(
        IERC20 _pairedToken, uint256 _burnRate, uint256 _upPercent, 
        uint256 _upDelay, address _dev3, address _dev6, 
        address _dev9, address _parentFlower, address _strainParent, uint256 _nonce,
        address _owner, address _rootkitFeed) {
            garden = IGarden(msg.sender);
            dev3 = _dev3;
            dev6 = _dev6;
            dev9 = _dev9;
            rootkitFeed = _rootkitFeed;
            pairedToken = _pairedToken;
            burnRate = _burnRate;
            totalFees = _burnRate + 111;
            upPercent = _upPercent;
            upDelay = _upDelay;
            nonce = _nonce;
            price = 696969;
            parentFlower = _parentFlower;
            strainParent = _strainParent;
            owner = _owner;
            owner2 = _owner;
            owner3 = _owner;
    }
    
    function payFees() public override {
        uint256 feesOwing = balanceOf(feeCollection);
        uint256 equalShare = feesOwing / 9;
        _balanceOf[feeCollection] -= feesOwing;
        if (flowerBloomed) {
            equalShare = feesOwing / 16;
            waveOfLove(equalShare);
        }
        else {
            _balanceOf[strainParent] += equalShare;
        }
        _balanceOf[dev3] += equalShare;
        _balanceOf[dev6] += equalShare;
        _balanceOf[dev9] += equalShare;
        _balanceOf[rootkitFeed] += equalShare;
        _balanceOf[parentFlower] += equalShare;
        _balanceOf[owner] += equalShare;
        _balanceOf[owner2] += equalShare;
        _balanceOf[owner3] += equalShare;
    }

    function upOnly() public override {
        require (block.timestamp > lastUpTime + upDelay);
        uint256 supplyBuyoutCost = totalSupply * price / 1e18; // paired token needed to buy all supply
        supplyBuyoutCost += supplyBuyoutCost * upPercent / 10000; // with added fee

        if (pairedToken.balanceOf(address(this)) < supplyBuyoutCost) {
            price += price * upPercent / 10000; 
            lastUpTime = block.timestamp;

            if (flowerBloomed){
                uint256 wavePower = totalSupply * 69 / 100000;
                waveOfLove(wavePower);
                totalSupply += (wavePower * 8);
            } 
        }
    }

    function waveOfLove(uint256 givingWithLove) internal {
            _balanceOf[theEightPetals[1]] += givingWithLove;
            _balanceOf[theEightPetals[4]] += givingWithLove;
            _balanceOf[theEightPetals[7]] += givingWithLove;
            _balanceOf[theEightPetals[2]] += givingWithLove;
            _balanceOf[theEightPetals[5]] += givingWithLove;
            _balanceOf[theEightPetals[8]] += givingWithLove;
            _balanceOf[theEightPetals[3]] += givingWithLove;
            _balanceOf[theEightPetals[6]] += givingWithLove;
    }

    function buy(uint256 _amount) public override {
        address superSmartInvestor = msg.sender;
        pairedToken.transferFrom(superSmartInvestor, address(this), _amount);
        uint256 purchaseAmount = _amount * 1e18 / price;
        _mint(superSmartInvestor, purchaseAmount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        uint256 remaining = amount - amount * totalFees / 10000;
        uint256 unburned = amount - amount * 111 / 10000;
        _balanceOf[account] += remaining;
        _balanceOf[feeCollection] += unburned;
        totalSupply += (remaining + unburned);
        emit Transfer(address(0), account, remaining + unburned);
    }

    function sell(uint256 _amount) public override {
        address notGunnaMakeIt = msg.sender;
        _burn(notGunnaMakeIt, _amount);
        _amount = _amount / 1e18;
        uint256 exitAmount = (_amount - _amount * totalFees / 10000) * price;
        pairedToken.transfer(notGunnaMakeIt, exitAmount);
    }

    function _burn(address notGunnaMakeIt, uint amount) internal virtual {
        _balanceOf[notGunnaMakeIt] -= amount;
        uint256 unburned = amount * 111 / 10000;
        _balanceOf[feeCollection] += unburned;
        totalSupply -= (amount - unburned);
        emit Transfer(notGunnaMakeIt, address(0), amount);
    }

    function balanceOf(address _account) public view override returns (uint256) {
        return _balanceOf[_account]; 
    }

    function recoverTokens(IERC20 token) public {
        require (msg.sender == dev3 || msg.sender == dev6 || msg.sender == dev9);
        require (address(token) != address(this) && address(token) != address(pairedToken));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function sellOffspringToken (IOctalily lily) public override { 
        uint256 amount = lily.balanceOf(address(this));
        lily.sell(amount);
    }
}
