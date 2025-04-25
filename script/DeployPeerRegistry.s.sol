// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/PeerRegistry.sol";

contract DeployPeerRegistry is Script {
    function run() external {
        // This will start recording transactions for broadcasting
        vm.startBroadcast();

        // Deploy the contract
        PeerRegistry peerRegistry = new PeerRegistry();

        vm.stopBroadcast();
    }
} 