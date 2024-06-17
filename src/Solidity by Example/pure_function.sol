// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract ViewAndPure {
    uint256 public x=1;
    function addX(uint y)public view returns(uint256){
        return x+y;
    }
    function add(uint256 i,uint256 j)public pure returns(uint256){
        return i+j;
    }
}