// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract Lending{
   struct user {
    uint256 time ;
    uint balance;
     
   }
    mapping (address=>user)balanceUsers;
    IERC20 token;//token of smart contract 
    IERC20 DAI;
    uint256 percentDai =2;
    uint256 percentETH =2;
    uint256 totalDAI;
    uint256 totalETH;
    receive() external payable {}
      modifier updatePercentDai(uint256 amount) {
        uint256 t = totalDAI;
        totalDAI += amount;
        if((totalDAI / amount) > (t / amount)) {
            percentDai++;
        }
        _;
    }

    modifier updatePercentETH(uint256 amount) {
        uint256 t = totalETH;
        totalETH += amount;
        if((totalETH / amount) > (t / amount)) {
            percentETH++;
        }
        _;
    }
     modifier isCorrect (uint256 amount){
        require(amount>0,"MUST BE BEGGER ZERO");
        _;
    }
    constructor(address _DAI,address _token)public{
        DAI= IERC20(_DAI);
        token= IERC20(_token);
    }

  
    function depositDAI(uint256 Dai)public isCorrect(Dai) updatePercentDai(Dai){
        //get Dai and transfer tokens 
        //transfer to smart contract

        DAI.approve(address(this),Dai);
        DAI.transferFrom(msg.sender,address(this),Dai);
        //transfer to user
        token.mint(msg.sender,Dai);//מנפיקה טוקנים שיהיה לי להחזיר למי שמפקיד דאי 
        token.approve(address(this),Dai);
        token.transfer(msg.sender,Dai);
    }
   
    function depositTokens(uint256 tokens)public isCorrect (tokens){
        //get tokens and transfer Dai 
        token.approve(address(this),tokens);

        token.transferFrom(msg.sender,address(this),tokens);
        //transfer to user
        DAI.mint(msg.sender,tokens);//מפקידה דאי שיהיה לך בבריכה 
        DAI.approve(address(this),tokens);
        uint256 interest=(percentDai/365)*  (block.timestamp-balanceUsers[msg.sender].time);
        DAI.transfer(msg.sender,tokens);
    }
    function depositETH(uint256 amount)payable public isCorrect(amount){
        //get ETH and transfer DAI 
        balanceUsers[msg.sender].time=block.timestamp;
        totalETH+=amount;
        balanceUsers[msg.sender].balance+=amount;
        DAI.approve(address(this),amount);
        DAI.transfer(msg.sender,amount);

    }
    function removeCollateral(uint256 amount)public isCorrect(amount) updatePercentETH(amount){
        //take remove ETH
        require(balanceUsers[msg.sender].balance>=amount,"cant take ETH ");
        uint256 interest=(percentETH/365)*  (block.timestamp-balanceUsers[msg.sender].time);

        payable(msg.sender).transfer(amount+interest);
        balanceUsers[msg.sender].balance-=amount+interest;
        totalETH-=amount;

    }
    function addCollateral(uint256 amount)payable public isCorrect (amount)updatePercentETH(amount){
        //get ETH
        balanceUsers[msg.sender].time=block.timestamp;
        totalETH+=amount;
        balanceUsers[msg.sender].balance+=amount;

    }
    function reduceDebt(uint256 amount)public isCorrect(amount)updatePercentETH(amount){
    //get DAI transfer ETH
        require(balanceUsers[msg.sender].balance>=amount,"cant take ETH ");
        uint256 interest=(percentETH/365)*  (block.timestamp-balanceUsers[msg.sender].time);
        DAI.transferFrom(msg.sender,address(this),amount);
        payable(msg.sender).transfer(amount);
        balanceUsers[msg.sender].balance-=amount;
        totalETH-=amount;

    } 
}