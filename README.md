# Solidity_example
simple solidity language example
(some examples is reference from 實戰區塊鏈技術：加密貨幣與密碼學

- call_contract
	- calculate.sol 
	- computer.sol

	Description
	computer contract call calculate contract to multiple two number.

	Step
	1. deploy calculate contract first.
	2. deploy computer contract.
	3. excute cauculate contract to multiple two number.


- Ethtest_ERC20
	- ERC20_interface.sol
	- ERC20_token.sol

	Description
	1. Publish token. (price, number, symbol)
	2. Function(token)
		- buy
		- transfer
		- balance
		- withdraw (eth from contract)
		- delet contract

- 30challenges
	from: https://medium.com/@pbrudny/the-best-way-to-become-an-ethereum-developer-in-2018-part-3-4f98d88c856d

- Account_Procedure
	1. Account_procedure.sol
	
	Description
	//Personal account
	- show any balance of account
	- show address who deploied contract
	- show address who call the cantract


	- transfer Eth from caller to any account
	- only depolyer account can trasfer Eth to other account

	//contract address
	- show balance of contract
	- show address of contract
	- transfer eth to contract address
	- only deployer can transfer eth to the contract 
	- the contract transfer Eth
		- any account
		- only deploied account

- Acution
	1. SimpleAction.sol
	2. evenTest.sol
	
	Description
	- eventest with web3.js

- ImportTest
	1. ReturnStr.sol
	2. ImportStr.sol
	
	Description
	- ImportStr contract import ReturnStr.sol to use function.
	
- Type_test
	1. arraytest.sol
	2. strucTest.sol
	
	Description
	- check the array type : uint[], butes32[], string, butes procedure.
	- check struct , how to assign and call the element.
	
- call_contract
	1. calculate.sol
	2. computer.sol
	
	Description
	- computer contract calls calculate on the chain and use function.
