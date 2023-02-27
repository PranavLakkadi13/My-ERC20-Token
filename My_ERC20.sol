// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20Standard{
    // function name() external view returns (string memory);
    // function symbol() external view returns (string memory);
    // function decimals() external view returns (uint8);
    
    // this 3 functions are the mandatory functions to be implemented 
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenowner) external view returns(uint);
    function transfer(address to, uint256 tokens) external returns(bool);

    // this next 3 functions are used as creditor
    // where eg account A gives permission to account B permission to spend money of account A upto a limit
    // very similar to the credit card -->
    function transferFrom(address from, address to, uint256 tokens) external returns (bool);
    function approve(address spender, uint256 tokens) external returns (bool);
    function allowance(address tokenowner, address spender) external view returns (uint);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenowner, address indexed spender, uint256 tokens);

}

contract Cryptos is ERC20Standard {
    // since we created the public variable we by default created the above mentioned functions
    string public constant name = "cryptos"; 
    string public constant symbol = "CRPT";
    uint public constant decimals = 0;

    uint public override totalSupply;

    address public founder;
    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;
    // 0x12111... (owner) allows 0x1111223.. (spender) --> 1000 tokens;
    // allowed[0x12111...][0x11111123..] = 1000 tokens;

    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenowner) public view override returns(uint){
        return balances[tokenowner];
    }

    function transfer(address to, uint256 tokens) public override returns(bool){
        require(balances[msg.sender] >= tokens, "ERROR: low on balance");

        balances[to] += tokens;
        balances[msg.sender] -= tokens;

        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // the allowance function is like a getter function for the allowed mapping
    function allowance(address tokenowner, address spender) public view override returns(uint){
        return allowed[tokenowner][spender];
    }

    function approve(address spender, uint256 tokens) public override returns(bool){
        require(balances[msg.sender] >= tokens, "Error: low on balance");
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender,spender,tokens);
        
        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns(bool){
        require(allowed[from][msg.sender] >= tokens);
        require(balances[from] >= tokens);
        
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);
        return true;
    }
}
