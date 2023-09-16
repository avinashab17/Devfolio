// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SafeWallet {
    address public owner;
    address public preSetAddress;
    uint256 public lastStillAliveCallBlockNumber;

    constructor(address _preSetAddress) {
        owner = msg.sender;
        preSetAddress = _preSetAddress;
        lastStillAliveCallBlockNumber = block.number;
    }

    function stillAlive() public {
        lastStillAliveCallBlockNumber = block.number;
    }

    function sendBalanceToPreSetAddress() public {
        require(msg.sender == owner, "Only the owner can call this function");
        require(block.number >= lastStillAliveCallBlockNumber + 10, "The owner has called still_alive in the last 10 blocks");

        // Send all of the contract's balance to the pre-set address
        (bool success, ) = preSetAddress.call{value: address(this).balance}("");
        require(success, "Failed to send balance to pre-set address");
    }
}
