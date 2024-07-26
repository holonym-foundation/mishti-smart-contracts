// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {AuthorityWithDailyRateLimitV2} from "../src/decryption/AuthorityWithDailyRateLimitV2.sol";

contract AuthorityWithDailyRateLimitV2Test is Test {
    AuthorityWithDailyRateLimitV2 public conditionsContract;

    address public owner = 0xcf8272ff0895dEe55E23e06c382b1735e3a4a943;
    address public notOwner = 0xd554d8e64B90490eD540cE579c89cC90459F1a1D;

    function setUp() public {
        vm.prank(owner);
        conditionsContract = new AuthorityWithDailyRateLimitV2();
    }

    // ------------ Constants tests ------------

    function test_SECONDS_IN_DAY() public {
        uint256 secondsInDay = 86400;
        assertEq(conditionsContract.EXPIRE_OFFSET(), secondsInDay);
    }
    
    // ------------ Function tests ------------

    // ------------ requestDecryption + canDecrypt tests ------------

    function test_integration() public {
        bytes32 c1Hash = 0x0000000000000000000000000000000000000000000000000000000000000001;
        bytes32 c1Hash2 = 0x0000000000000000000000000000000000000000000000000000000000000002;
        

        bool canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
        assert(!canDecrypt);

        // Request decryption
        vm.prank(owner);
        conditionsContract.requestDecryption(c1Hash);

        // canDecrypt should return true for the next 24 hours.
        for (uint i = 0; i < 23; i++) {
            bool canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
            assert(canDecrypt);
            vm.warp(block.timestamp + 1 hours);
        }
        vm.warp(block.timestamp + 59 minutes);
        assert(conditionsContract.canDecrypt(owner, c1Hash));

        // Request decryption for another c1Hash and check canDecrypt to 
        // make sure the contract can keep track of multiple requests
        vm.prank(owner);
        conditionsContract.requestDecryption(c1Hash2);
        canDecrypt = conditionsContract.canDecrypt(owner, c1Hash2);
        assert(canDecrypt);

        // Request 8 more decryptions to reach the limit
        for (uint i = 0; i < 8; i++) {
            vm.prank(owner);
            conditionsContract.requestDecryption(c1Hash);
        }

        // Request 1 more decryption, and expect revert with RateLimit error
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                AuthorityWithDailyRateLimitV2.RateLimit.selector, 
                "Oldest request is not expired. A decryptor can only make 10 requests per 24 hours."
            )
        );
        conditionsContract.requestDecryption(c1Hash);

        // Warp forward 24 hours to expire all requests.
        // canDecrypt should return false because all requests have expired
        vm.warp(block.timestamp + 24 hours);
        canDecrypt = conditionsContract.canDecrypt(owner, c1Hash);
        assert(!canDecrypt);
        canDecrypt = conditionsContract.canDecrypt(owner, c1Hash2);
        assert(!canDecrypt);
    }
}
