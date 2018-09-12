pragma solidity ^0.4.22;

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
contract basicToken {

  /// @notice token name
  string public name;
  /// @notice token number
  uint public number;

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
      number = 1000;
      tokenbalance[owner] = number;
      tokenowner.push(TokenOwner(owner, number));
  }

  // transfer event
  event transferEvent (address _from, address _to, uint _number);

  /// @notice transfer token
  /// @dev transfer token to someone
  /// @param _to address, uint _number
  /// @return how many account with token
  function transfer(address _to, uint _number) public returns (bool success) {
      require(tokenbalance[msg.sender] >= _number, 'token number is not enough');
      tokenbalance[msg.sender] = tokenbalance[msg.sender] - _number;
      tokenbalance[_to] = tokenbalance[_to] + _number;

      transferEvent(msg.sender, _to, _number);


      // check address and balance in the tokenowner
      uint receiveCnt = 0;
      for(uint i = 0; i < tokenowner.length; i++) {

          //update tokenowner for sender
          if(tokenowner[i].ownerAddr == msg.sender) {
            tokenowner[i].ownerBalance = tokenbalance[msg.sender];
          }

          //update tokenowner for reveiver
          if(tokenowner[i].ownerAddr == _to) {
              tokenowner[i].ownerBalance = tokenbalance[_to];
              receiveCnt++;
          }
      }

      //add to tokenowner for new onwer
      if(receiveCnt == 0) {
          tokenowner.push(TokenOwner(_to, tokenbalance[_to]));
      }

      return true;
  }

  /// @notice
  /// @dev
  /// @param _addr address
  /// @return uint
  function getBalance(address _addr) public view returns (uint) {
      return tokenbalance[_addr];
  }


}
