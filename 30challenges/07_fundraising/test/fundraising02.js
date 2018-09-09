// Test : When time is up and user can withdraw their eth
var fundraising = artifacts.require("./fundraising.sol");

function wait(ms){
   var start = new Date().getTime();
   var end = start;
   while(end < start + ms) {
     end = new Date().getTime();
  }
}

function timeout(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }



contract("fundraising", function(accounts) {
  var fundraisingPara;
  var weitoeth = 10 ** 18;


  it("4. fundraising user withdraw event when fundraising is runing", function() {
      return fundraising.deployed().then(function(instance) {
      fundraisingPara = instance;

      return fundraisingPara.Addfund( {from: accounts[0], value: 1 * weitoeth });
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].args._sender, accounts[0], "the fund is from accounts[0]");
      //assert.equal(fund.receipt.status, '0x01', "accounts[0] fundraising success.");

      return fundraisingPara.Addfund( {from: accounts[1], value: 1 * weitoeth });
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].args._sender, accounts[1], "the fund is from accounts[1]");
      //assert.equal(fund.receipt.status, '0x01', "accounts[1] fundraising success.");

      return fundraisingPara.Addfund( {from: accounts[2], value: 1 * weitoeth });
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].args._sender, accounts[2], "the fund is from accounts[2]");
      //assert.equal(fund.receipt.status, '0x01', "accounts[2] fundraising success.");

      //accounts[2] fundraising fail because fund is enough
      return fundraisingPara.UserWithdraw();
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because fundraising is runing.");
    });
  });






  it("6. fundraising user withdraw event when fundraising is time up", function() {
      return fundraising.deployed().then(function(instance) {
      fundraisingPara = instance;

      return fundraisingPara.UserWithdraw({from: accounts[0]});
    }).then(function(user) {
      assert.equal(user.logs[0].event, 'UserWithdrawEvent', "event type is correct.");
      assert.equal(user.logs[0].args._from, accounts[0], "user withdraw with correct account.");
      assert.equal(user.logs[0].args._value.s, 1, "s = 1, withdraw 1 eth.");
      assert.equal(user.logs[0].args._value.e, 18, "e = 18, withdraw 1 eth.");
      assert.equal(user.logs[0].args._value.c, 10000, "c = 10000, withdraw 1 eth.");

      return fundraisingPara.UserWithdraw({from: accounts[0]});
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because user only withdraw once.");

      return fundraisingPara.UserWithdraw({from: accounts[5]});
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because accounts[5] is not user.");

/*
      return fundraisingPara.Addfund( {from: accounts[2], value: 1 * weitoeth });

    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because cant addfund when time is up.");
*/
      return fundraisingPara.GetContractBalance();
    }).then(function(balance) {
      assert.equal(balance.s, 1, 'left contract balance is bignumber s = 1 (2 eth).');
      assert.equal(balance.e, 18, 'left contract balance is bignumber e = 18 (2 eth).');
      assert.equal(balance.c, 30000, 'left contract balance is bignumber c = 20000 (2 eth).');
    });
  });

});
