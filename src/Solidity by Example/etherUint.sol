// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EtherUint {
    uint256 public onewei = 1 wei;
    bool public isOneWei = (onewei == 1);
    uint256 public onegwei = 1 gwei;
    bool public isOneGwei = (onegwei == 1e9);
    uint256 public oneether = 1 ether;
    bool public isOneEther = (oneether == 1e18);
}
