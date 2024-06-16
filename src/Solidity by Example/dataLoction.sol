// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataLocation {
    // storage - variable is a state variable (store on blockchain)
    // memory - variable is in memory and it exists while a function is being called
    // calldata - special data location that contains function arguments
    uint256[] arr;

    struct MyStruct {
        uint256 foo;
    }

    mapping(uint256 => address) map;
    mapping(uint256 => MyStruct) myStruct;

    function f() public {
        _f(arr, map, myStruct[1]);
        MyStruct storage myStruct = myStructs[1];
        MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(uint256[] storage arr, mapping(uint256 => address) map, MyStruct storage myStruct) public internal {
        //
    }
    function g(uint256[] memory _arr) public returns (uint256[] memory) {}

    function h(uint256[] calldata _arr) external {}
}
