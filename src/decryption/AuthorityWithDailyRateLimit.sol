// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/access/Ownable2Step.sol";

/// @notice The owner of the contract has at most 10 decryption credits per day. To
/// increase decryption credits, the owner must request a credit increase.
contract AuthorityWithDailyRateLimit is Ownable2Step {
    uint256 public availableCredits;

    uint256 public lastIncreaseTime;

    uint256 public constant MAX_DAILY_CREDIT_INREASE = 10;
    
    uint256 public constant SECONDS_IN_DAY = 86400;

    error RateLimit(string msg);

    constructor() Ownable(msg.sender) {
        lastIncreaseTime = block.timestamp;
        availableCredits = MAX_DAILY_CREDIT_INREASE;
    }

    function decryptionCredits(address decryptor) external view returns (uint256) {
        if (decryptor == owner()) {
            return availableCredits;
        } else {
            return 0;
        }
    }

    /// @notice Increase the decryptor's credits to the maximum daily credits.
    function increaseCredits() external onlyOwner() {
        if (block.timestamp <= (lastIncreaseTime + SECONDS_IN_DAY)) {
            revert RateLimit("Cannot increase credits more than once per 24 hours");
        }

        lastIncreaseTime = block.timestamp;
        availableCredits += MAX_DAILY_CREDIT_INREASE;
    }
}
