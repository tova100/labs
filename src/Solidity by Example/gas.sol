// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Gas {
    //gas limit = of your transction
    //block gas limit the gas of allow the block
    uint256 public i = 0;

    function forever() public {
        while (true) {
            i += 1;
        }
    }
}
