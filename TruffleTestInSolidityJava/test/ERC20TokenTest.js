const ERC20Token = artifacts.require("ERC20Token");

contract("ERC20Token", accounts => {
  const [firstAccount, secondAccount, thirdAccount] = accounts;
  const decimals = 18;
  const weiToEther = 10 ** 18;

  beforeEach(async () => {
    erc20token = await ERC20Token.new();
  });

  it("sets an owner", async () => {
    assert.equal(await erc20token.owner(), firstAccount, 'owner should be deployer');
  });

  it("check name, symbol, decimals, totalsupply", async() => {
    assert.equal(await erc20token.name(), 'KW', 'name shold be KW');
    assert.equal(await erc20token.symbol(), '0_0', 'name shold be KW');
    assert.equal(await erc20token.totalsupply(), 1000 * 10 ** 18, 'totalsupply is wrong');
    //assert.equal(await erc20token.name(), 'KW', 'name shold be KW');
  });

  it("check token address and balance belong to owner", async() => {
    const initialtotalsupply = await erc20token.totalsupply();
    const ownerdata = await erc20token.tokenowner(0)
    assert.equal(ownerdata[0], firstAccount, 'the first address is not owner');
    assert.equal(ownerdata[1].s, 1, 'the first address is not owner');
    assert.equal(ownerdata[1].e, 21, 'the first address is not owner');
    assert.equal(ownerdata[1].c, 10000000, 'the first address is not owner');
  });

  it("check balanceOf function", async() => {
    const ownerbalance = await erc20token.balanceOf(firstAccount);
    assert.equal(ownerbalance.s, 1, 's = 1, the token balance of woner equal total supply');
    assert.equal(ownerbalance.e, 21, 'e = 21, the token balance of woner equal total supply');
    assert.equal(ownerbalance.c, 10000000, 'c = 10000000, the token balance of woner equal total supply');
  });

  it("check transfer function", async() => {
    await erc20token.transfer(secondAccount, 50 * 10 ** decimals);
    const firstBalance = await erc20token.balanceOf(firstAccount);
    const secondBalance = await erc20token.balanceOf(secondAccount);

    assert.equal(firstBalance.s, 1, 's = 1, the token balance of  first account is 950');
    assert.equal(firstBalance.e, 20, 'e = 20, the token balance of woner first account is 950');
    assert.equal(firstBalance.c, 9500000, 'c = 9500000, the token balance of  first account is 950');

    assert.equal(secondBalance.s, 1, 's = 1, the token balance of  second account is 50');
    assert.equal(secondBalance.e, 19, 'e = 19, the token balance of  second account is 50');
    assert.equal(secondBalance.c, 500000, 'c = 500000, the token balance of  second account is 50');

  });

  it("check transfer event", async() => {
    const transferEvent = await erc20token.transfer(secondAccount, 50 * 10 ** decimals);
    assert.equal(transferEvent.logs[0].event, 'Transfer', 'trigger Transfer');
    assert.equal(transferEvent.logs[0].args._from, firstAccount, 'the content of event transfer from firstAccount');
    assert.equal(transferEvent.logs[0].args._to, secondAccount, 'the content of event transfer to secondAccount');
    assert.equal(transferEvent.logs[0].args._value.s, 1, 's = 1, the content of event transfer with 50 token');
    assert.equal(transferEvent.logs[0].args._value.e, 19, 's = 19, the content of event transfer with 50 token');
    assert.equal(transferEvent.logs[0].args._value.c, 500000, 's = 500000, the content of event transfer with 50 token');
  });

  it("check approval event", async() => {
    const approvalEvent = await erc20token.approve(thirdAccount, 50 * 10 ** decimals);

    assert.equal(approvalEvent.logs[0].event, 'Approval', 'event Approval trigger');
    assert.equal(approvalEvent.logs[0].args._owner, firstAccount, 'the content of event transfer from firstAccount');
    assert.equal(approvalEvent.logs[0].args._spender, thirdAccount, 'the content of event transfer to secondAccount');
    assert.equal(approvalEvent.logs[0].args._value.s, 1, 's = 1, the content of event transfer with 50 token');
    assert.equal(approvalEvent.logs[0].args._value.e, 19, 's = 19, the content of event transfer with 50 token');
    assert.equal(approvalEvent.logs[0].args._value.c, 500000, 's = 500000, the content of event transfer with 50 token');

  });

  it("check allowance function", async() => {
    await erc20token.approve(thirdAccount, 50 * 10 ** decimals);
    const getAllownce = await erc20token.allowance(firstAccount,thirdAccount);
    assert.equal(getAllownce.s, 1, 's = 1, allowance 50 token');
    assert.equal(getAllownce.e, 19, 'e = 19, allowance 50 token');
    assert.equal(getAllownce.c, 500000, 'c = 500000, allowance 50 token');

  });

  it("check transferFrom function", async() => {
    //allowance 50 token from firstAccount to thirdAccount
    await erc20token.approve(thirdAccount, 50 * 10 ** decimals);

    //transfer 30 token to secondAccount from firstAccount by thirdAccount
    await erc20token.transferFrom(firstAccount, secondAccount, 30 * 10 ** decimals, {from: thirdAccount});

    const firstBalance = await erc20token.balanceOf(firstAccount);
    const secondBalance = await erc20token.balanceOf(secondAccount);

    //check firstAccount balance is 1000 - 30 = 970

    assert.equal(firstBalance.s, 1, 's = 1, the token balance of  first account is 950');
    assert.equal(firstBalance.e, 20, 'e = 20, the token balance of woner first account is 950');
    assert.equal(firstBalance.c, 9700000, 'c = 9500000, the token balance of  first account is 950');

    //check secondAccount balance is 30
    assert.equal(secondBalance.s, 1, 's = 1, the token balance of  second account is 50');
    assert.equal(secondBalance.e, 19, 'e = 19, the token balance of  second account is 50');
    assert.equal(secondBalance.c, 300000, 'c = 500000, the token balance of  second account is 50');


    //check allowance from firstAccount to thirdAccount is 50 - 30 = 20
    const getAllownce = await erc20token.allowance(firstAccount,thirdAccount);
    assert.equal(getAllownce.s, 1, 's = 1, allowance 50 token');
    assert.equal(getAllownce.e, 19, 'e = 19, allowance 50 token');
    assert.equal(getAllownce.c, 200000, 'c = 500000, allowance 50 token');

  });

  it("Can't transferFrom function without allowance", async() => {

    try {
      await erc20token.transferFrom(firstAccount, secondAccount, 30 * 10 ** decimals, {from: thirdAccount});
      assert.fail();
    } catch (err) {
      assert.ok(/revert/.test(err.message));
    }

  });

  it("check eth balance function", async() => {
    assert.equal(await erc20token.balanceAny(web3.eth.accounts[5]), 100 *   weiToEther, 'thirdAccount eth.')
  });

  it("check the address who deploied contract", async() => {
    assert.equal(await erc20token.addr_deployer(), firstAccount, 'the deployer should be firstAccount.')
  });

  it("transfer eth to any account.", async() => {
    const txdata = await erc20token.caller_transfer(secondAccount, {value: weiToEther})
    assert.equal(txdata.receipt.status, '0x1', 'transfer eth to any account fail.')
  });

  it("transfer eth to contract address.", async() => {
    const txdata = await erc20token.transferto_contract({value: weiToEther})
    assert.equal(txdata.receipt.status, '0x1', 'transfer eth to any contract address fail.')
  });

  it("only deployer transfer eth to contract address.", async() => {
    const txdata = await erc20token.transferto_contract({value: weiToEther})
    assert.equal(txdata.receipt.status, '0x1', 'transfer eth to any contract address fail.')
  });

  it("cant transfer eth to contract address not deployer.", async() => {

    try {
      await erc20token.deployer_transTocontract({from: secondAccount, value: weiToEther});
      assert.fail();
    } catch (err) {
      assert.ok(/revert/.test(err.message));
    }
  });

  it("get contract balance and tranfer eth to contract address.", async() => {
    assert.equal(await erc20token.getContractBalance(), 0, 'initial contract eth balance is 0.')
    const txdata = await erc20token.transferto_contract({value: weiToEther})
    assert.equal(await erc20token.getContractBalance(), weiToEther, 'contract eth balance is 1 eth.')

  });

  it("cant withdraw from contract when balance not enough.", async() => {
    try {
      await erc20token.withdraw(1);
      assert.fail();
    } catch (err) {
      assert.ok(/revert/.test(err.message));
    }
  });

  it("withdraw from contract when balance is enough.", async() => {
    await erc20token.transferto_contract({value: weiToEther})
    const txdata = await erc20token.withdraw(1)
    assert.equal(txdata.receipt.status, '0x1', 'cant withdraw from contract.')
  });

  it("cant withdraw from contract not deployer.", async() => {
    await erc20token.transferto_contract({value: 2 *weiToEther})
    try {
      await erc20token.deployer_withdraw(1, {from: secondAccount});
      assert.fail();
    } catch (err) {
      assert.ok(/revert/.test(err.message));
    }
  });















});
