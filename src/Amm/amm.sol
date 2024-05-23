// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./my_tokenA.sol";
import "./my_tokenB.sol";
pragma solidity ^0.8.20;

contract Amm {
    MyTokenA myTokenA;
    MyTokenB myTokenB;
    uint256  k ;
    uint256 wad;
    
    mapping(address => uint256) public balanceUser;

    constructor(MyTokenA a,MyTokenB b) public{
        myTokenA = MyTokenA(a);
        myTokenB = MyTokenB(b); 
        myTokenA.approve(address(this),1000);
        myTokenA.mint(1000,address(this));
        myTokenB.approve(address(this),2000);
        myTokenB.mint(2000,address(this));   
        k = myTokenA.balanceOf(address(this)) * myTokenB.balanceOf(address(this));
        wad=10 ** 18;
    }

    //
    function tradeAToB(uint256 amount,IERC20 type_token)public{
        require(type_token.balanceOf(address(this)) >= amount,'DONT HAVE ENOUGH FROM THIS TOKENS');
        if(type_token == myTokenA){
            //token that he whant to trade
            //a i get
            //b i tranfer
           tradeAToB_orBToA (amount, myTokenA, myTokenB);
        }
        else{
            tradeAToB_orBToA (amount, myTokenB, myTokenA);//
        }
    }
    function tradeAToB_orBToA (uint256 amount,IERC20 x ,IERC20 y) public{
            uint p = (k / (x.balanceOf(address(this)) + amount));
            //how many msg get after he trade 
            uint c = y.balanceOf(address(this)) - p;
            //i tranfer to msg the token he whant 
            y.transfer(msg.sender, c);
            //i get the token from msg to the Liquidity
            x.transferFrom(msg.sender ,(address(this)) ,amount);
         
    }
    function price()public returns(uint256){
        uint256 balanceA = myTokenA.balanceOf(address(this));
        uint256 balanceB = myTokenB.balanceOf(address(this));
        return balanceA > balanceB ? (balanceA / balanceB) * wad : (balanceB / balanceA) * wad;
    }
    function calculation(uint256 A, uint256 B, uint256 K) public view returns(uint256){
        uint256 divied = (K/A) * wad;
        uint256 z = ((divied/wad)-B)*wad;
        return z;
    }
    ///dont ight
    function addLiquidity(uint256 amountA,uint256 amountB)public{
        //היחס של כל מטבע בודד הוא בהתאם למה שרוצים a/b או b/a
        uint256 balanceA = myTokenA.balanceOf(address(this));
        uint256 balanceB = myTokenB.balanceOf(address(this));
             
        // uint256 proportionalA = (balanceB/balanceA) * wad;
        // console.log("A",proportionalA);
        // uint256 proportionalB=(balanceA/balanceB) * wad;
        uint256 proportional=amountA > amountB ? (amountA / amountB) * wad : ( amountB/amountA ) * wad;


        //בודקת עם היחס שווה גם ל2 הסכומים שקיבלתי A וB בהתאמה 
        require(proportional == price(),'the proportional not same ');
        myTokenA.transferFrom(msg.sender, address(this), amountA);
        myTokenB.transferFrom(msg.sender, address(this), amountB);
    }
    function removeLiquidity(uint256 amount)public{
        require(balanceUser[msg.sender] > 0,'you cant remove');
        uint256 total = myTokenB.balanceOf(address(this)) + myTokenA.balanceOf(address(this));
        //כמה יחסי  אני יכולה למשוך
        console.log(balanceUser[msg.sender]);
        uint256 proportional = (balanceUser[msg.sender]/total) * wad;
        balanceUser[msg.sender]-=amount;
        myTokenA.transferFrom(address(this), msg.sender, proportional * myTokenA.balanceOf(address(this)));
        myTokenB.transferFrom(address(this), msg.sender, proportional * myTokenB.balanceOf(address(this)));

    }
}