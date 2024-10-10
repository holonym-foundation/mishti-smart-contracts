// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// This contract is a simple rate limiter that allows the owner to request credits, but only a certain amount per day
contract RobustNetSimpleRateLimit {
    address public whitelisted;
    mapping(address => uint256) credits;
    uint256 nextTimeAllowedToIncreaseCredits;
    
    constructor(address allowed) {
        whitelisted = allowed;
        // Give the whitelisted address an initial 100000 credits
        credits[whitelisted] = 100000;
    }

    modifier onlyWhitelisted() {
        require(msg.sender == whitelisted, "Only whitelisted address can call this function");
        _;
    }

    function requestCredits() public onlyWhitelisted {
        require(block.timestamp >= nextTimeAllowedToIncreaseCredits, "Cannot request credits more than once per 24 hours");
        credits[whitelisted] += 500000;
        nextTimeAllowedToIncreaseCredits = block.timestamp + 86400;
    }

    function creditsFor(address user) public view returns (uint256) {
        return credits[user];
    }
}
