// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

/// @notice The owner of the contract can get a capped number of decryption credits per day
contract AuthorityDailyRateLimit {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
