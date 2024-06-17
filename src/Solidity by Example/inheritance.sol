// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

contract D is B, C {
    function foo() public pure override(B, C) {
        return super.foo();
    }
}
