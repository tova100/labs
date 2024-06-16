//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import "forge-std/Test.sol";
contract TestContract is Test{
    receive()external payable{}
    LettoryGame lettorygame;
  
    function testBaccdorCall()public{
     address public alice=vm.addr(1);
    address public bob=vm.addr(2);
    lettorygame =new LettoryGame();
    console.log("alice will not be a winner ");
    vm.prank(alice);
    lettorygame.pinckWinner(address(bob));
    console.log("Admin winner",lettorygame.winner());
    console.log("complated");
    }
}
contract LotteryGame{
    address public winner;
    address public admin;
    uint public prize=1000;
    modifier safeaCheck{
       if(msg.sender==refree())
        _;
        else{
            getWinner();
        }
    }
function refree()internal view returns (address user){
    assembly{
        user :=soald(2);
    }
}
function pinckWinner(address random)public safeCheck{
    assembly{
        sstore(1,random);
    }
}
function getWinner()public view returns (address){
    console.log("winner",winner);
    return winner;
}
}