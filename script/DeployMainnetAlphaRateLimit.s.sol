// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/credits/MainnetAlphaRateLimit.sol";

contract DeployMainnetAlphaRateLimit is Script {
    function run() external {
        // This will start recording transactions for broadcasting
        vm.startBroadcast();

        // Deploy the contract
        MainnetAlphaRateLimit rateLimit = new MainnetAlphaRateLimit();

        vm.stopBroadcast();
    }
} 