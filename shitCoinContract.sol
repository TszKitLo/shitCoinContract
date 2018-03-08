pragma solidity ^0.4.0;
contract shitCoin {

    string public constant name = "shitCoin";
    string public constant symbol = "SCN";
    uint8 public constant decimals = 18;
    
    
    address public creator;
    mapping(address => uint256) public balances;
    mapping(address => bool) public actives;
    mapping(address => mapping(address => uint256)) public allowed;
    uint256 TotalSupply;
    
    function shitCoin (uint256 _totalSupply) public{
        creator = msg.sender;
        TotalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }
    
    modifier isCreator() {
       if (msg.sender != creator) {
            revert();
        }
    
        _;
    }
    
    function maxSupply () public constant returns (uint256){
        return TotalSupply;
    }
    
    function BalanceOf (address _owner) public constant returns (uint256){
        return balances[_owner];
    }
    
    function getCreator () public constant returns (address){
        return creator;
    }
    
    function setActive () public{
        actives[msg.sender] = true; 
    }
    
    function setInactive () public{
        actives[msg.sender] = false; 
    }
    
    function getActive () public constant returns (bool){
        return actives[msg.sender]; 
    }
    
    function transfer(address _to, uint256 _value) public payable returns (bool){
        if(_value <= balances[msg.sender] && _value > 0 && actives[_to]){
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        if( actives[_from] && actives[_to] 
            && _value <= balances[_from] && _value <= allowed[_from][_to]
            && _value > 0){
            
            balances[_from] -= _value;
            balances[_to] += _value;
            
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }
    
    function approve(address _spender, uint256 _value) public returns (bool){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance (address _owner, address _spender) public constant returns (uint256){
        return allowed[_owner][_spender];
    }
    
    function contractDestruct() public isCreator () {
        selfdestruct(creator);
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}