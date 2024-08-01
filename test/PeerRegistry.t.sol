// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PeerRegistry} from "../src/PeerRegistry.sol";

contract PeerRegistryTest is Test {
    PeerRegistry public peerRegistry;

    address public dummyAddr = 0xcf8272ff0895dEe55E23e06c382b1735e3a4a943;

    function setUp() public {
        peerRegistry = new PeerRegistry();
    }

    function test_integration() public {
        string memory peerID = "peerID";
        string memory multiaddr = "multiaddr";

        // Assert initially empty
        assertEq(peerRegistry.getPeers().length, 0);
        assertEq(peerRegistry.addrToIndex(dummyAddr), 0);

        // Register peer
        vm.prank(dummyAddr);
        vm.expectEmit();
        emit PeerRegistry.RegisterPeer(dummyAddr, peerID, multiaddr);
        peerRegistry.register(peerID, multiaddr);

        // Assert register successful
        PeerRegistry.Peer[] memory peers = peerRegistry.getPeers();
        assertEq(peers.length, 1);
        assertEq(peerRegistry.addrToIndex(dummyAddr), 1);
        assertEq(peers[0].addr, dummyAddr);
        assertEq(peers[0].peerID, peerID);
        assertEq(peers[0].multiaddr, multiaddr);

        // Try to register again
        vm.prank(dummyAddr);
        vm.expectRevert(PeerRegistry.PeerAlreadyExists.selector);
        peerRegistry.register(peerID, multiaddr);

        // Update peer
        peerID = "peerID2";
        multiaddr = "multiaddr2";
        vm.prank(dummyAddr);
        peerRegistry.updatePeer(peerID, multiaddr);

        // Assert update successful
        peers = peerRegistry.getPeers();
        assertEq(peers.length, 1);
        assertEq(peerRegistry.addrToIndex(dummyAddr), 1);
        assertEq(peers[0].addr, dummyAddr);
        assertEq(peers[0].peerID, peerID);
        assertEq(peers[0].multiaddr, multiaddr);

        // Remove peer
        vm.prank(dummyAddr);
        peerRegistry.removePeer();

        // Assert remove successful
        peers = peerRegistry.getPeers();
        assertEq(peers.length, 0);
    }

    // ------------ requestDecryption + canDecrypt tests ------------

    // function test_integration() public {
    //     bytes32 c1Hash = 0x0000000000000000000000000000000000000000000000000000000000000001;
    //     bytes32 c1Hash2 = 0x0000000000000000000000000000000000000000000000000000000000000002;
        

    //     bool canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
    //     assert(!canDecrypt);

    //     // Request decryption
    //     vm.prank(owner);
    //     conditionsContract.requestDecryption(c1Hash);

    //     // canDecrypt should return true for the next 24 hours.
    //     for (uint i = 0; i < 23; i++) {
    //         bool canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
    //         assert(canDecrypt);
    //         vm.warp(block.timestamp + 1 hours);
    //     }
    //     vm.warp(block.timestamp + 59 minutes);
    //     assert(conditionsContract.canDecrypt(owner, c1Hash));

    //     // Request decryption for another c1Hash and check canDecrypt to 
    //     // make sure the contract can keep track of multiple requests
    //     vm.prank(owner);
    //     conditionsContract.requestDecryption(c1Hash2);
    //     canDecrypt = conditionsContract.canDecrypt(owner, c1Hash2);
    //     assert(canDecrypt);

    //     // Request 8 more decryptions to reach the limit
    //     for (uint i = 0; i < 8; i++) {
    //         vm.prank(owner);
    //         conditionsContract.requestDecryption(c1Hash);
    //     }

    //     // Request 1 more decryption, and expect revert with RateLimit error
    //     vm.prank(owner);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             AuthorityWithDailyRateLimitV2.RateLimit.selector, 
    //             "Oldest request is not expired. A decryptor can only make 10 requests per 24 hours."
    //         )
    //     );
    //     conditionsContract.requestDecryption(c1Hash);

    //     // Warp forward 24 hours to expire all requests.
    //     // canDecrypt should return false because all requests have expired
    //     vm.warp(block.timestamp + 24 hours);
    //     canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
    //     assert(!canDecrypt);
    //     canDecrypt = conditionsContract.canDecrypt(owner, c1Hash2);
    //     assert(!canDecrypt);
    // }
}
