// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Variables{
    uint256 public num=123;
    string public text="Hello";
    function doSamething()public {
    uint i=456;
    uint256 timestamp=block.timestamp;
    address sender=msg.sender;
    }
}
