// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

/// @notice A contract where Mishti Network operators can associate their 
/// peer ID and multiaddress with their Ethereum address.
contract PeerRegistry {
    struct Peer {
        address addr;
        string peerID;
        string multiaddr;
    }

    Peer[] public peers;

    // operator address => index in peers array. Starts at 1, not 0. 0 means not found.
    mapping(address => uint256) public addrToIndex;

    event RegisterPeer(address indexed addr, string peerID, string multiaddr);

    event UpdatePeer(address addr, string peerID, string multiaddr);

    error PeerAlreadyExists();

    error PeerNotFound();

    constructor() {}

    function register(string calldata peerID, string calldata multiaddr) external {        
        if (addrToIndex[msg.sender] != 0) {
            revert PeerAlreadyExists();
        }
        
        Peer memory peer = Peer({
            addr: msg.sender,
            peerID: peerID,
            multiaddr: multiaddr
        });
        peers.push(peer);
        addrToIndex[msg.sender] = peers.length;

        emit RegisterPeer(msg.sender, peerID, multiaddr);
    }

    function updatePeer(string calldata peerID, string calldata multiaddr) external {
        uint256 index = addrToIndex[msg.sender];
        if (index == 0) {
            revert PeerNotFound();
        }

        peers[index - 1].peerID = peerID;
        peers[index - 1].multiaddr = multiaddr;
        emit UpdatePeer(msg.sender, peerID, multiaddr);
    }

    function removePeer() public {
        uint256 index = addrToIndex[msg.sender];
        if (index != 0) {
            uint256 lastIndex = peers.length - 1;
            Peer memory lastPeer = peers[lastIndex];

            peers[index - 1] = lastPeer;
            addrToIndex[lastPeer.addr] = index;

            peers.pop();
            delete addrToIndex[msg.sender];
        }
    }

    function getPeers() external view returns (Peer[] memory) {
        return peers;
    }
}
