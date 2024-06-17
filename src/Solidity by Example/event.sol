// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Event{
    //print to console 
    event log(address indexed addr,string massege);
    event anotherLog();
    function test()public{
       emit log(msg.sender,"hello world");
       emit log(msg.sender, "Hi for every one");
       emit anotherLog();
    }
}