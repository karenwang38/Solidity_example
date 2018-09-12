// Test : When goal is reached
var basicToken = artifacts.require("./basicToken.sol");

contract("basicToken", function(accounts) {
  var basicTokenPara;


  it("1. check initial value : token name, number, creator.", function() {
    return basicToken.deployed().then(function(instance) {
      basicTokenPara = instance;
      return basicTokenPara.name();
    }).then(function(Name) {
      assert.equal(Name, "KW", "token name is KW.");

      return basicTokenPara.number();
    }).then(function(Num) {
      assert.equal(Num, 1000, "token number is 1000");

      return basicTokenPara.owner();
    }).then(function(Owner) {
      assert.equal(Owner, accounts[0], "token creator is accounts[0].");

      return basicTokenPara.tokenowner(0);
    }).then(function(TokenList) {
      assert.equal(TokenList.length, 2, "two infor, address and balance.");
      assert.equal(TokenList[0], accounts[0], "first token accounts[0].");
      assert.equal(TokenList[1], 1000, "first token accounts[0] balance is 1000.");
    });
  });

  it("2. check transfer procedure.", function() {
    return basicToken.deployed().then(function(instance) {
      basicTokenPara = instance;

      //transfer event :from accounts[0] to accounts[1]
      return basicTokenPara.transfer(accounts[1], 100);
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].event, "transferEvent", "event type is correct.");
      assert.equal(receipt.logs[0].args._from, accounts[0], "event from accounts[0].");
      assert.equal(receipt.logs[0].args._to, accounts[1], "event accounts[0] transfer to accounts[1].");
      assert.equal(receipt.logs[0].args._number, 100, "event transfer 100 tokens.");

      //transfer event :from accounts[0] to accounts[2]
      return basicTokenPara.transfer(accounts[2], 100);
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].event, "transferEvent", "accounts[2] event type is correct.");

      //transfer event :from accounts[2] to accounts[3]
      return basicTokenPara.transfer(accounts[3], 50, {from: accounts[2]});
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].event, "transferEvent", "accounts[3] event type is correct.");

      //transfer event :from accounts[3] to accounts[4] with not enough balance
      return basicTokenPara.transfer(accounts[4], 60, {from: accounts[3]});
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because balance is not enough.");

      //transfer event :from accounts[3] to accounts[4] with enough balance
      return basicTokenPara.transfer(accounts[4], 10, {from: accounts[3]});
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].event, "transferEvent", "transfer from accounts[3] to accounts[4] event type is correct.");
    });
  });


  it("3. check tokenowner array (address and balance).", function() {
    return basicToken.deployed().then(function(instance) {
      basicTokenPara = instance;

      //transfer event :from accounts[0] to accounts[1]
      return basicTokenPara.tokenowner(0);
    }).then(function(info) {
      assert.equal(info[0], accounts[0], "list 1 address is accounts[0].");
      assert.equal(info[1], 800, "accounts[0] with 800 tokens.");
      return basicTokenPara.tokenowner(1);
    }).then(function(info) {
      assert.equal(info[0], accounts[1], "list 2 address is accounts[1].");
      assert.equal(info[1], 100, "accounts[1] with 100 tokens.");

      return basicTokenPara.tokenowner(2);
    }).then(function(info) {
      assert.equal(info[0], accounts[2], "list 3 address is accounts[2].");
      assert.equal(info[1], 50, "accounts[2] with 50 tokens.");

      return basicTokenPara.tokenowner(3);
    }).then(function(info) {
      assert.equal(info[0], accounts[3], "list 4 address is accounts[3].");
      assert.equal(info[1], 40, "accounts[3] with 40 tokens.");

      return basicTokenPara.tokenowner(4);
    }).then(function(info) {
      assert.equal(info[0], accounts[4], "list 5 address is accounts[0].");
      assert.equal(info[1], 10, "accounts[4] with 10 tokens.");

      return basicTokenPara.tokenowner(5);
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('invalid') >= 0, "invalid opcode because of there is no record on tokenowner(5).");
    });
  });

});
