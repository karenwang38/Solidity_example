pragma solidity ^0.4.0;

/* computer contract
call external function add() to calculate 2+3
*/



//interface function of calculate
contract calculate {
    function add (int a, int b) external view returns (int);
}

//main contract
contract computer {
    //contract address of calculate
    address calculate_addr = 0x2f7a50e87f054a42a14487e49dd7216e14316fe1;

    //call contract calculate to calc
    calculate calc = calculate(calculate_addr);
        function add2Num(int num1, int num2) constant public returns (int){
        return calc.add(num1, num2);
    }

}
