// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Function{
    function returnMany()public pure returns(uint256,bool,uint256){
    return(1,true,2);
    }
    function named()public  pure returns(uint256 v,bool l,uint256 i){
       return(1,true,2);
    }
    function assigned()public  pure returns(uint256 v,bool l,uint256 i){
        v=2;
        l=true;
        i=1;
    }
    function destructuringAssignments()public  pure returns(uint256 x,bool l,uint256 c,uint256 b){
        (uint256 x,bool l,uint256 c)=returnMany();
        (uint256 x,uint256 l)= (2,3,3);
        return (x,l,c,b);
    }
    function arrInput()public{}
    uint256 [] arr;
    function arrOutput()public view  returns(uint256[]memory arr){
        return arr;
    }
    contract XYZ{
        function funcWithManyPrameters(
            uint256 x,uint256 y,uint256 z,bool b,string memory c
        )public view returns(uint256){}
        function callFunc()external pure returns(uint256){
            return funcWithManyPrameters(3,3,3,true,"c");
        }
        function keyValue ()external pure  returns(uint256){
            return funcWithManyPrameters({x:2,y:3,z:9,b:true,c:"a"})
        }
    }
}
