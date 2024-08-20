// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MockIERC20 is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances; 

    // constructor(uint256 initialSupply) /*ERC20("Mock Token", "MTKN")*/ {
    //     mint(msg.sender, initialSupply);
    // }

    // function mint(address to, uint256 amount) public virtual {
    //     mint(to, amount);
    // }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(amount <= _balances[msg.sender], "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    function allowance(address owner, address spender) external pure override returns (uint256) {
        return 0; // Stubbed out return value
    }

    function totalSupply() external pure override returns (uint256) {
        return 0; // Stubbed out return value
    }

    function transferFrom(address from, address to, uint256 value) external pure override returns (bool) {
        return false; // Stubbed out return value
    }
}
