pragma solidity ^0.4.24;
/*
- return random number 0–99
- the “financial importance” of this calculation is less than miner would get for mining single block
- https://ethereum.stackexchange.com/questions/419/when-can-blockhash-be-safely-used-for-a-random-number-when-would-it-be-unsafe?noredirect=1&lq=1
*/

contract RandomNum {
    uint randNonce = 0;
    uint random;

    //use keccak256 to gen random function
    function Random () public returns (uint, uint, uint) {
        random = uint(keccak256(now, msg.sender, randNonce)) % 100;
        randNonce ++;

    }

    //get parameter of random()
    function getData () public view returns (uint, uint, uint) {
        return (random, randNonce, now);
    }

}
