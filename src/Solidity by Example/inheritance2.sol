// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    string public name = "contract A";

    function getName() public view returns (string memory) {
        return name;
    }
}

contract B is A {
    constructor() public {
        name = "contract C";
    }
}
