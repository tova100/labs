
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Maaping{
    mapping (address=>uint256)public myMap;
    function get(address addr)public view returns (uint256){
        return myMap[addr];
    }
    function set(address addr,uint i )public {
        myMap[addr]=i;
    }
    function remove(address addr)public{
        delete myMap[addr];
    }
}
contract NesredMapping{
    mapping (address=>mapping(uint256=>bool))public myMap;
    function get(address addr,uint256 i)public view returns (bool){
        return myMap[addr][i];
    }
    function set(address addr,uint256 i,bool b)public{
        myMap[addr][i]=b;
    }
    function remove (address addr,uint256 i )public{
        delete myMap[addr][i];;
    }
}