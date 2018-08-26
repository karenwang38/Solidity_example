/*Even example ExampleContract
        //excute contract
        var exampleContract = eth.contract([	{		"constant":true,		"inputs":[			{				"name":"_value",				"type":"int256"			}		],		"name":"foo",		"outputs":[			{				"name":"",				"type":"int256"			}		],		"payable":false,		"stateMutability":"view",		"type":"function"	},	{		"anonymous":false,		"inputs":[			{				"indexed":true,				"name":"_from",				"type":"address"			},			{				"indexed":false,				"name":"_value",				"type":"int256"			}		],		"name":"ReturnValue",		"type":"event"	}]).at("0xBbc52E8417021d6a642f744CbE5FC904E31D2242")

        //event config
        var exampleEvent = exampleContract.ReturnValue({_from: web3.eth.coinbase});
        exampleEvent.watch(function(err, result) {
          if (err) {
            console.log(err)
            return;
          }
          console.log(result.args._value)
          // check that result.args._from is web3.eth.coinbase then
          // display result.args._value in the UI and call
          // exampleEvent.stopWatching()
        })
        exampleContract.foo.sendTransaction(2, {from: web3.eth.coinbase})
*/

//Even example :CryptoExchange
var cryptoExContract = eth.contract([	{		"constant":false,		"inputs":[			{				"name":"_amount",				"type":"uint256"			},			{				"name":"_market",				"type":"uint256"			}		],		"name":"deposit",		"outputs":[			{				"name":"",				"type":"int256"			}		],		"payable":false,		"stateMutability":"nonpayable",		"type":"function"	},	{		"anonymous":false,		"inputs":[			{				"indexed":true,				"name":"_market",				"type":"uint256"			},			{				"indexed":true,				"name":"_sender",				"type":"address"			},			{				"indexed":false,				"name":"_amount",				"type":"uint256"			},			{				"indexed":false,				"name":"_time",				"type":"uint256"			}		],		"name":"Deposit",		"type":"event"	}]).at("0xF1C0799df5F03156102FAfA90289C0EDa2370A83")

//event config
var depositEvent = cryptoExContract.Deposit({_sender: userAddress});
depositEvent.watch(function(err, result) {
  if (err) {
    console.log(err)
    return;
  }
  else{
      // append details of result.args to UI
      //将这笔交易写入客户端资料库中，方便以后查询历史交易数据。
  }
})
//通过增加fromBlock参数指定关注的区块范围，来查询所有的交易数据。（获取链上存储的历史交易数据，我们用扒链的办法来获取，因为eth目前没有提供获取历史数据的API。）
var depositEventAll = cryptoExContract.Deposit({_sender: userAddress}, {fromBlock: 0, toBlock: 'latest'});
depositEventAll.watch(function(err, result) {
  if (err) {
    console.log(err)
    return;
  }
  else{
  // append details of result.args to UI
  //如果不想再被通知可以调用：
  //depositEventAll.stopWatching();
  }
})
