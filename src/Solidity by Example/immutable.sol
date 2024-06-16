// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Immutable {
    //משתנים כמו קבועים אבל אפשר לשנות אותם רק בקונסטרקטור
    address immutable my_address;
    address immutable addr;

    constructor(address u) {
        my_address = msg.sender;
    }
}
