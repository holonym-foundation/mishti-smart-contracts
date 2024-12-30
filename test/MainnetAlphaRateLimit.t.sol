// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/credits/MainnetAlphaRateLimit.sol";

contract MainnetAlphaRateLimitTest is Test {
    MainnetAlphaRateLimit public rateLimit;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        rateLimit = new MainnetAlphaRateLimit();
    }

    function testInitialState() public {
        assertEq(rateLimit.owner(), owner);
        assertEq(rateLimit.numToIncreaseBy(), 500000);
        assertEq(rateLimit.numWhitelisted(), 0);
    }

    function testAddToWhitelist() public {
        rateLimit.addToWhitelist(user1);
        
        assertTrue(rateLimit.whitelisted(user1));
        assertEq(rateLimit.numWhitelisted(), 1);
        assertEq(rateLimit.creditsFor(user1), 100000);
    }

    function testCannotAddAlreadyWhitelisted() public {
        rateLimit.addToWhitelist(user1);
        
        vm.expectRevert("Address already whitelisted");
        rateLimit.addToWhitelist(user1);
    }

    function testCannotExceedMaxWhitelist() public {
        // Add maximum number of addresses
        for(uint i = 1; i <= 10; i++) {
            rateLimit.addToWhitelist(address(uint160(i)));
        }
        
        vm.expectRevert("Maximum whitelist capacity reached");
        rateLimit.addToWhitelist(address(11));
    }

    function testRemoveFromWhitelist() public {
        rateLimit.addToWhitelist(user1);
        rateLimit.removeFromWhitelist(user1);
        
        assertFalse(rateLimit.whitelisted(user1));
        assertEq(rateLimit.numWhitelisted(), 0);
    }

    function testCannotRemoveNonWhitelisted() public {
        vm.expectRevert("Address not whitelisted");
        rateLimit.removeFromWhitelist(user1);
    }

    function testSetNumToIncreaseBy() public {
        rateLimit.setNumToIncreaseBy(800000);
        assertEq(rateLimit.numToIncreaseBy(), 800000);
    }

    function testCannotExceedMaxCreditIncrease() public {
        vm.expectRevert("Exceeds maximum allowed credit increase");
        rateLimit.setNumToIncreaseBy(1000001);
    }

    function testRequestCredits() public {
        rateLimit.addToWhitelist(user1);
        
        vm.prank(user1);
        rateLimit.requestCredits();
        
        assertEq(rateLimit.creditsFor(user1), 600000); // 100000 initial + 500000 increase
    }

    function testCannotRequestCreditsIfNotWhitelisted() public {
        vm.prank(user1);
        vm.expectRevert("Only whitelisted addresses can call this function");
        rateLimit.requestCredits();
    }

    function testCannotRequestCreditsBeforeTimelock() public {
        rateLimit.addToWhitelist(user1);
        
        vm.prank(user1);
        rateLimit.requestCredits();
        
        vm.prank(user1);
        vm.expectRevert("Cannot request credits more than once per 24 hours");
        rateLimit.requestCredits();
    }

    function testCanRequestCreditsAfterTimelock() public {
        rateLimit.addToWhitelist(user1);
        
        vm.prank(user1);
        rateLimit.requestCredits();
        
        // Move forward 24 hours + 1 second
        vm.warp(block.timestamp + 86401);
        
        vm.prank(user1);
        rateLimit.requestCredits();
        
        assertEq(rateLimit.creditsFor(user1), 1100000); // 100000 initial + 2 * 500000
    }

    function testOnlyOwnerModifier() public {
        vm.prank(user1);
        vm.expectRevert("Only owner can call this function");
        rateLimit.addToWhitelist(user2);
    }
} 