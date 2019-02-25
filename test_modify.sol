pragma solidity >=0.4.22 <0.6.0;
/*
ＥＴＨ版本：
1. 撰寫兩個合約, 主合約和機率合約
2. 主合約可以押注猜骰子點數
3. 機率合約只能被主合約呼叫並產生亂數
4. 紀錄所有遊戲結果紀錄

實作：
1. 主合約（BetContract）紀錄data，機率合約(DiceContract) update不影響過去的data紀錄。
2. 機率合約（和存入主合約BetContract）可以被updatae。
3. 只有機率合約DiceContract 和存入主合約BetContract 的eth（funciton saveEthToContract）可以改寫餘額（ethBalanceOf）。
4. 主合約BetContract有餘額ethBalanceOf才能進行遊戲（bet）。
5. 猜對增加倍數* 押注金額（weight*value)的餘額(ethBalanceOf)。猜錯減少押注金額（value）餘額(ethBalanceOf)。
6. 可以從主合約（DiceContract）提款（withdraw）餘額（ethBalanceOf）內的額度。
*/


//data contract(main contract)
contract BetContract {

    //uint public weiToEth = 10 ** 18;
    mapping (address => uint) public ethBalanceOf; //how many wei you have in BetContract
    address contractAddress; // BetContract address
    address BetContractOwner; // BetContract Owner
    address diceContractAddress; // diceContractAddress

    // record all game resule
    struct Data {
        address Address;
        uint userGuess;
        uint Ansers;
        uint betWei;
    }
    Data [] public data;

    //initialize BetContract Address & Owner
    constructor () {
        contractAddress = this;
        BetContractOwner = msg.sender;
    }

    // only BetContract can do
    modifier onlyBetContractOwner () {
        require(msg.sender == BetContractOwner, 'only BetContractOwner have right to do.');
        _;
    }

    // only DiceContract address can do
    modifier onlyDiceContractRight () {
        require(msg.sender == diceContractAddress, 'only DiceContract have right to do.');
        _;
    }

    //set diceContractAddress after updatting DiceContract
    function setDiceContractAddress(address _addr) onlyBetContractOwner public {
        diceContractAddress = _addr;
    }

    //save eth balance
    function saveEthBanalce(address _addr, uint _value) public onlyDiceContractRight {
        ethBalanceOf[_addr] += _value;
    }

    //reduce eth balance
    function loseEthBalance(address _addr, uint _value) public onlyDiceContractRight {
        ethBalanceOf[_addr] -= _value;
    }

    //save eth to contract
    function saveEthToContract() payable public {
        require(msg.sender.balance >= msg.value, 'your eth not enough in your account.');
        ethBalanceOf[msg.sender] += msg.value;
    }

    //get BetContract ContractBalance
    function getContractBalanceOf() public returns (uint) {
        return contractAddress.balance;
    }

    //get BetContract address
    function getContraceAddress() public returns (address) {
        return contractAddress;
    }

    //save result data
    function setData(address _addr, uint _userguess, uint _answer, uint _betwei) public onlyDiceContractRight{
        data.push(Data(_addr, _userguess, _answer, _betwei));
    }

    //withdraw from contract
    function withdraw(uint _value) public {
        require(ethBalanceOf[msg.sender] >= _value, 'your balance is not enough.');
        require(contractAddress.balance >= _value, 'contract balance is not enough.');
        ethBalanceOf[msg.sender] -= _value;
        msg.sender.transfer(_value);
    }
}

//can update
//control contract
contract DiceContract {

    BetContract betContract;

    uint answer;
    uint randNonce;
    uint number = 6;
    //uint public weiToEth = 10 ** 18;
    uint i;
    uint weight = 2;
    address diceContractAddress;

    constructor (address _betContractAddr) public {
        betContract = BetContract(_betContractAddr);
        diceContractAddress = msg.sender;
    }

    //Generate Answer 1 ~ 6;
    //win : get weight x _value from contract
    //lose : lose _value from contract
    function bet(uint _value, uint _num) public returns (bool){

        //check eth balance
        require(_value  <= betContract.ethBalanceOf(msg.sender), 'your eth not enough, save eth to contract.');

        // random gen 1~6
        answer =uint (keccak256(now, msg.sender, randNonce)) % number + 1;

        // save result
        betContract.setData(msg.sender, _num, answer, _value);

        //gen randNonce for next round
        randNonce = randNonce + now;

        //
        if (answer == _num) {
            betContract.saveEthBanalce(msg.sender, _value * weight);
            return true;

        } else {
            betContract.loseEthBalance(msg.sender, _value);
            return false;
        }
    }
}
