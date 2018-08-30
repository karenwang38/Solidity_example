pragma solidity ^0.4.24;

contract IfTest {

    uint a = 1;
    uint b = 3;
    uint c = 3;
    address first_addr = 0xC03b2d891464a58e0D13F1c0144F571c139C9627;
    address second_addr = 0x77ee56ab1d8e3a12556e37e7b9283e23501d50eb;
    address third_addr = 0x77ee56ab1d8e3a12556e37e7b9283e23501d50eb;
    address [] participant;
    uint [] pickedNum;
    address [] addrTemp;
    address [] addrList;
    uint private weiToEther = 10 ** 18;

    function check () public {
        if (a == b) {
            c = 1;
        }
    }


    function DataList () public returns (address[], uint []) {
        participant.push(first_addr);
        participant.push(second_addr);
        participant.push(third_addr);

        pickedNum.push(a);
        pickedNum.push(b);
        pickedNum.push(c);



        return (participant, pickedNum);
    }



    //get winer address array
    function getWinerArray (uint _Num) returns (address[], uint) {

        delete addrTemp;
        for (uint i = 0; i < participant.length; i++)
            if (pickedNum[i] == _Num) {
                addrTemp.push(participant[i]);
            }
            require (addrTemp.length > 0, 'No one win the lottery');
            return (addrTemp, addrTemp.length);
    }

    function getAddr() public returns (address []) {
        addrList.push(msg.sender);
        return addrList;
    }

    function deposit() public payable returns (bool) {
        return true;
    }

    function getContractBalance() public view returns (uint256 balance){
        return this.balance;
    }

    function withdraw(uint _mount) public returns (bool) {
        for (uint i = 0; i < addrList.length; i++)
            addrList[i].transfer(_mount * weiToEther);

        return true;
    }



}
