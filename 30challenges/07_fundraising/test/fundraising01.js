// Test : When goal is reached
var fundraising = artifacts.require("./fundraising.sol");

contract("fundraising", function(accounts) {
  var fundraisingPara;
  var weitoeth = 10 ** 18;

  it("1. initializes with fundraising goal and time", function() {
    return fundraising.deployed().then(function(instance) {
      fundraisingPara = instance;
      return fundraisingPara.Goal();
    }).then(function(goal) {
      assert.equal(goal, 10 * weitoeth);

      return fundraisingPara.Endtime();
    }).then(function(endtime) {
      assert.equal(endtime, 10);
    });
  });

  it("2. fundraising event and struc data checking", function() {
    return fundraising.deployed().then(function(instance) {
      fundraisingPara = instance;

      //check the AddFundEvent (uset address and amount of fund)
      return fundraisingPara.Addfund( {from: accounts[0], value: 5 * weitoeth });
    }).then(function(receipt) {
      assert.equal(receipt.logs[0].event, "AddFundEvent", "the even type is correct");
      assert.equal(receipt.logs[0].args._sender, accounts[0], "the fund is from accounts[0]");

      assert.equal(receipt.logs[0].args._value.s, 1, "the fund is 5 eth");
      assert.equal(receipt.logs[0].args._value.e, 18, "the fund is 5 eth");
      assert.equal(receipt.logs[0].args._value.c, 50000, "the fund is 5 eth");

      //check the userdata: Nth, address and fund
      return fundraisingPara.userdata(accounts[0]);
    }).then(function(data) {
      assert.equal(data[0], 1, 'the user number is 1');
      assert.equal(data[1].s, 1, 's = 1, the fund is 5 eth');
      assert.equal(data[1].e, 18, 'e = 18, the fund is 5 eth');
      assert.equal(data[1].c, 50000, 'c = 50000, the fund is 5 eth');
      assert.equal(data[2], accounts[0], 'the user accounts is accounts[0]');

      //accounts[1] fundraising success
      return fundraisingPara.Addfund( {from: accounts[1], value: 4 * weitoeth });
    }).then(function(fund) {
      assert.equal(fund.receipt.status, '0x01', "accounts[1] fundraising success.");

      //accounts[2] fundraising fail because fund is enough
      return fundraisingPara.Addfund( {from: accounts[2], value: 3 * weitoeth });
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert because fund is reached goal");

    });
  });

  it("3. check owner withdraw procedure", function() {
    return fundraising.deployed().then(function(instance) {
      fundraisingPara = instance;
      return fundraisingPara.OwnerWithdraw();
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "goal not to reach.");

      return fundraisingPara.OwnerWithdraw({from: accounts[1]});
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "only owner can withdraw.");

      return fundraisingPara.Addfund( {from: accounts[2], value: 1 * weitoeth });
    }).then(function(fund) {
      assert.equal(fund.receipt.status, '0x01', "accounts[2] fundraising success, goal is reached.");

      return fundraisingPara.OwnerWithdraw();
    }).then(function(owner) {
      assert.equal(owner.logs[0].event, 'OwnerWithdrawEvent', "event is correct.");
      assert.equal(owner.logs[0].args._value.s, 1, "withdraw = goal = 10 eth.");
      assert.equal(owner.logs[0].args._value.e, 19, "withdraw = goal = 10 eth.");
      assert.equal(owner.logs[0].args._value.c, 100000, "withdraw = goal = 10 eth.");

      return fundraisingPara.OwnerWithdraw();
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "only withdraw once.");

      return fundraisingPara.Addfund({value: 10});
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "fundraising is end.");

    });
  });







/*
  it("initializes the Unit Eth is 0.1", function() {
    return Lottery.deployed().then(function(instance) {
      LotteryPara = instance;
      return LotteryPara._Unit();
    }).then(function(Unit) {
      assert.equal(Unit.s, 1);
      assert.equal(Unit.e, 17);
      assert.equal(Unit.c, 1000);
    });
  });

  it("Buy a lottery, check participant address ahd contract balance", function() {
      return Lottery.deployed().then(function(instance) {
        LotteryPara = instance;
        //candidateId = 1;
        return LotteryPara.BuyLottery({ from: accounts[0], value: 100000000000000000 });
      }).then(function(receipt) {
        //?????
        //assert.equal(receipt.status, '0x01', "buy a lottery success");

        //assert.equal(receipt.logs[0].event, "votedEvent", "the event type is correct");
        //assert.equal(receipt.logs[0].args._candidateId.toNumber(), candidateId, "the candidate id is correct");
        return LotteryPara.participant(0);
      }).then(function(participantAddr) {
        assert(participantAddr, accounts[0], "the first voter whos address is accounts[0]");
        return LotteryPara.getBalanceContract();
      }).then(function(ContractBalance) {
        assert.equal(ContractBalance.s, 1, "increments the the contractbalance 10 ** 17");
        assert.equal(ContractBalance.e, 17, "increments the the contractbalance 10 ** 17");
        assert.equal(ContractBalance.c, 1000, "increments the the contractbalance 10 ** 17");
        return LotteryPara.Winner();
      }).then(assert.fail).catch(function(error) {
        assert(error.message.indexOf('revert') >= 0, "error message must contain revert because participants are not enough");
      });
    });

    it("check the status when participants are full", function() {
        return Lottery.deployed().then(function(instance) {
          LotteryPara = instance;
          //candidateId = 1;
          return LotteryPara.BuyLottery({ from: accounts[1], value: 100000000000000000 });
        }).then(function(receipt) {
          return LotteryPara.BuyLottery({ from: accounts[2], value: 100000000000000000 });
        }).then(function(receipt) {
          return LotteryPara.BuyLottery({ from: accounts[3], value: 100000000000000000 });
        }).then(assert.fail).catch(function(error) {
          assert(error.message.indexOf('revert') >= 0, "error message must contain revert because participants are full");
          return LotteryPara.participant(0);
        }).then(function(participantAddr) {
          assert(participantAddr, accounts[1], "the second voter whos address is accounts[1]");
          assert(participantAddr, accounts[2], "the third voter whos address is accounts[2]");
          return LotteryPara.getBalanceContract();
        }).then(function(ContractBalance) {
          assert.equal(ContractBalance.s, 1, "increments the the contractbalance 30 ** 17");
          assert.equal(ContractBalance.e, 17, "increments the the contractbalance 30 ** 17");
          assert.equal(ContractBalance.c, 3000, "increments the the contractbalance 30 ** 17");
        });
      });


      it("Get the winner", function() {
          return Lottery.deployed().then(function(instance) {
            LotteryPara = instance;
            //candidateId = 1;
            return LotteryPara.Winner();
          }).then(function(receipt) {

            assert.equal(receipt.logs.length, 1, "an event was triggered");
            assert.equal(receipt.logs[0].event, "ReturnWinner", "the event type is correct");
            //assert.equal(receipt.logs[0].args, candidateId, "the candidate id is correct");
          });
        });

*/






});
