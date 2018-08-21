pragma solidity ^0.4.24;


contract strucTest {

    struct Campaign {
        address beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
    }
    //uint campaignID;

    mapping (uint => Campaign) campaigns;  // 建立一個key為uint類型，value對應到Campaign struct之鍵值結構campaigns。

    function strucTest () public {
        address first_addr = 0xC03b2d891464a58e0D13F1c0144F571c139C9627;
        address second_addr = 0x77ee56ab1d8e3a12556e37e7b9283e23501d50eb;
        campaigns[0] = Campaign(first_addr, 100, 0, 0); // 使用Campaign(...參數)，新增struct
        campaigns[1] = Campaign(second_addr, 250, 23, 7); // 使用Campaign(...參數)，新增struct

        //uint amount = c.amount; // 存取struct中的值
    }

    //get data from value-key sturct
    function getData (uint value) public view returns (address, uint, uint, uint) {
        Campaign c = campaigns[value];  // 把campaigns[value] 讀取出的Campaign struct給變數c
        return (c.beneficiary, c.fundingGoal, c.numFunders, c.amount);
    }

    function addData (uint _ID, address _addr, uint _idx0, uint _idx1, uint _idx2) public {
        Campaign input = campaigns[_ID];
        input.beneficiary = _addr;
        input.fundingGoal = _idx0;
        input.numFunders = _idx1;
        input.amount = _idx2;
    }

}
