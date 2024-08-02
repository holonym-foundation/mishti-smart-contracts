// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

/// @notice A contract where Mishti Network operators can associate their 
/// peer ID and multiaddress with their Ethereum address.
contract PeerRegistry {
    struct Peer {
        address addr;
        string peerID;
        string multiaddr;
        string libp2pPubkey;
        string rsaPubkey;
    }

    Peer[] public peers;

    // operator address => index in peers array. Starts at 1, not 0. 0 means not found.
    mapping(address => uint256) public addrToIndex;

    event RegisterPeer(
        address indexed addr, 
        string peerID, 
        string multiaddr,
        string libp2pPubkey,
        string rsaPubkey
    );

    event UpdatePeer(
        address addr, 
        string peerID, 
        string multiaddr,
        string libp2pPubkey,
        string rsaPubkey
    );

    error PeerAlreadyExists();

    error PeerNotFound();

    constructor() {}

    /// @param peerID The libp2p peer ID of the operator.
    /// @param multiaddr The libp2p multiaddress of the operator.
    /// @param libp2pPubkey The libp2p public key of the operator. 
    ///        Must be hex encoded, without the 0x prefix.
    /// @param rsaPubkey The RSA public key of the operator. Must be PEM formatted.
    function register(
        string calldata peerID, 
        string calldata multiaddr,
        string calldata libp2pPubkey,
        string calldata rsaPubkey
    ) external {        
        if (addrToIndex[msg.sender] != 0) {
            revert PeerAlreadyExists();
        }
        
        // TODO: Maybe validate the public keys? Or maybe create an endpoint
        // in some API that validates the parameters to this function so that
        // operators can call it before calling this function.

        Peer memory peer = Peer({
            addr: msg.sender,
            peerID: peerID,
            multiaddr: multiaddr,
            libp2pPubkey: libp2pPubkey,
            rsaPubkey: rsaPubkey
        });
        peers.push(peer);
        addrToIndex[msg.sender] = peers.length;

        emit RegisterPeer(msg.sender, peerID, multiaddr, libp2pPubkey, rsaPubkey);
    }

    function updatePeer(
        string calldata peerID, 
        string calldata multiaddr,
        string calldata libp2pPubkey,
        string calldata rsaPubkey
    ) external {
        uint256 index = addrToIndex[msg.sender];
        if (index == 0) {
            revert PeerNotFound();
        }

        peers[index - 1].peerID = peerID;
        peers[index - 1].multiaddr = multiaddr;
        peers[index - 1].libp2pPubkey = libp2pPubkey;
        peers[index - 1].rsaPubkey = rsaPubkey;
        emit UpdatePeer(msg.sender, peerID, multiaddr, libp2pPubkey, rsaPubkey);
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
