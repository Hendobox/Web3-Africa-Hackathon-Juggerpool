// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name__, string memory symbol__) ERC20(name__, symbol__) {
        _mint(msg.sender, 1e28);
    }
}
