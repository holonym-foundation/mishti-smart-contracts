// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IOBLS {
    function totalVotingPower() external view returns (uint256);
    function votingPower(uint256 _index) external view returns (uint256);
}
