pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WaffleToken is IERC20 {
    string public constant name = "WaffleToken";
    string public constant symbol = "WFL";
    uint8 public constant decimals = 18;

    mapping(address => uint) balances;
    address[] private _holders;
    mapping(address => mapping (address => uint256)) allowed;


    constructor(uint _initialBalance) {
        balances[msg.sender] = _initialBalance;
        _holders.push(msg.sender);
    }

    function totalSupply() external view override returns (uint256 supply) {
        for (uint i = 0; i < _holders.length; i++) {
            supply += balances[_holders[i]];
        }
        return supply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }

    modifier preCheck(address sender, address recipient, uint256 amount) {
        require(sender != address(0), "Sender should be a valid addresse");
        require(recipient != address(0), "Recipient should be a valid addresse");
        require(amount > 0, "The amount transfered should be superior to 0");
        require(balances[sender] >= amount, "Sender balance should be superior to amount transfered");
        _;
    }

    function transfer(address recipient, uint256 amount) external preCheck(msg.sender, recipient, amount) override returns (bool) {
        if (balances[recipient] == 0) {
            _holders.push(recipient);
        }
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        return true;         
    }
    
    
    // Part 2
    function approve(address delegate, uint256 amount) public override returns (bool) {
        allowed[msg.sender][delegate] = amount;
        return true;
    }


    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    modifier accessControl(address sender, address recipient, uint256 amount) {
        require(sender != address(0), "Sender should be a valid addresse");
        require(recipient != address(0), "Recipient should be a valid addresse");
        require(amount > 0, "The amount transfered should be superior to 0");
        require(balances[sender] >= amount, "Sender balance should be superior to amount transfered");
        require(allowed[sender][msg.sender] >= amount, "Sender balance should be superior to amount transfered");
        _;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external preCheck(sender, recipient, amount) override returns (bool) {
        if (balances[recipient] == 0) {
            _holders.push(recipient);
        }
        balances[sender] -= amount;
        balances[recipient] += amount;
        allowed[sender][msg.sender] -= amount;
        return true;
    }

}
