// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {console} from "forge-std/Test.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract Auction {
    address seller;
    bool active;
    address[] public allSuggest;
    mapping(address => Suggestion) suggest;
    ERC721 Nft;
    uint256 public activationTime; // זמן ההפעלה של החוזה
    uint256 public SEVEN_DAYS;
    uint256 max;

    struct Suggestion {
        uint256 amount;
        bool isActive;
    }

    receive() external payable {}

    constructor() {
        seller = payable(msg.sender); // זמן קיום המכירה
        activationTime = block.timestamp;
        active = true;
        max = 0;
        SEVEN_DAYS = block.timestamp + 7 days;
    }

    function addSuggest(uint256 amount) public {
        console.log("amount", amount);
        require(active == true, "The auction has ended");
        require(block.timestamp < SEVEN_DAYS, "the time over of auction");
        require(max < amount, "You should offer a higher amount");

        // If the suggestion already exists, refund the previous amount
        if (suggest[msg.sender].isActive) {
            suggest[msg.sender].isActive = false;
            payable(msg.sender).transfer(suggest[msg.sender].amount);
        }

        // Check if the sender has enough balance
        require(msg.sender.balance >= amount, "You do not have enough money");

        // Update the suggestion
        allSuggest.push(msg.sender);
        suggest[msg.sender].amount = amount;
        suggest[msg.sender].isActive = true;
    }

    function removeSuggest() public {
        require(active == true, "The auction has ended");
        require(block.timestamp < SEVEN_DAYS, "The Auction is over");
        require(suggest[msg.sender].isActive, "You don\'t have a suggestion");

        // Refund the suggestion amount
        payable(msg.sender).transfer(suggest[msg.sender].amount);
        suggest[msg.sender].isActive = false;
    }

    // The 'woner' function logic needs to be completed and corrected
    // function woner() public {
    //     if (block.timestamp + 7 days == SEVEN_DAYS) {
    //         active = false;
    //         for (uint i = 0; i < allSuggest.length; i++) {
    //             if (suggest[allSuggest[i]].isActive == true) {
    //                 payable(allSuggest[i]).transfer(suggest[allSuggest[i]].amount);
    //             }
    //         }
    //         // Transfer the NFT to the highest bidder
    //         // Add your logic here to find the highest bidder and transfer the NFT
    //     }
    // }
}
// // הכנסת הצעה חדשה
// // עידכון
// // הסרה ולהחזיר את בכסף
// // זוכה ולהחזיר את הכסף
// // nft erc721
