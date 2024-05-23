// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import "../../src/Amm/my_tokenA.sol";
import "../../src/Amm/my_tokenB.sol";
import"../../src/Amm/amm.sol";
import {Test, console} from "forge-std/Test.sol";

contract AmmTest is Test{
    MyTokenA tokenA;
    MyTokenB tokenB;
    Amm amm;
    address user = vm.addr(1);
    function setUp()public{

        tokenA=new MyTokenA();
        tokenB=new MyTokenB();
        amm = new Amm(tokenA,tokenB);
        tokenA.approve(address(amm), 2000000000);

      
        // tokenA.mint(200, user);
        // tokenB.approve(user, 200);
        // tokenB.mint(200, user);
        
    }
    function test_Add_notEq()public{
        vm.startPrank(user);
        //אני נותנת הרשאה ל ammלהשתמש בכסף שהנפקתי לטוקנים  
        tokenA.approve(address(amm), 50);
        tokenA.mint(50, user);
        tokenB.approve(user, 100);
        tokenB.mint(100, user);
        amm.addLiquidity(tokenA.balanceOf(address(user)),tokenB.balanceOf(address(user)));

    // assertEq(amm.balanceUser[msg.sender]==);

    }
       function test_Add_Eq()public{
        vm.startPrank(user);
        //אני נותנת הרשאה ל ammלהשתמש בכסף שהנפקתי לטוקנים  
        tokenA.approve(address(amm), 200);
        amm.addLiquidity(tokenA.balanceOf(address(user)),tokenB.balanceOf(address(user)));

    // assertEq(amm.balanceUser[msg.sender]==);

    }
//לא סיימתי לעשות טסטים 
} 