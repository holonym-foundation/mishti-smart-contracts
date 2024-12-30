// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract MainnetAlphaRateLimit {
    uint256 public constant maxWhitelist = 10;
    uint256 public constant maxCreditIncrease = 1000000;
    
    address public owner;
    uint256 public numToIncreaseBy;
    uint256 public numWhitelisted;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) credits;
    mapping(address => uint256) nextTimeAllowedToIncreaseCredits;

    constructor() {
        owner = msg.sender;
        numToIncreaseBy = 500000; // Default value similar to RobustNetSimpleRateLimit
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Only whitelisted addresses can call this function");
        _;
    }

    function addToWhitelist(address user) external onlyOwner {
        require(!whitelisted[user], "Address already whitelisted");
        require(numWhitelisted < maxWhitelist, "Maximum whitelist capacity reached");
        
        whitelisted[user] = true;
        numWhitelisted++;
        // Give newly whitelisted address initial credits
        credits[user] = 100000;
    }

    function removeFromWhitelist(address user) external onlyOwner {
        require(whitelisted[user], "Address not whitelisted");
        
        whitelisted[user] = false;
        numWhitelisted--;
    }

    function setNumToIncreaseBy(uint256 newAmount) external onlyOwner {
        require(newAmount <= maxCreditIncrease, "Exceeds maximum allowed credit increase");
        numToIncreaseBy = newAmount;
    }

    function requestCredits() external onlyWhitelisted {
        require(block.timestamp >= nextTimeAllowedToIncreaseCredits[msg.sender], 
                "Cannot request credits more than once per 24 hours");
        
        credits[msg.sender] += numToIncreaseBy;
        nextTimeAllowedToIncreaseCredits[msg.sender] = block.timestamp + 86400;
    }

    function creditsFor(address user) external view returns (uint256) {
        return credits[user];
    }
}
