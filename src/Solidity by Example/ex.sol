// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract HelloWorld{
    string public greet="hello world";
}
contract Counter{
    uint256 public count;
    function getCount()public view returns (uint256){
     return count;   
    }
    function inc ()public {
        return count+=1;
    }
    function dec ()public {
        return count-=1;
    }
}
contract Primitivim{
   bool public boo = true;
   uint8 public u8 =1;
   uint256 public u256=456;
}
contract Variables{
    uint256 public num=123;
    string public text="Hello";
    function doSamething()public {
    uint i=456;
    uint256 timestamp=block.timestamp;
    address sender=msg.sender;
    }
}

