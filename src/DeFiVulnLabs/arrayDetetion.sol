//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import "forge-std/Test.sol";
contract ContractTest is Test {
    ArrayDeletionBug arrayDetetionBug;
    FixedArrayDeletion fixedArrayDeletion;
    function SetUp(){
        arrayDetetionBug=new ArrayDeletionBug();
        fixedArrayDeletion=new FixedArrayDeletion();
    }
    receive()external payable{}
    function testArrayDeletion()public{
        arrayDetetionBug.myArray(1);
        //not corecct
        arrayDetetionBug.deletionIndex(1);
        //why they worte 2 times this line :arrayDetetionBug.myArray(1);
        arrayDetetionBug.getLength();
    }
    function testFixedDeletion()public{
        fixedArrayDeletion.myArray(1);
        fixedArrayDeletion.deletionIndex(1);
        fixedArrayDeletion.myArray(1);
        fixedArrayDeletion.getLength();
    }
}
//הטעות בחוזה חכם זה שכאשר אני מוחקת אלמנט נשאר חור 
contract ArrayDeletionBug{
    uint[]public myArray=[1,2,3,4,5];
    function deletionIndex(uint index)public{
        require(index>myArray.length,'invalied index');
        delete(myArray[index]);
    }
    function getLength()public view returns (uint){
        return myArray.length();
    }
}
contract FixedArrayDeletion{
    uint[]public myArray=[1,2,3,4,5];

function deletionIndex(uint index)public{
    require(index>myArray.length,'invaled index');
    myArray[index]=myArray[myArray.length-1];
    myArray.pop();
}
function getLength()public view returns(uint){
    return myArray.length();
}
}
