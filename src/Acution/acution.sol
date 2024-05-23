// SPDX-License-Identifier: MIT
import {console} from "forge-std/Test.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
pragma solidity ^0.8.13;
contract Auction {
    
    address seller;
    bool active;
    address []public allSuggest;
    mapping (address => suggestions) suggest;
    ERC721 Nft;
    uint256 public activationTime;//זמן ההפעלה של החוזה
    uint256 public  SEVEN_DAYS = block.timestamp + 7 days;
    uint256 max;
    struct suggestions {
        uint256 amount;
        bool isActive;
    }
    receive() external payable{}
    constructor() {
        seller= payable(msg.sender);// זמן קיום המכירה
        activationTime=block.timestamp;
        active=true;
        max=0;
    }
    function addSuggest(uint256 amount)public{
        console.log('amount',amount);
        require(active==true,'The auction has ended');
        require(block.timestamp< SEVEN_DAYS,'the time over of auction');
        require(max<amount,'You should offer a higher amount');
               //if exsist just update
                if(suggest[msg.sender].isActive){
                    suggest[msg.sender].isActive=false;
                    payable(suggest[msg.sender]).transfer(suggest[msg.sender].amount); 
                // require(msg.sender.balance >=amount , "you do not have enough money");
                // ERC20.transferFrom(msg.sender, address(this) , amount);
                // suggest[msg.sender].amoumt =amount;
                }
                require(msg.sender.balance >=amount , "you do not have enough money");
                
                transferFrom(msg.sender, address(this) , amount);
                allSuggest.push(msg.sender);
                suggest[msg.sender].amount=amount;
                suggest[msg.sender].isActive=true;
    
    }
    function removeSuggest()public{
        require(active==true,'The auction has ended');
        require(block.timestamp < SEVEN_DAYS , "The Auction is over");
        require(suggest[msg.sender].isActive ,'you dont have suggest');
            payable(suggest[msg.sender]).transfer(suggest[msg.sender].amount); 
            suggest[msg.sender].isActive=false;
    
    // function woner()public{
    //     if(block.timestamp+7 days==SEVEN_DAYS)
    //     active=false;
    //     for (uint i = 0; i < allSuggest.length; i++) {
    //         if(suggest[i].isActive==true){
    //             payable(suggest[i].sender).transfer(suggest[i].amount);
    //         }
    //         //   if (i == msg.sender) { 
    //         //     Nft.transferFrom(address(this), suggest[i].sender, max);
    //         // }
    //     }
    // }
}
}
// הכנסת הצעה חדשה 
// עידכון 
// הסרה ולהחזיר את בכסף 
// זוכה ולהחזיר את הכסף 
// nft erc721