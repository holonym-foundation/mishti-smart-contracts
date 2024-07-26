// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

/// @notice A contract where Mishti Network operators can associate their 
/// peer ID with their Ethereum address.
contract PeerRegistry {

    // operator address => peer ID
    mapping(address => string) public peers;

    event RegisterPeer(address addr, string peerID);
    
    error Unauthorized(string msg);

    constructor() {}

    function register(string calldata peerID) external {
        peers[msg.sender] = peerID;
        emit RegisterPeer(msg.sender, peerID);
    }
}
