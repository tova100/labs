// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "forge-std/Test.sol";
contract ContractTest is Test{
    ERC20 ERC20Contract;
    address alice = vm.addr(1);
    address eve = vm.addr(2);
    function testApproveScam()public{
        ERC20Contract=new ERC20();
        ERC20Contract.mint(1000);
        ERC20Contract.transfer(address(alice),1000);
        vm.prank(alice);
        //אני חושבת שזו טעות לאשר לקחת את max שזה אומר את כל הכסף 
        ERC20Contract.approve(address(eve), type(uint256).max);
        console.log("Before balance of Eve",ERC20Contract.balanceOf(eve));
        console.log("Due to alice transfer permissiion to Eve ,now Eve can move funds from alice");
        console.log("After ,balance of Eve",ERC20Contract.balanceOf(eve));
        console.log("Exploit completed");
    }
    receive()external payable{}
}
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account)external view returns(uint);  
    function transfer (address recipient,uint amount)external returns(bool);
    function allowance (address owner,address spender)external view returns(uint);
    function approve (address spender,uint amount)external returns(bool);
    function transferForm(address spender, address recipient,uint amount)external returns(bool);
    event Transfer(address indexed from ,address indexed to ,uint value);
    event Approval (address indexed owner,address indexed spender,uint value);
}
contract ERC20 is IERC20{
    uint public totalSupply;
    //of all balances
    mapping (address=>uint)public balanceOf;
    mapping (address => mapping(address=>uint))public allowance;
    string public name="Test example";
    string public symbol="Test";
    string public decimals =18;
    function transfer(address recipient,uint amount)external returns(bool){
        balanceOf[msg.sender]-=amount;
        balanceOf[recipient]+=amount;
        emit Transfer (msg.sender,recipient,amount);
        return true;

}
function approve(address spender,uint amount)external returns (bool){
    allowance[msg.sende][spender]=amount;
    emit Approval(msg.sender, spender, amount);
    return true;
}
function transferFrom(address from,address to ,uint amount)external returns(bool){
    allowance[from][msg.sender]-=amount;
    balanceOf[sender]-= amount;
    balanceOf[to]+=amount;
    emit Transfer(from, to, amount);
    return true;
}
function mint(uint amount)external{
    balanceOf[msg.sender]+=amount;
    totalSupply+=amount;
    emit Transfer(address(0), msg.sender, amount);
}
function burn(uint amount)external{
    balanceOf[msg.sender]-=amount;
    totalSupply-=amount;
    emit Trensfer (msg.sender,address(0),amount);
}

}
