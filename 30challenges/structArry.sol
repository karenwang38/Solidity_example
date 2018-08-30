pragma solidity ^0.4.24;

contract test {

    struct PersonData {
        address Addr;
        uint Num;
    }

    uint participantNum = 0;

    mapping (uint => PersonData) persondata; //key-vale, key is uint type and value is PersonData struct type


    //msg.sender input a num
    function Add(uint _Num) public returns (address, uint, uint) {
        persondata[participantNum].Addr = msg.sender;
        persondata[participantNum].Num = _Num;
        participantNum ++;
        return (msg.sender, _Num, participantNum);
    }

    function getData(uint _num) public view returns (uint, address, uint) {
        return (participantNum, persondata[_num].Addr, persondata[_num].Num);
    }
}
