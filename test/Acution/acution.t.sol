
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {Test, console} from "forge-std/Test.sol";
import "../../src/Acution/acution.sol";

contract Testauction is Test{
    Auction n ;
    address user=vm.addr(1);
    function setUp()public{
        n=new Auction();
    }
    function testAddSuggest()public{
        uint suggest=50;
        n.addSuggest(suggest);
    }
}