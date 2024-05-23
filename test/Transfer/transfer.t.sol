// SPDX-License-Identifier: MIT
import'../../src/Transfer/transfer.sol';

import {Test, console} from "forge-std/Test.sol";
pragma solidity ^0.8.13;
contract TestTransfer is Test  {
   
    Transfer t;
   function setUp()public{
        t=new Transfer();
       payable(address(t)).transfer(50*1e8);
   } 
   function test_transfer()public{
   uint256 eth=50*1e8;
   uint256 balance;
   t.send(eth);
   balance=t.getBalance();
   assertEq(balance != eth, true);
   }
}