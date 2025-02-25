// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/security-1/GuessSecretNumber.sol";

contract GuessTheSecretNumnerTest is Test {
    Attacker attackerContract;
    GuessTheSecretNumner guessTheSecretNumner;

    function setUp() public {
        /**
         * SETUP SCENARIO - NO NEED CHANGE ANYTHING HERE
         */

        // Deploy "GuessTheSecretNumner" contract and deposit one ether into it
        guessTheSecretNumner = (new GuessTheSecretNumner){value: 1 ether}();
    }

    function testExploit() public {
        /**
         * CODE YOUR SOLUTION HERE
         */
        attackerContract = new Attacker(address(guessTheSecretNumner));
        _checkSolved(attackerContract.secretNumber());
    }

    function _checkSolved(uint8 _secretNumber) internal {
        /**
         * SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE
         */

        assertTrue(guessTheSecretNumner.guess{value: 1 ether}(_secretNumber), "Wrong Number");
        assertTrue(guessTheSecretNumner.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}