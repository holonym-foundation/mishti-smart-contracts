// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {AuthorityWithDailyRateLimit} from "../src/decryption/AuthorityWithDailyRateLimit.sol";

contract AuthorityWithDailyRateLimitTest is Test {
    AuthorityWithDailyRateLimit public creditsContract;

    address public owner = 0xcf8272ff0895dEe55E23e06c382b1735e3a4a943;
    address public notOwner = 0xd554d8e64B90490eD540cE579c89cC90459F1a1D;

    function setUp() public {
        vm.prank(owner);
        creditsContract = new AuthorityWithDailyRateLimit();
    }

    // ------------ Constants tests ------------

    function test_MAX_DAILY_CREDIT_INREASE() public {
        assertEq(creditsContract.MAX_DAILY_CREDIT_INREASE(), 10);
    }
    
    function test_SECONDS_IN_DAY() public {
        assertEq(creditsContract.SECONDS_IN_DAY(), 86400);
    }
    
    // ------------ Function tests ------------

    // ------------ decryptionCredits tests ------------

    function test_decryptionCredits_InitialValueShouldBe10ForOwner() public {
        uint256 numCredits = creditsContract.decryptionCredits(owner);
        assertEq(numCredits, 10);
    }

    function test_decryptionCredits_InitialValueShouldBe0ForNonOwner() public {
        uint256 numCredits = creditsContract.decryptionCredits(notOwner);
        assertEq(numCredits, 0);
    }

    // ------------ increaseCredits tests ------------

    function testFuzz_increaseCredits_ShouldRevertIfNotOwner() public {
        vm.prank(notOwner);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector, 
                notOwner
            )
        );
        creditsContract.increaseCredits();
    }

    function testFuzz_increaseCredits_ShouldRevertIfTimeRateLimit() public {
        vm.prank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                AuthorityWithDailyRateLimit.RateLimit.selector, 
                "Cannot increase credits more than once per 24 hours"
            )
        );
        creditsContract.increaseCredits();
    }

    // ------------ decryptionCredits + increaseCredits tests ------------

    function test_increaseCredits_ShouldIncreaseCreditsBy10() public {
        vm.warp(block.timestamp + 1 days + 1 seconds);
        uint256 numCredits = creditsContract.decryptionCredits(owner);
        assertEq(numCredits, 10);

        vm.prank(owner);
        creditsContract.increaseCredits();
        numCredits = creditsContract.decryptionCredits(owner);
        assertEq(numCredits, 20);
    }

}
