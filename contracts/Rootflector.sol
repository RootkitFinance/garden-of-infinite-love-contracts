// SPDX-License-Identifier: U-U-U-UPPPPP!!!
pragma solidity ^0.7.6;

import "./ERC20.sol";
import "./Owned.sol";
import "./SafeMath.sol";
import "hardhat/console.sol";

contract Rootflector is ERC20, Owned {
    using SafeMath for uint256;

    uint256 public rootflectionFee;
    bool public rootflectionEnabled;
    uint256 public totalPaid;
    mapping (address => uint256) public paid;


    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
    }

    function enableRootflection() public ownerOnly() {
        rootflectionEnabled = true;
    }

    function setRootflectionFee(uint256 _rootflectionFee) public ownerOnly() {
        rootflectionFee = _rootflectionFee;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        if (!rootflectionEnabled) {
            _balanceOf[sender] = _balanceOf[sender].sub(amount, "ERC20: transfer amount exceeds balance");
            _balanceOf[recipient] = _balanceOf[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
            return;
        }

        uint256 fee = amount.mul(rootflectionFee).div(10000);
        uint256 rootflection = pendingReward(sender);
        uint256 remaining = amount.sub(fee);

        _balanceOf[sender] = _balanceOf[sender].add(rootflection).sub(amount, "ERC20: transfer amount exceeds balance");
        _balanceOf[address(this)] = _balanceOf[address(this)].sub(rootflection).add(fee);
        _balanceOf[recipient] += remaining;
        paid[sender] += rootflection;
        totalPaid += rootflection;
        
        emit Transfer(sender, address(this), fee);
        emit Transfer(address(this), sender, rootflection);
        emit Transfer(sender, recipient, remaining);
    }

    function balanceOf(address account) public override view returns (uint256) {
        return _balanceOf[account] + pendingReward(account);
    }

    function pendingReward(address account) public view returns (uint256) {
        if (account == address(this)) { return 0; }
        
        uint256 accountRewards = _balanceOf[address(this)].mul(_balanceOf[account]).mul(1e18).div(totalSupply).div(1e18);
        uint256 alreadyPaid = paid[account];
        return accountRewards > alreadyPaid ? accountRewards - alreadyPaid : 0;
    }
}