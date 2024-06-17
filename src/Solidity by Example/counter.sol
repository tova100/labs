// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;

    function getCount() public view returns (uint256) {
        return count;
    }

    function inc() public {
        return count += 1;
    }

    function dec() public {
        return count -= 1;
    }
}
