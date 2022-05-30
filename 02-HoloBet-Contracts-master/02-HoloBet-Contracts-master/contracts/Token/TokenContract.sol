// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../interfaces/IERC20Extension.sol";

contract TokenContract is Context, IERC20Extension {
    
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    address private owner_;
    mapping (address => bool) private minters;

    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 private constant HARD_CAP_SUPPLY = 1e27; // 1B
    uint256 private SEED_ROUND = SafeMath.div(SafeMath.mul(SafeMath.div(HARD_CAP_SUPPLY, 1e3), 1000), 10); // 10%
    uint256 private WHITELIST_ROUND = SafeMath.div(SafeMath.mul(SafeMath.div(HARD_CAP_SUPPLY, 1e3), 1500), 10); // 15%
    uint256 private PRIVATE_ONE = SafeMath.div(SafeMath.mul(SafeMath.div(HARD_CAP_SUPPLY, 1e3), 200), 10); // 2%
    uint256 private PRIVATE_TWO = SafeMath.div(SafeMath.mul(SafeMath.div(HARD_CAP_SUPPLY, 1e3), 500), 10); // 5%
    uint256 private PRIVATE_THREE = SafeMath.div(SafeMath.mul(SafeMath.div(HARD_CAP_SUPPLY, 1e3), 800), 10); // 8%

    constructor (
        string memory name_, 
        string memory symbol_ 
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;

        owner_ = msg.sender;

        addMinter(msg.sender);

        // _mint(msg.sender, initialSupply_); // Pre-sale wallet
    }

    modifier onlyMinter() {
        require(minters[msg.sender] == true, "ERC20: Not a minter");
        _;
    }

    function seedRound() public view override returns (uint256) {
        return SEED_ROUND;
    }

    function whiteList() public view override returns (uint256) {
        return WHITELIST_ROUND;
    }

    function privateOne() public view override returns (uint256) {
        return PRIVATE_ONE;
    }

    function privateTwo() public view override returns (uint256) {
        return PRIVATE_TWO;
    }

    function privateThree() public view override returns (uint256) {
        return PRIVATE_THREE;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function burn(uint256 amount) public override returns (bool) { 
        require(_balances[msg.sender] >= amount);
        _burn(msg.sender, amount);
        return true;
    }

    function burnFrom(address from, uint256 amount) public override returns (bool) { 
        require(_balances[from] >= amount);
        require(amount <= _allowances[from][msg.sender]);
        _burn(from, amount);

        return true;
    }

    function addMinter(address account) public returns (bool) {
        require(msg.sender == owner_, "ERC20: Should be owner to add minter");
        minters[account] = true;
        return true;
    }

    function removeMinter(address account) public returns (bool) {
        require(msg.sender == owner_, "ERC20: Should be owner to remove minter");
        minters[account] = false;
        return true;
    }

    function mint(address account, uint256 amount) public override onlyMinter returns (bool) {
        require(minters[msg.sender] == true, "ERC20: Should be a minter to mint token");
        _mint(account, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(_totalSupply <= HARD_CAP_SUPPLY, "ERC20: cannot exceed total supply");
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}