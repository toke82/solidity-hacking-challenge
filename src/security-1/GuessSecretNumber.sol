// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract GuessTheSecretNumner {
    bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    constructor() payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable returns (bool) {
        require(msg.value == 1 ether, "requires 1 ether to transfr");

        if (keccak256(abi.encodePacked(n)) == answerHash) {
            (bool ok,) = msg.sender.call{value: 2 ether}("");
            require(ok, "Fail to send to Send 2 ether");
        }
        return true;
    }
}

/** CODE YOUR SOLUTION HERE */
contract Attacker {
    uint8 public secretNumber;

    GuessTheSecretNumner public guessTheSecretNumner;

    constructor(address _guessTheSecretNumberAddress) {
        guessTheSecretNumner = GuessTheSecretNumner(_guessTheSecretNumberAddress);

        // Find the secret number
        for (uint8 i = 0; i < 256; i++) {
            if (keccak256(abi.encodePacked(i)) == 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365) {
                secretNumber = i;
                break;
            }
        }
    }
}