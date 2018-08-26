pragma solidity ^0.4.24;      // 指定Compiler版本
/*
02_balance_address_checker
- return address of the contract
- return address of the contract’s owner
- return address of the sender
- return balance of the contract
- return balance of the contract’s owner (ONLY if you are the owner)
- return balance of the sender

Others
- caller transfer Eth to any account
- transfer eth to contract address
- only deployer can transfer eth to the contract
- the contract transfer Eth any account
- the contract transfer Eth only deployer
*/
contract Account_procedure {
    address contractOwner;  //contract owner address
    address caller_addr ; // caller address
    uint private weiToEther = 10 ** 18; // 把單位從wei轉為Ether

    //assign contractOwner address
    function Account_procedure() public {
        contractOwner = msg.sender;
    }

    // 限定只有合約部屬人才能執行特定function
    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }

    //show any balance of account
    function balanceAny(address anyaddr) public view returns (uint256 balance) {
        return anyaddr.balance;
    }

    //show address who deploied contract
    function addr_deployer() public view returns (address) {
        return contractOwner;
    }

    //show address who call the cantract
    function addr_caller() public view returns (address) {
        return msg.sender;
    }

    //caller transfer Eth to any account
    function caller_transfer(address addr) public payable returns (bool success) {
        require(msg.sender.balance >= msg.value);
        addr.transfer(msg.value);
        return true;
    }


    //only deployer can trasfer Eth to other account
    function deployer_transfer(address addr) public onlyOwner payable returns (bool success) {
        require(msg.sender.balance >= msg.value);
        addr.transfer(msg.value);
        return true;
    }

    //show balance of contract
    function getContractBalance() public view returns (uint256 balance){
        return this.balance;
    }

    //show address of contract
    function getContractAddrees() public view returns (address){
        return this;
    }

    //transfer eth to contract address
    function transferto_contract() public payable returns (bool success){
        caller_addr = msg.sender;
        require(caller_addr.balance >= msg.value);
        return true;
    }

    //only deployer can transfer eth to the contract
    function deployer_transTocontract() public onlyOwner payable returns (bool success){
        caller_addr = msg.sender;
        require(caller_addr.balance >= msg.value);
        return true;
    }

    //the contract transfer Eth any account
    function withdraw(uint amount) public {
        require(this.balance >= amount * weiToEther);
        caller_addr = msg.sender;
        caller_addr.transfer(amount * weiToEther);
    }

    //the contract transfer Eth only deployer
    function deployer_withdraw(uint amount) public onlyOwner {
        require(this.balance >= amount * weiToEther);
        caller_addr = msg.sender;
        caller_addr.transfer(amount * weiToEther);
    }






}
