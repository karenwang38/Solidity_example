pragma solidity ^0.4.24;
/*
01_say_hello
- set greeting on creation and allow to change it by the owner (creator of the contract)
- return greeting to everyone who calls sayHello method
- return Hello Daddy to the creator
*/
contract say_hello {
    address owner;
    string message;

    //save address of contract owner
    constructor()
    {
        owner = msg.sender;
        message = "Hello World";
    }

    // 限定只有合約部屬人才能執行特定function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //greeting context depend on who call
    function sayHello() public view returns(string) {
        if(msg.sender == owner) {message = "Hello Daddy";}
        return message;
    }

    //set message by contract owner
    function setMessage(string _newMsg) public onlyOwner
    {
        message = _newMsg;
    }
}
