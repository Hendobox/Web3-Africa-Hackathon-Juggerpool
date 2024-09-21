// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Juggerpool} from "../src/Juggerpool.sol";
import {Token} from "../src/mocks/Token.sol";

contract JuggerpoolScript is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        vm.startBroadcast(privateKey);

        Token token1 = new Token("Mock WETH", "MWETH");
        Token token2 = new Token("Mock WBTC", "MWBTC");
        console.log("Token1 conected in : ", address(token1));
        console.log("Token2 conected in : ", address(token2));

        Juggerpool juggerpool = new Juggerpool(address(token1), address(token2), owner);
        console.log("Juggerpool conected in : ", address(juggerpool));

        token1.approve(address(juggerpool), 500000000000000 * 10 ** token1.decimals());
        token2.approve(address(juggerpool), 500000000000000 * 10 ** token2.decimals());

        vm.stopBroadcast();
    }
}
