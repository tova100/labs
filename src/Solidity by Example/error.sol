// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Error{
    function require(uint256 x)public pure {
        require(x>10,"must be bigger then 10");
    }
    function revert(uint256 x)public pure{
        if(x>10)
        revert("must be bigger then 10");
    }
    uint256 public num;
    function testAssert()public view{
        assert(num==0);
    }
    error InsufficientBalance(uint256 balance, uint256 withdraw);

    //costom error
    function costom_error(uint256 withdrawAmount)public view{
        uint bal=address(this).balance;
        if(bal<withdrawAmount)
        revert InsufficientBalance({
            balance:bal
            withdraw:withdrawAmount
        });
    }
}