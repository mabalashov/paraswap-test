// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DAI is ERC20 {
    constructor(uint256 initialSupply) ERC20("DAI test token for local env", "DAI") {
        _mint(msg.sender, initialSupply);
    }
}