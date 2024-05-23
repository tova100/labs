// SPDX-License-Identifier: MIT
import {console} from "forge-std/Test.sol";
pragma solidity ^0.8.13;
contract Transfer {
    address payable public owner;
    address [] public addresses;
    // uint256 public eth = 50*1e8;
    constructor() {
        owner = payable(msg.sender);
        addresses.push(0x11059Fa68a9a49D683665AafDc93483d74544A47);
        addresses.push(0x7F4Bf8251F5003bB60cb482c0a59473E1C4428d4);
        addresses.push(0x7ae3DbAC75D264B6F6976639ebBfC645601D3F15);
    }
    
    receive() external payable {}
    function send(uint eth) payable public onlyOwner {
        console.log(eth);
        uint256 amount = (eth / addresses.length) ;
        console.log(amount);
        for (uint256 i = 0; i < addresses.length; i++) {
           payable(addresses[i]).transfer(amount);
           console.log(payable(addresses[i]).balance);
        }
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
      function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
