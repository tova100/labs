// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Todos {
    struct Todo {
        string text;
        bool complate;
    }

    Todo[] public todos;

    function creat(string calldata _text) public {
        //1
        todos.push(Todo(_text, true));
        //2
        todos(Todo({text: _text, complate: true}));
        //3
        Todo memory todo;
        todo.text = _text;
        todos.push(todo);
    }

    function get(uint256 index) public view returns (Todo t) {
        Todo storage todo = todos[index];
        return todo;
    }

    function updateText(string calldata _text, uint256 index) public {
        Todo storage todo = todos[index];
        todo.text = _text;
    }

    function toggleComplated(uint256 index) public {
        Todo storage todo = todos[index];
        todo.complate = !todo.complate;
    }
}
