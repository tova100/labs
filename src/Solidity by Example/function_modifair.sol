// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract FunctionModifir{
    uint256 public x;
    address public owner;
    bool public lock;
    constructor()public {
        owner=msg.sender
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"Not owner");
        _;
    }
    modifier valiedAddress(address newAddress){
        require(newAddress !=address(0),"not valied");
        _;
    }
    function changeOwner(address newOwner)public onlyOwner()valiedAddress(newOwner){
        owner=newOwner;
    }
    modifier lock(){
        require(!lock,"not");
        lock=true;
        _;
        lock=false;
    }
    function decrement(uint256 i)public lock{
        x-=i;
        if (i > 1) {
            decrement(i - 1);
    }
    }
}