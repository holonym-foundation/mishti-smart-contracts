// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract MainnetAlphaRateLimit {
    uint256 public constant maxWhitelist = 100;
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

    // Usage: `cast send 0x18494fecf61d2282c45b8bf481403c1fcb5d94e6 "addToWhitelist(address)" <ADDRESS TO WHITELIST> --rpc-url https://eth.llamarpc.com --hd-path "m/44'/60'/2'/0/0" --ledger`
    // for example `cast send 0x18494fecf61d2282c45b8bf481403c1fcb5d94e6 "addToWhitelist(address)" 0xdD4E810D50f07fB77d4c6A9CCe0399e75bfcd972 --rpc-url https://eth.llamarpc.com --hd-path "m/44'/60'/2'/0/0" --ledger`
    function addToWhitelist(address user) external onlyOwner {
        require(!whitelisted[user], "Address already whitelisted");
        require(numWhitelisted < maxWhitelist, "Maximum whitelist capacity reached");
        
        whitelisted[user] = true;
        numWhitelisted++;
        // Give newly whitelisted address initial credits
        credits[user] = 100000;
    }

    function addToMasterWhitelist(address user) external onlyOwner {
        require(!whitelisted[user], "Address already whitelisted");
        require(numWhitelisted < maxWhitelist, "Maximum whitelist capacity reached");
        
        whitelisted[user] = true;
        numWhitelisted++;
        // Give newly master whitelisted address a fixed credits value of 0
        credits[user] = 0;
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

        require(credits[msg.sender]>0, "No need to increase, you have unlimited access")

        require(block.timestamp >= nextTimeAllowedToIncreaseCredits[msg.sender], 
                "Cannot request credits more than once per 24 hours");
        
        credits[msg.sender] += numToIncreaseBy;
        nextTimeAllowedToIncreaseCredits[msg.sender] = block.timestamp + 86400;
    }

    function creditsFor(address user) external view returns (uint256) {
        require(whitelisted[user], "Address not whitelisted");
        return credits[user];
    }
}
