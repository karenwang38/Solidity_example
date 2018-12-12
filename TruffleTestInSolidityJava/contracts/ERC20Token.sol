pragma solidity ^0.4.22;
import "./ERC20_interface.sol";
/*
- intial supply of tokens is set on creation
- contract creator gets initial tokens
- tokens can be transferred to any account
- there is a protection from overflow
- everyone can check balances
*/


/// @title basicToken
/// @notice creat a basic token
/// @dev contract owner creat a token with name and number.
contract ERC20Token is ERC20_interface {

  /// @notice token name
  string public name;

  /// @notice token symbol
  string public symbol;

  /// @notice decimals
  uint8 public decimals;

  /// @notice
  uint256 public totalsupply;

  address contractOwner;  //contract owner address

  address caller_addr ; // caller address

  uint private weiToEther = 10 ** 18;

  /// @notice max value for overflow
  uint256 constant private MAX_UINT256 = 2 ** 256 - 1;

  /// @notice token balance of address
  mapping(address => uint256) public balances;
  /// @notice
  mapping(address => mapping(address => uint256)) public allowed;


  /// @notice token creator base on contract owner
  address public owner;
  /// @notice token owner number

  struct TokenOwner {
    address ownerAddr;
    uint  ownerBalance;
  }

  /// @notice address with token balance
  mapping(address => uint) tokenbalance;

  /// @notice tokenowner array to recore all address with token balance
  TokenOwner[] public tokenowner;

  /// @notice give name and token number
  /// @dev
  /// @return success
  constructor() public {
      owner = msg.sender;
      name = "KW";
      symbol = "0_0";
      decimals = 18;

      contractOwner = msg.sender;

      uint256 initialSupply = 1000;
      totalsupply = initialSupply * 10 ** uint256(decimals);
      balances[owner] = totalsupply;


      tokenbalance[owner] = totalsupply;
      tokenowner.push(TokenOwner(owner, totalsupply));
  }

  // 限定只有合約部屬人才能執行特定function
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


/// @notice show token total supply
/// @dev
/// @return uint256
  function totalSupply() public view returns (uint256) {
    return totalsupply;
  }
  //ERC20 definition

  /// @notice check balance of token for certain address
  /// @dev
  /// @param _owner
  /// @return balance
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  /// @notice transfer token to a address
  /// @dev
  /// @param _to, _value
  /// @return balance
  function transfer(address _to, uint256 _value) returns(bool success) {
    require(balances[msg.sender] >= _value);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
  }


  // 從某一人地址轉給另一人地址，需要其轉帳配額有被同意，可想像為小明(msg.sender)用爸爸的副卡(_from) 進行消費 (_to)
  /// @notice transfer token from address a to address b by msg.sender
  /// @dev
  /// @param _from, _to, _value
  /// @return bool
  function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
    uint256 allowance = allowed[_from][msg.sender];
    require(balances[_from] >= _value && allowance >= _value);
    balances[_to] += _value;
    balances[_from] -= _value;
    if (allowance < MAX_UINT256) {
      allowed[_from][msg.sender] -= _value;
    }
    Transfer(_from, _to, _value);
    return true;
  }

  /// @notice Allows _spender to withdraw from your account multiple times, up to the _value amount. If this function is called again it overwrites the current allowance with _value.
  /// @dev
  /// @param _spender, _value
  /// @return bool
  function approve(address _spender, uint256 _value) public returns(bool success) {
    require(balances[msg.sender] >= _value);
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }


  /// @notice return allowance from _owner to _spender
  /// @dev
  /// @param _owner, _spender
  /// @return remaining
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  //show any eth balance of account
  function balanceAny(address anyaddr) public view returns (uint256 balance) {
      return anyaddr.balance;
  }

  //show address who deploied contract
  function addr_deployer() public view returns (address) {
      return contractOwner;
  }

  //show address who call the cantract
  function addr_caller() public view returns (address) {
      return msg.sender;
  }

  //caller transfer Eth to any account
  function caller_transfer(address addr) public payable returns (bool success) {
      require(msg.sender.balance >= msg.value);
      addr.transfer(msg.value);
      return true;
  }


  //only deployer can trasfer Eth to other account
  function deployer_transfer(address addr) public onlyOwner payable returns (bool success) {
      require(msg.sender.balance >= msg.value);
      addr.transfer(msg.value);
      return true;
  }

  //show balance of contract
  function getContractBalance() public view returns (uint256 balance){
      return this.balance;
  }

  //show address of contract
  function getContractAddrees() public view returns (address){
      return this;
  }

  //transfer eth to contract address
  function transferto_contract() public payable returns (bool success){
      caller_addr = msg.sender;
      require(caller_addr.balance >= msg.value);
      return true;
  }

  //only deployer can transfer eth to the contract
  function deployer_transTocontract() public onlyOwner payable returns (bool success){
      caller_addr = msg.sender;
      require(caller_addr.balance >= msg.value);
      return true;
  }

  //the contract transfer Eth any account
  function withdraw(uint amount) public {
      require(this.balance >= amount * weiToEther);
      caller_addr = msg.sender;
      caller_addr.transfer(amount * weiToEther);
  }

  //the contract transfer Eth only deployer
  function deployer_withdraw(uint amount) public onlyOwner {
      require(this.balance >= amount * weiToEther);
      caller_addr = msg.sender;
      caller_addr.transfer(amount * weiToEther);
  }

}
