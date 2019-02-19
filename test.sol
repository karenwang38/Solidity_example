pragma solidity >=0.4.22 <0.6.0;
//pragma experimental ABIEncoderV2;


contract GenAnswer {

   uint public answer;
    uint public randNonce;
    uint number = 6;



    //Generate Answer 1 ~ 6;
    function genAnswer() public view returns (uint){
        answer =uint (keccak256(now, msg.sender, randNonce)) % number + 1;
        randNonce = randNonce + now;
        return answer;
    }

}

contract Main is GenAnswer{


    struct Data {
        address Address;
        uint userGuess;
        uint Ansers;
    }


    uint i = 0;
    uint public _answer;

    mapping(uint => Data) public data;


    function Guess(uint guess) public returns (bool){
        require(guess > 0 && guess < 7, "重選數字1~6");
        _answer = genAnswer();


        data[i] = Data(msg.sender, guess, _answer);
        i++;

        if (guess == _answer) {
            return true;
        } else {
            return false;
        }


    }


}
