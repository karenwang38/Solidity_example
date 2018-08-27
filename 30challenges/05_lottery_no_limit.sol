pragma solidity ^0.4.24;

/*
05_lottery_no_limit
- user has to pay 0.1 ether to join the lottery
- no limit for users number
- same user can join multiple times
- owner of the contract can join too
- owner decides when to pick the winner
- winner receives all the money
- new lottery starts when the winner is pickecd
*/

contract LotteryLimit {
    address owner;           //owner address
    //uint limitNum = 0;       //number of participants
    uint randNonce = 0;
    uint randomWinner;        //Winner number
    uint _Unit = 10**17;      //0.1 Eth
    address[] participant;      //participant address array



    //save address of contract  owner
    constructor()
    {
        owner = msg.sender;
    }

     // 限定只有合約部屬人才能執行特定function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //event ReturnWinner(address[] indexed _from, uint _value);
    event ReturnWinner(address[], uint _value);

    /*
    //start a lottery : set the number of participant
    function SetParticipantNum(uint _Num) public returns (uint) {
        // check lottery is end
        require (this.balance == 0, "lottery is on-going");

        limitNum = _Num;
        return limitNum;
    }
    */

    //1 Unit = 0.1 Eth
    function BuyLottery () public payable returns (bool success) {

        //
        //require (limitNum != 0, "Number of participant not configure");

        randNonce ++;
        //0.1 Eth and only 10 participants to join lottery
        //require(msg.value == _Unit && randNonce <= limitNum, "only %_Unit Eth once! OR the number of participants are full.");
        require(msg.value == _Unit, "only %_Unit Eth once!");

        //record i-th participant with address
        participant.push(msg.sender);
        return true;
    }

    //use keccak256 to gen random function only by contract owner
    function Winner () public onlyOwner {

        //10 people to get a winner
        //require (randNonce == limitNum, "participats not full");
        randomWinner =uint(keccak256(now, msg.sender, randNonce)) % randNonce;  //get winner

        participant[randomWinner].transfer(this.balance);   //transfer all eth from contract to winner

        ReturnWinner(participant, randomWinner);

        //delete participant;
        delete participant;
        randNonce = 0;    //restart lottery
        //limitNum = 0;
    }

    //get parameter of random()
    function getPeopleList () public view returns (address[]) {
        return participant;
    }

    //get balance of contractO
    function getBalanceContract () public view returns (uint256) {
        return this.balance;
    }

}
