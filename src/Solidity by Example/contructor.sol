// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

    contract X{
    string public name;
    constructor(string memory _name)public{
        name=_name;
    }
    }
    contract Y{
        string  public text;
        constructor (string memory _text)public{
            text=_text;
        }
    }
    contract B is X("Hello"),Y("Bay"){}
    contract Z is X,Y{
        constructor(string memory _text,string memory _name)X(_name),Y(_text){}
    }
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}