pragma solidity ^0.4.24;

//以下是solidity智能合约代码
contract ExampleContract {

  int256 Num;
  event ReturnValue(address indexed _from, int256 _value);

  function foo(int256 _value) returns (int256) {
    Num = _value;
    ReturnValue(msg.sender, Num);
    return Num;
  }

}
