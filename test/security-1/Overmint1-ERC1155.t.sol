// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { Overmint1_ERC1155, Attacker } from "../../src/security-1/Overmint1-ERC1155.sol";

contract Overmint1_ERC1155Test is Test {
    Attacker attackerContract;
    Overmint1_ERC1155 overmint;

    function setUp() public {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        overmint = new Overmint1_ERC1155();

        // Deploy "attackerContract"
        attackerContract = new Attacker(address(overmint));
    }

    function testOverMint() public {
        /** CODE YOUR SOLUTION HERE */

        console.log("Balance before attack: ", overmint.balanceOf(address(attackerContract), 0));

        vm.startPrank(address(attackerContract));
        attackerContract.attack(0); // Exploit the vulnerability
        vm.stopPrank();

        console.log("Balance after attack: ", overmint.balanceOf(address(attackerContract), 0));
        
        _checkSolved();
    }

    function _checkSolved() internal view {
        /** SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE */

        assertTrue(overmint.success(address(attackerContract), 0));
    }
}