pragma solidity ^0.4.24;
/*
04_lottery_10_users
- 10 users limit
- user has to pay 0.1 ether to join the lottery
- same user can join once
- owner of the contract can join the lottery
- when 10 users join then the winner is picked
- winner receives all the money
- new lottery starts when the winner is pickecd
*/

contract Lottery {
    uint limitNum = 0;       //number of participants
    uint randNonce = 0;
    uint randomWinner;        //Winner number
    uint _Unit = 10**17;      //0.1 Eth
    address[] participant;      //participant address array

    //event ReturnWinner(address[] indexed _from, uint _value);
    event ReturnWinner(address[], uint _value);

    //start a lottery : set the number of participant
    function SetParticipantNum(uint _Num) public returns (uint) {
        // check lottery is end
        require (this.balance == 0, "lottery is on-going");

        limitNum = _Num;
        return limitNum;
    }

    //1 Unit = 0.1 Eth
    function BuyLottery () public payable returns (bool success) {

        //
        require (limitNum != 0, "Number of participant not configure");

        randNonce ++;
        //0.1 Eth and only 10 participants to join lottery
        require(msg.value == _Unit && randNonce <= limitNum, "only %_Unit Eth once! OR the number of participants are full.");

        //record i-th participant with address
        participant.push(msg.sender);
        return true;
    }

    //use keccak256 to gen random function
    function Winner () public {

        //10 people to get a winner
        require (randNonce == limitNum, "participats not full");
        randomWinner =uint(keccak256(now, msg.sender, randNonce)) % limitNum;  //get winner from 1~10

        participant[randomWinner].transfer(this.balance);   //transfer all eth from contract to winner

        ReturnWinner(participant, randomWinner);

        //delete participant;
        delete participant;
        randNonce = 0;    //restart lottery
        limitNum = 0;
    }

    //get parameter of random()
    function getPeopleList () public returns (address[]) {
        return participant;
    }

    //get balance of contractO
    function getBalanceContract () public view returns (uint256) {
        return this.balance;
    }

}
