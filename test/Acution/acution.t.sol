// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../../src/Acution/acution.sol";

contract Testauction is Test {
    Auction n;
    address user = vm.addr(1);

    function setUp() public {
        n = new Auction();
    }

    function testAddSuggest() public {
        uint256 suggest = 50;
        n.addSuggest(suggest);
    }
}
