// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/security-1/GuessNewNumber.sol";

contract GuessNewNumberTest is Test {
    GuessNewNumber public guessNewNumber;
    Attacker public attackerContract;

    function setUp() public {
        /**
         * SETUP SCENARIO - NO NEED CHANGE ANYTHING HERE
         */
        vm.deal(address(this), 10 ether);

        // Deploy contract
        guessNewNumber = new GuessNewNumber{value: 1 ether}();
    }

    function testExploit() public {
        /**
         * CODE YOUR SOLUTION HERE
         */
        
        // Convert guessNewNumber to payable address
        address payable guessNewNumberPayable = payable(address(guessNewNumber));

        // Deploy attacker contract
        attackerContract = new Attacker{value: 1 ether}(guessNewNumberPayable);

        // Send 1 ether to guessNewNumber
        (bool success, ) = address(guessNewNumber).call{value: 1 ether}("");
        require(success, "Failed to send 1 ether to GuessNewNumber");

        // Check if guessNewNumber balance is 2 ether
        require(address(guessNewNumber).balance == 2 ether, "GuessNewNumber balance should be 2 ether");

        // call function attack to activate the exploit
        attackerContract.attack();

        _checkSolved(attackerContract.answer());
    }

    function _checkSolved(uint8 _newNumber) internal {
        /**
         * SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE
         */

        assertTrue(guessNewNumber.guess{value: 1 ether}(_newNumber), "Wrong Number");
        assertTrue(guessNewNumber.isComplete(), "Balance is supposed to be zero");
    }

    receive() external payable {}
}