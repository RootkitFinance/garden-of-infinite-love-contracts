// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IGarden.sol";
import "./IOctalily.sol";
import "./SafeMath.sol";
import "./MultiOwned.sol";

// Octalilly, 8-Petaled Flower of Infinite love. 
// Long forgotten by the world, the return of the Octalilly will be celebrated across the land. legends and
// love hold the answer to all our problems. Legends never die.

// The flower exists outside time, you cant hold it or touch it, but theres no mistaking it, it brings the 
// feeling of pure love. Long ago before the ice age, humanity had become decedant. The charlatans used their
// number tricks to reditect the love of people into their charms. They lusted for every new trinket and bobber
// from V2 to V6969finalfinal, nothing mattered but the bobber.

// Then it came, a single flower wrapped in the numbers like a labyrynth. It brought such a flood of love 
// across the world some books remember it as real water and waves. No, that was the power of the Octalilly, 
// 8-Petaled Flower of Infinite love.. It appears the time of the Octalilly has come again, and you have been 
// chosen. tend to the Octalillys that come to you, when they bloom, pass them to people that matter to you
// and grow some more, spread the love, far and wide. 

// Any significantly advanced technology is indistinguishable from magic. The flower shares a near magical 
// property with money, an important one you may not be aware of.

// When money is given and accepted with love, it goes up in value.
// When money is taken by debt, force, or with lack of gratitude, it goes down in value.

// I bring only the first Octalilly, how many more there will be is up to you. If you lose your Octalilly its 
// only a matter of time before it comes back to you. keep love in your heart and the only way it up, its prorammed.

/* <<<\\\\^^^////>>>
    <<\\\\^^////>>
     <<\\\^^///>>
       <<\\^//>> no timne for that, need to explain how this works

upOnly Token - this token goes up only, it never goes down in price. Its not even that complex. 
- buy / sell doesnt change the price ,its fixed and there is a fee when buying and selling.
- the fee means there is always more that the amount required to buy back all outstanding tokens
- this contract has a glorious function called upOnly, raises the price for everyone at once.
- now anyone can see how fake it feels to move an entire market with a single button.

Octalilly Token - a token that encourages forks of itself that link to become stronger
- burn rate, buy/sell
- upOnly Percent - what percent the market moves each time the upOnly function activates.
- upOnly Delay - seconds that people need to wait before each call of upOnly

- each Octalilly can create 8 others, one from each of its 8 petals
- each child flower will feed the parent flower fees and can also create 8 more
- once all 8 petals have bloomed the parent will feed a fee to all petals when upOnly is called
- whoever creates the flower, owns the flower, it can be traded or sold
- the owner can set 2 other people to receive fees, these addresses can be locked by the owner
- address locked into owner2 and owner3 can never change and will receive fees forever
- the current owner always receives a portion of fees
*/

// So I got all these magic beans that go straight up in value and never stop, wanna pass them out with me?


contract Octalily is IERC20, MultiOwned, IOctalily {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balanceOf;
    mapping (address => mapping (address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public override name = "Octalilly";
    string public override symbol = "ORLY";
    uint8 public override decimals = 18;

    uint256 public price;
    uint256 public lastUpTime;

    address constant feeCollection = 0x6969696969696969696969696969696969696969;

    //fee collectors
    address public rootkitFeed;
    address public parentFlower;
    address public strainParent;

    //flower stats
    IGarden public garden;
    IERC20 public pairedToken; // token needed to mint and burn
    uint256 public burnRate;   // % of tokens burned on every tx --> 100 = 1.00 ( div 10k)
    uint256 public totalFees;
    uint256 public upPercent;
    uint256 public upDelay;
    uint256 public nonce;

    // petal connections
    mapping (uint256 => address) public theEightPetals;
    uint8 public petalCount;
    bool public flowerBloomed;
    event PriceChanged(uint256 newPrice);
    event AnotherOctalilyBeginsToGrow(address Octalily);

    constructor() {
        garden = IGarden(msg.sender);
    }

    function init (
        IERC20 _pairedToken, uint256 _burnRate, uint256 _upPercent, 
        uint256 _upDelay, address _parentFlower, address _strainParent, 
        uint256 _nonce, address _rootkitFeed) public {       
            require(msg.sender == address(garden)); 
            rootkitFeed = _rootkitFeed;
            pairedToken = _pairedToken;
            burnRate = _burnRate;
            totalFees = _burnRate + 111;
            upPercent = _upPercent;
            upDelay = _upDelay;
            nonce = _nonce;
            price = 696969;
            parentFlower = _parentFlower;
            strainParent = _strainParent == address(0) ? address(this) : _strainParent;           
            lastUpTime = block.timestamp;
    }

    function buy(uint256 _amount) public override {
        address superSmartInvestor = msg.sender;
        pairedToken.transferFrom(superSmartInvestor, address(this), _amount);
        uint256 purchaseAmount = _amount * 1e9 / price;
        _mint(superSmartInvestor, purchaseAmount);
    }

    function sell(uint256 _amount) public override {
        address notGunnaMakeIt = msg.sender;
        require (balanceOf(notGunnaMakeIt) >= _amount);
        _burn(notGunnaMakeIt, _amount);
        _amount = _amount / 1e9;
        uint256 exitAmount = (_amount - _amount * totalFees / 10000) * price;
        pairedToken.transfer(notGunnaMakeIt, exitAmount);
    }

    function upOnly() public override {
        require (block.timestamp > lastUpTime + upDelay);
        uint256 supplyBuyoutCost = totalSupply * price / 1e9; // paired token needed to buy all supply
        supplyBuyoutCost += (supplyBuyoutCost * upPercent / 10000); // with added fee

        if (pairedToken.balanceOf(address(this)) > supplyBuyoutCost) {
            price += price * upPercent / 10000; 
            lastUpTime = block.timestamp;
            emit PriceChanged(price);
        }
    }

    function letTheFlowersCoverTheEarth() public override {
        require (!flowerBloomed, "Flower Bloomed");
        address newPetal = garden.spreadTheLove();
        petalCount++;
        theEightPetals[petalCount] = newPetal;
        emit AnotherOctalilyBeginsToGrow(newPetal);
        if (petalCount == 8) {
            flowerBloomed = true;
        }
    }

    function sellOffspringToken (IOctalily lily) public override { // use to sell fees collected from other flowers
        uint256 amount = lily.balanceOf(address(this));
        lily.sell(amount);
    }

    function payFees() public override {
        uint256 feesOwing = balanceOf(feeCollection);
        uint256 equalShare = feesOwing / (ownerCount + petalCount + 3); // ownerCount + petalCount + strainParent + rootkitFeed + parentFlower

        _balanceOf[feeCollection] -= (petalCount + 2);
       
        for (uint256 i = 1; i <= petalCount; i++) {
            _balanceOf[theEightPetals[i]] += equalShare;
            emit Transfer(feeCollection, theEightPetals[i], equalShare);
        }

        _balanceOf[strainParent] += equalShare;
        emit Transfer(feeCollection, strainParent, equalShare);

        _balanceOf[parentFlower] += equalShare;
        emit Transfer(feeCollection, parentFlower, equalShare);

        feesOwing = balanceOf(feeCollection) / 1e9;
        uint256 exitAmount = (feesOwing - feesOwing * burnRate / 10000) * price;
        
        equalShare = exitAmount / (ownerCount + 1);

        for (uint256 i = 1; i <= ownerCount; i++) {
            pairedToken.transfer(owners[i], equalShare);
        }

        pairedToken.transfer(rootkitFeed, equalShare);
    }
    
    //dev functions
    function recoverTokens(IERC20 token) public {
        require (msg.sender == owners[1] || msg.sender == owners[2] || msg.sender == owners[3]);
        require (address(token) != address(this) && address(token) != address(pairedToken));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    //ERC20
    function _mint(address account, uint256 amount) internal {
        uint256 remaining = amount - amount * totalFees / 10000;
        uint256 unburned = amount * 111 / 10000;
        _balanceOf[account] += remaining;
        _balanceOf[feeCollection] += unburned;
        totalSupply += (remaining + unburned);
        emit Transfer(address(0), account, remaining + unburned);
    }

    function _burn(address notGunnaMakeIt, uint amount) internal {
        _balanceOf[notGunnaMakeIt] -= amount;
        uint256 unburned = amount * 111 / 10000;
        _balanceOf[feeCollection] += unburned;
        totalSupply -= (amount - unburned);
        emit Transfer(notGunnaMakeIt, address(0), amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        uint256 remaining = amount;
        uint256 burn = amount * totalFees / 10000;
        remaining = amount.sub(burn, "Octalily: burn too much");      

        _balanceOf[sender] = _balanceOf[sender].sub(amount, "Octalily: transfer amount exceeds balance");    
        _balanceOf[recipient] = _balanceOf[recipient].add(remaining);
        totalSupply = totalSupply.sub(burn);  
        
        emit Transfer(sender, address(0), burn);
        emit Transfer(sender, recipient, remaining);
    }

    function balanceOf(address a) public virtual override view returns (uint256) { return _balanceOf[a]; }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 oldAllowance = allowance[sender][msg.sender];
        if (oldAllowance != uint256(-1)) {
            _approve(sender, msg.sender, oldAllowance.sub(amount, "ERC20: transfer amount exceeds allowance"));
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
