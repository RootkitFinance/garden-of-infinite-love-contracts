// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./IGarden.sol";
import "./IOctalily.sol";
import "./SafeMath.sol";
import "./MultiOwned.sol";

// Octalilly, 8-Petaled Flower of Infinite love. 
// Long forgotten by the world, the return of the Octalilly will be celebrated across the land. 
// Legends and love hold the answers to all our problems. Legends never die, but are born again.

/* 
upOnly Token - this token goes up only, it never goes down in price. Its not even that complex. 
- buy / sell doesnt change the price, its fixed and there is a fee when buying and selling.
- the fee means there is always more than the amount required to buy back all outstanding tokens
- this contract has a glorious function called upOnly, it raises the price for everyone at once.
- Now anyone can see how fake it feels to move an entire market with a single button.

Octalilly Token - a token that encourages forks of itself that link to become stronger
- burn rate, buy/sell
- upOnly Percent - what percent the market moves each time the upOnly function activates.
- upOnly Delay - seconds that people need to wait before each call of upOnly
*/

// So I got all these magic beans that go straight up in value and never stop, wanna pass them out with me?


contract Octalily is IERC20, MultiOwned, IOctalily {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balanceOf;
    mapping (address => mapping (address => uint256)) public override allowance;

    address constant feeCollection = 0x6969696969696969696969696969696969696969;

    uint256 public override totalSupply;

    string public override name = "Octalilly";
    string public override symbol = "ORLY";
    uint8 public override decimals = 18;

    uint256 public price;
    uint256 public lastUpTime;

    //fee collectors
    address public feeSplitter;
    address public strainParent;

    //flower stats
    IGarden public garden;
    IERC20 public pairedToken; // token needed to mint and burn
    uint256 public burnRate;   // % of tokens burned on every tx --> 100 = 1.00 ( div 10k)
    uint256 public upPercent;
    uint256 public upDelay;
    uint256 public nonce;
    uint256 public totalFees;

    // petal connections
    mapping (uint256 => address) public petals;
    uint8 public petalCount;
    event PriceChanged(uint256 newPrice);
    event AnotherOctalilyBeginsToGrow(address Octalily);

    constructor() {
        garden = IGarden(msg.sender);
    }

    function init (IERC20 _pairedToken, uint256 _burnRate, uint256 _upPercent, uint256 _upDelay, uint256 _rootflectionFeeRate, address _strainParent, uint256 _nonce, address _feeSplitter) public {       
        require(msg.sender == address(garden)); 
        feeSplitter = _feeSplitter;
        pairedToken = _pairedToken;
        burnRate = _burnRate;
        upPercent = _upPercent;
        upDelay = _upDelay;
        rootflectionFeeRate = _rootflectionFeeRate;
        nonce = _nonce;
        price = 696969;
        strainParent = _strainParent == address(0) ? address(tx.origin) : _strainParent;           
        lastUpTime = block.timestamp;
        totalFees = rootflectionFeeRate + burnRate + 123;
    }

    function buy(uint256 _amount) public override {
        address superSmartInvestor = msg.sender;
        pairedToken.transferFrom(superSmartInvestor, address(this), _amount);
        uint256 purchaseAmount = _amount / price;
        _mint(superSmartInvestor, purchaseAmount);
    }

    function sell(uint256 _amount) public override {
        address notGunnaMakeIt = msg.sender;
        require (balanceOf(notGunnaMakeIt) >= _amount);
        _burn(notGunnaMakeIt, _amount);
        uint256 exitAmount = (_amount - _amount * totalFees / 10000) * price;
        pairedToken.transfer(notGunnaMakeIt, exitAmount);
    }

    function upOnly() public override {
        require (block.timestamp > lastUpTime + upDelay);
        uint256 supplyBuyoutCost = totalSupply * price; // paired token needed to buy all supply
        supplyBuyoutCost += (supplyBuyoutCost * upPercent / 10000); // with added fee

        if (pairedToken.balanceOf(address(this)) > supplyBuyoutCost) {
            price += price * upPercent / 10000; 
            lastUpTime = block.timestamp;
            emit PriceChanged(price);
        }
    }

    function connectFlower(address newConnection) public override {
        require (msg.sender == address(garden));
        require (petalCount < 6);
        petalCount++;
        petals[petalCount] = newConnection;
    }

    function sellOffspringToken (IOctalily lily) public override { // use to sell fees collected from other flowers
        uint256 amount = lily.balanceOf(address(this));
        lily.sell(amount);
    }

     function payFees() public override {
        uint256 petalShare = balanceOf(feeCollection) / 18;
        _balanceOf[petals[1]] += petalShare;
        emit Transfer(feeCollection, petals[1], petalShare);
        
        if (petalCount == 6) {
            _balanceOf[petals[2]] += petalShare;
            _balanceOf[petals[3]] += petalShare;
            _balanceOf[petals[4]] += petalShare;
            _balanceOf[petals[5]] += petalShare;
            _balanceOf[petals[6]] += petalShare;
            emit Transfer(feeCollection, petals[2], petalShare);
            emit Transfer(feeCollection, petals[3], petalShare);
            emit Transfer(feeCollection, petals[4], petalShare);
            emit Transfer(feeCollection, petals[5], petalShare);
            emit Transfer(feeCollection, petals[6], petalShare);

            _balanceOf[feeSplitter] += petalShare * 12;
            emit Transfer(feeCollection, feeSplitter, petalShare * 12);
        }
        else {
            _balanceOf[feeSplitter] += petalShare * 17;
            emit Transfer(feeCollection, feeSplitter, petalShare * 17);
        }
        _balanceOf[feeCollection] = 0;
    }
    
    //dev functions
    function recoverTokens(IERC20 token) public {
        require (msg.sender == owners[1] || msg.sender == owners[2] || msg.sender == owners[3]);
        require (address(token) != address(this) && address(token) != address(pairedToken));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    //ERC20
    function _mint(address account, uint256 amount) internal {
        uint256 fees = amount * 123 / 10000;
        uint256 burn = amount * burnRate / 10000;
        uint256 reflection = amount * rootflectionFeeRate / 10000;
        uint256 remaining = amount.sub(fees + burn + reflection);
        _balanceOf[account] += remaining;

        _balanceOf[feeCollection] += fees;
        _balanceOf[address(this)] += reflection;
        totalSupply += (amount - burn);
        emit Transfer(address(0), account, remaining);
    }

    function _burn(address notGunnaMakeIt, uint amount) internal {
        _balanceOf[notGunnaMakeIt] -= amount;
        uint256 unburned = amount * 123 / 10000;
        _balanceOf[feeCollection] += unburned;
        totalSupply -= (amount - unburned);
        emit Transfer(notGunnaMakeIt, address(0), amount);
    }

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

    //Rootflection

    uint256 public rootflectionFeeRate;
    uint256 public totalPaid;
    mapping (address => uint256) public paid;

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 remaining = amount;

        uint256 rootflectionFee = amount * rootflectionFeeRate / 10000;
        uint256 rootflectionRewards = pendingReward(sender);

        uint256 burn = amount * burnRate / 10000;
        uint256 fee = amount * 123 / 10000;

        remaining = amount.sub(rootflectionFee + burn + fee);

        _balanceOf[sender] = _balanceOf[sender].add(rootflectionRewards).sub(amount, "ERC20: transfer amount exceeds balance");
        _balanceOf[address(this)] = _balanceOf[address(this)].sub(rootflectionRewards) + rootflectionFee;
        _balanceOf[recipient] += remaining;
        paid[sender] += rootflectionRewards;
        totalPaid += rootflectionRewards;

        totalSupply -= burn;
        _balanceOf[feeCollection] += fee;

        emit Transfer(sender, address(this), rootflectionFee);
        emit Transfer(address(this), sender, rootflectionRewards);
        emit Transfer(sender, address(0), burn);
        emit Transfer(sender, feeCollection, fee);
        emit Transfer(sender, recipient, remaining);
    }

    function balanceOf(address account) public override view returns (uint256) {
        return _balanceOf[account] + pendingReward(account);
    }

    function pendingReward(address account) public view returns (uint256) {
        if (account == address(this)) { return 0; }
        
        uint256 accountRewards = (_balanceOf[address(this)] + totalPaid).mul(_balanceOf[account]).mul(1e18).div(totalSupply).div(1e18);
        uint256 alreadyPaid = paid[account];
        return accountRewards > alreadyPaid ? accountRewards - alreadyPaid : 0;
    }
}
