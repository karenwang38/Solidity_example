pragma solidity ^0.4.24;

//以下是solidity智能合约代码
contract ExampleContract {

  event ReturnValue(address indexed _from, int256 _value);

  function foo(int256 _value) view returns (int256) {
    ReturnValue(msg.sender, _value);
    return _value;
  }

}
