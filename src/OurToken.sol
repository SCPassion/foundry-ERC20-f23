// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    // ERC20 is the contract we are inheriting from, which has a constructor that takes in a string and a string
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
        // what is this msg.sender? It is the address of the person who deployed the contract
    }
}
