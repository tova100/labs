
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Loop{
    function loop()public {
        for (uint i =0;i<10; i++){
            if(i==10){
                continue;
            }
            elseif(i==5){
                break;
            }
        }
        uint j=0
        while(j<5){
            j++;
        }
    }
}