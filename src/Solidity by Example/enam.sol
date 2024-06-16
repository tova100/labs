// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Enam{
    enam Status{
        cancel,
        shipped,
        accepted,
        reject,
}
Status public status;
function get()public view returns(Status){
    return status;
}
function set(Status _status)public{
    status=_status;
}
function cancel()public {
    status=status.cancel;
}
function reset ()public{
    delete status
}
}