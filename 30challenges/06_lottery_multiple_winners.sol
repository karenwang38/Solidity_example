pragma solidity ^0.4.24;

/*
06_lottery_multiple_winners
- no limit for users
- user joins paying 0.1 eth and picking number 1–100
- owner decides when to generate random number (1–100)
- users who picked generated numbers win
- total prize is distributed to all winners

other
- if no one win the game, the lottery eth will save for next game start
- only owner can transfer lottery eth from contrace to the winner


comment
- for loop
- if/else
- address array compare and compute how many same number
*/

contract LotteryMulti {
    address owner;              //owner address
    uint randNonce = 0;         //number of participants
    uint randNumRange = 100;    // random number fron 1-randNumRange (1-100)
    uint randomWinnerNum;       //Winner number
    uint _Unit = 10**17;        //0.1 Eth
    address[] participant;      //participant address array
    address [] ResulAddr;       //Result winer address
    uint [] winnerCnt;          //winter counts
    bool winerShow = false;     //owner have not chose winer number
    uint [] EthTtansfer;        //record Eth transfer
    address [] addrTemp;
    uint totalCnt;              //how many winer counts
    uint ethTrans;              //
    uint [] pickedNum;          //the number people picked


    event WinnerNum (uint, address[], uint []);

    //save address of contract owner
    constructor()
    {
        owner = msg.sender;
        winerShow = true;
    }

     // 限定只有合約部屬人才能執行特定function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //1 Unit = 0.1 Eth
    function BuyLottery (uint _Num) public payable returns (address[], uint []) {

        require (winerShow, "winer already come out. It will get again after lottery totally end (winer withdraw the lottery)");
        randNonce ++;
        //0.1 Eth and only 10 participants to join lottery
        //require(msg.value == _Unit && randNonce <= limitNum, "only %_Unit Eth once! OR the number of participants are full.");
        require(msg.value == _Unit, "only %_Unit Eth once!");

        //record i-th participant with address and the number who picked
        participant.push(msg.sender);
        pickedNum.push(_Num);
        return (participant, pickedNum);
    }

    /* test for Winner function
    //find winner Number
    function WinNum () public returns (uint) {
        randomWinnerNum =1 + uint(keccak256(now, msg.sender, randNonce)) % randNumRange;  //get winnerNum (1-100)
        return randomWinnerNum;
    }

    //get winer address array
    function getWinerArray (uint _Num) returns (address[]) {
        delete addrTemp;
        for (uint i = 0; i < participant.length; i++)
            if (pickedNum[i] == _Num) {
                addrTemp.push(participant[i]);
            }
            require (addrTemp.length > 0, 'No one win the lottery');
            return addrTemp;
    }
    */


    //use keccak256 to gen random function only by contract owner
    //function Winner (uint _Num) public onlyOwner returns (uint, address[], uint []) {
    function Winner () public onlyOwner returns (uint, address[], uint []) {

        require (randNonce !=0 , "No body join");
        require (winerShow, "winer already come out. It will get again after lottery totally end (winer withdraw the lottery)");

        randomWinnerNum =1 + uint(keccak256(now, msg.sender, randNonce)) % randNumRange;  //get winnerNum (1-100)
        //randomWinnerNum = _Num;

        //get the winer address array
        delete addrTemp;
        for (uint i = 0; i < participant.length; i++) {
            if (pickedNum[i] == randomWinnerNum)
            {
                addrTemp.push(participant[i]);
            }
        }

        if (addrTemp.length == 0) {
            WinnerNum (randomWinnerNum, ResulAddr, winnerCnt);
            return (randomWinnerNum, ResulAddr, winnerCnt);
        }
        //require (addrTemp.length > 0, 'No one win the lottery');

        //get final winer address and winer count
        //ResulAddr, winnerCnt
        uint cnt = 1;   //one winer cnt
        totalCnt = 1; // total winer cnt
        for (uint k = 0; k < addrTemp.length; k++) {
            if (addrTemp[k] != 0) {
                    ResulAddr.push(addrTemp[k]);  //record winer addr
                      for (uint j = k+1; j < addrTemp.length; j++) {


                            if (addrTemp[k] == addrTemp[j]) {
                                addrTemp[j] = 0;
                                cnt++;
                                totalCnt++;
                            }

                            //not only one element and last one not be cancle
                            if ((addrTemp[addrTemp.length-1] !=addrTemp[0]) && (addrTemp[addrTemp.length-1] != 0)) {
                                totalCnt++;
                            }
                        }

                    winnerCnt.push(cnt);    //recotd winner counts @ one address
                    cnt = 1;
            }
        }

        winerShow = false;
        WinnerNum (randomWinnerNum, ResulAddr, winnerCnt);
        return (randomWinnerNum, ResulAddr, winnerCnt);
    }



    //withdraw eth to every winer only by owner
    function WinnerWithdraw () public onlyOwner returns (uint[]) {
        require (randNonce !=0 , "No body join");
        ethTrans = 0;
        delete EthTtansfer;
        for (uint n = 0; n < ResulAddr.length; n++) {
            ethTrans = winnerCnt[n] * (_Unit * participant.length) / totalCnt ;
            EthTtansfer.push(ethTrans);
            ResulAddr[n].transfer(ethTrans);
        }

        //initial para for next lottery
        winerShow = true;
        delete participant;
        delete ResulAddr;
        delete winnerCnt;
        delete pickedNum;
        randNonce = 0;    //restart lottery

        return EthTtansfer;
    }

    /* get
        1. participant list and Number who picked
        2. winer address and winer counts
        3. winer Number
    */
    function getInfo () public view returns (address[], uint[], address[], uint[]) {
        return (participant, pickedNum, ResulAddr, winnerCnt);
    }

    //get balance of contractO
    function getBalanceContract () public view returns (uint256) {
        return this.balance;
    }

}
