pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "../contracts/ERC20Token.sol";
import "truffle/DeployedAddresses.sol";

contract ERC20TokenTest {
    ERC20Token erc20token;
    uint256 decimals = 18;
    uint256 initialSupply = 1000;
    uint weiToEther = 10 ** 18;
    address Addr01 = 0x8306B5eaA9CB9e14C79aaBeD1a386210b24CcC1A;
    address Addr02 = 0xea8CECbE6D8886bC3B13772B6B29d7D4D94eaeB2;
    address Addr03 = 0x5E89dEa8dF01459e9DBd25451f9A64cEC94920CF;

    function beforeEach() public {
        erc20token = new ERC20Token();
    }

    function testSettingAnOwnerDuringCreation() public {
        Assert.equal(erc20token.owner(), this, "An owner is different than a deployer");
    }

    function testSettingAnOwnerOfDeployedContract() public {
        erc20token = ERC20Token(DeployedAddresses.ERC20Token());
        Assert.equal(erc20token.owner(), msg.sender, "An owner is different than a deployer");
    }

    function testInitialParameter() public {
        Assert.equal(erc20token.name(), "KW", "token is KW");
        Assert.equal(erc20token.symbol(), "0_0", "token is KW");
        Assert.equal(erc20token.totalsupply(), initialSupply * 10 ** decimals, "total token supply is 1000 with decimals=18");
    }

    function testBalanceOf() public {
        erc20token = ERC20Token(DeployedAddresses.ERC20Token());
        uint256 result = erc20token.balanceOf(Addr01);
        Assert.equal(result, initialSupply * 10 ** decimals, "token balance of Addr01 equal total supply");
    }

    function testTransfer() {
        //erc20token = ERC20Token(DeployedAddresses.ERC20Token());
        //erc20token.transfer(Addr02, 10 * 10 ** decimals);
        bool result = erc20token.transfer(Addr02, 10*10**18);
        Assert.equal(result, true, "transfer fail");
        Assert.equal(erc20token.balanceOf(Addr02), 10 * 10 ** decimals, "token balance of Addr01 equal total supply");
        Assert.equal(erc20token.balanceOf(this), (initialSupply - 10) * 10 ** decimals, "token balance of Addr01 equal total supply");
    }

    function testApproveAndAllowance() {
        //bool result = erc20token.transfer(Addr02, 10*10**18);
        Assert.equal(erc20token.approve(Addr02, 20*10**18), true, "apporve fail");
        Assert.equal(erc20token.allowance(this, Addr02), 20*10**decimals, "allowance fail");

        //Assert.equal(erc20token.transferFrom(this, Addr03, 10*10**decimals), true, "transferFrom fail");
        //Assert.equal(erc20token.balanceOf(this), (initialSupply-10) * 10 ** decimals, "balance of msg.sender after transferFrom is wrong");
        //Assert.equal(erc20token.balanceOf(Addr03), 10 * 10 ** decimals, "balance of Addr03 after transferFrom is wrong");

    }

    //cant change msg.sender, so use this account by itself
    function testtransferFrom () {
      //erc20token = ERC20Token(DeployedAddresses.ERC20Token());
      Assert.equal(erc20token.approve(this, 20*10**18), true, "apporve fail");
      Assert.equal(erc20token.allowance(this, this), 20*10**decimals, "allowance fail");
      Assert.equal(erc20token.transferFrom(this, Addr03, 10*10**decimals), true, "transferFrom fail");
      Assert.equal(erc20token.balanceOf(Addr03), 10 * 10 ** decimals, "token balance of Addr03 is wrong ater transferFrom");
    }

    function testbalanceAny() {
      //erc20token = ERC20Token(DeployedAddresses.ERC20Token());
      Assert.equal(erc20token.balanceAny(Addr03), Addr03.balance, "eth balance fail");
    }

    function testaddr_deployer() {
      Assert.equal(erc20token.addr_deployer(), this, "deployer address wrong");
    }

    function testaddr_caller() {
      Assert.equal(erc20token.addr_caller(), this, "caller address wrong");
    }
/*
    // transfer eth fail , solidity can't test eth transfer
    function testcaller_transfer() {
      erc20token = ERC20Token(DeployedAddresses.ERC20Token());
      uint256 balanceSender = erc20token.balanceAny(msg.sender);
      bool result = balanceSender > 0;
      Assert.equal(result, true, "msg.sender doenst have balance");

      //Assert.equal(erc20token.caller_transfer.value(1 * weiToEther)(Addr02), true, "caller transfer eth fail");
    }
*/

    function testgetContractBalance() {
      Assert.equal(erc20token.getContractBalance(), 0, "contract initial balance is 0");
    }

/*
    // transfer eth fail , solidity can't test eth transfer
    function testtransferto_contract() {
      erc20token = ERC20Token(DeployedAddresses.ERC20Token());
      Assert.equal(erc20token.transferto_contract.value(1 * weiToEther)(), true, "transfer eth to contract fail");
    }
*/













}
