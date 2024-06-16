// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Array{
    uint256 [] public arr;
    uint256[]public arr2=[1,2,3];
    uint256[10]public arr3;
    function get(uint256 i )public view returns(uint256){
        return arr[i];
    }
    function push(uint256 num)public{
        arr.push(num);
    }
    function pop()public{
        arr.pop();
    }
    function getLegth()public view returns(uint256){
        return arr.length;
    }
    function remove(uint256 i )public{
        delete arr[i];
    }
    function getArr()public view returns(uint256[]memory){
        return arr;
    }
    //remove element from arr 2 acsses
    function remove(uint256 index)public {
        for(uint i=index;i<arr.length;i++){
            arr[i]=arr[i+1];
        }
        arr.pop();
    }
    //ather acsses replace the end
    arr[index]=arr[arr.length -1];
}