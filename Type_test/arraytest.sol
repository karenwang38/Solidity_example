pragma solidity ^0.4.24;
//array display test

contract arraytest {

    uint[] public intArray;
    bytes32[] public stringArray; //bytes series will be codeing
    string public str;            //without length
    bytes public byt;             //with length
    mapping(bytes10 => string) public map;  //key-value mapping

    // initial array
    function arraytest() public{
        intArray.push(2009);
        str = "abc";
        byt = "mshk";
        map["mshk"] = "mshk.top";
        map["idoall"] = "idoall.org";
    }

    //get the length of type "bytes"
    function bytLength() public view returns(uint){
        return byt.length;
    }

    //get bytes "mshe" (will get 0x6d73686b)
    function getbyt() public view returns(bytes){
        return byt;
    }

    //get sting "abc"
    function getsrt() public view returns(string){
        return str;
    }

    //input key to get string (ex: key = 0x6d73686b(mshk), getmshk.top)
    function getMapByKey(bytes10 _key) public view returns(string){
        return map[_key];
    }

    //only read array : array will get parameter to push one by one
    function stringArray() public view returns (bytes32[]){
        stringArray.push("apple");
        stringArray.push("banana");
        stringArray.push("cat");
        return stringArray;
    }

    //get sting by index(get all the coded number, cant _index)
    function getStringArray() public view returns (bytes32[]){
        return stringArray;
    }


    // add a value to array (number)
    function add(uint val) public{
        intArray.push(val);
    }

    //get length of array (number)
    function length() public view returns (uint){
        return intArray.length;
    }

    //get context of array(number)
    function context() public view returns (uint[]){
        return intArray;
    }


    //updata value of index array(number)
    function update(uint _index, uint _value) public{
        require(intArray.length >= _index + 1, "error : array lenth is not enough!");
        intArray[_index] = _value;
    }

    //get the value of certain index(number)
    function calueByIndex(uint _index) public view returns (uint){
        require(intArray.length >= _index + 1, "error : array lenth is not enough!");
        return intArray[_index];
    }


}
