// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.4;

import {Script, console} from "forge-std/Script.sol";
import {FeeCalculatorHook} from "../src/rewards/FeeCalculatorProd.sol";

contract DeployFeeCalculatorProd is Script {
    // Configuration - UPDATE THESE VALUES
    address constant ATTESTATION_CENTER =
        0xAF11912F9D7f6F3B9AE190439d2E41e972801EA2;
    uint256 constant PERFORMER_MULTIPLIER = 1e18; // 1.0x multiplier for performers
    uint256 constant ATTESTOR_MULTIPLIER = 1e17; // 0.1x multiplier for attestors

    function run() external {
        vm.startBroadcast();

        // Deploy FeeCalculatorProd
        FeeCalculatorProd feeCalculatorProd = new FeeCalculatorProd(
            ATTESTATION_CENTER,
            PERFORMER_MULTIPLIER,
            ATTESTOR_MULTIPLIER
        );

        vm.stopBroadcast();

        // Log deployment info
        console.log("==============================================");
        console.log(
            "FeeCalculatorProd deployed at:",
            address(feeCalculatorProd)
        );
        console.log("==============================================");
        console.log("Configuration:");
        console.log("  AttestationCenter:", ATTESTATION_CENTER);
        console.log("  Performer Multiplier:", PERFORMER_MULTIPLIER);
        console.log("  Attestor Multiplier:", ATTESTOR_MULTIPLIER);
        console.log("  Owner:", feeCalculatorProd.owner());
        console.log("==============================================");
    }
}
