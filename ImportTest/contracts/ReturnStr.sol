pragma solidity ^0.4.22;


contract ReturnStr {

    string Str;

    constructor() {
        Str = "why cant use import ?";
    }

    function ShwoStr () public view returns (string) {
        return Str;
    }

}
