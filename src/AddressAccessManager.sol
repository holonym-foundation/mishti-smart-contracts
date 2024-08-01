// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract AddressAccessManager {
    address public owner;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    function removeFromWhitelist(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    function addToBlacklist(address _address) public onlyOwner {
        blacklist[_address] = true;
    }

    function removeFromBlacklist(address _address) public onlyOwner {
        blacklist[_address] = false;
    }

    function isWhitelisted(address _address) public view returns (bool) {
        return whitelist[_address];
    }

    function isBlacklisted(address _address) public view returns (bool) {
        return blacklist[_address];
    }
}
