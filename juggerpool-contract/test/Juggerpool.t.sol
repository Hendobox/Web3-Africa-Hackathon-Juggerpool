// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {Juggerpool, Param} from "../src/Juggerpool.sol";
import {Token} from "../src/mocks/Token.sol";

contract JuggerpoolTest is Test {
    Juggerpool juggerpool;
    Token token1;
    Token token2;
    address owner = address(0x123);
    address user = address(0x456);

    function setUp() public {
        token1 = new Token("Token1", "TK1");
        token2 = new Token("Token2", "TK2");
        juggerpool = new Juggerpool(address(token1), address(token2), owner);

        token1.transfer(user, 1000 * 10 ** token1.decimals());
        token2.transfer(user, 1000 * 10 ** token2.decimals());

        // Label addresses for better debugging in Foundry
        vm.label(owner, "Owner");
        vm.label(user, "User");
    }

    function testWhitelistTokens() public {
        // Check if tokens are whitelisted
        assert(juggerpool.isWhitelisted(address(token1)));
        assertTrue(juggerpool.isWhitelisted(address(token2)));
    }

    function testDepositCollateral() public {
        // Start pretending to be the user
        vm.startPrank(user);

        token1.approve(address(juggerpool), 500 * 10 ** token1.decimals());
        token2.approve(address(juggerpool), 500 * 10 ** token2.decimals());

        Param[] memory params = new Param[](2);
        params[0] = Param(address(token1), 500 * 10 ** token1.decimals());
        params[1] = Param(address(token2), 500 * 10 ** token2.decimals());

        juggerpool.depositCollateral(params);

        uint256 userBalance = juggerpool.userCollateral(user, address(token1));
        assertEq(userBalance, 500 * 10 ** token1.decimals());

        vm.stopPrank();
    }

    function testWithdrawCollateral() public {
        vm.startPrank(user);

        token1.approve(address(juggerpool), 500 * 10 ** token1.decimals());
        Param[] memory params = new Param[](1);
        params[0] = Param(address(token1), 500 * 10 ** token1.decimals());
        juggerpool.depositCollateral(params);

        juggerpool.withdrawCollateral(params);
        uint256 userBalance = juggerpool.userCollateral(user, address(token1));
        assertEq(userBalance, 0);

        vm.stopPrank();
    }
}
