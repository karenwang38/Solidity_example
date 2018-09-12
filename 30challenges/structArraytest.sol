pragma solidity ^0.4.22;


contract test {

  struct info {
    string name;
    uint age;
  }

  info[] public peopleInfo;

  constructor() {
    peopleInfo.push(info('karen', 35));
  }

  function addInfo(string _name, uint _age) returns(bool success) {
      peopleInfo.push(info(_name, _age));
  }

  function getInfo(uint _idx) public view returns(string, uint) {
      return (peopleInfo[_idx].name, peopleInfo[_idx].age);
  }

}
