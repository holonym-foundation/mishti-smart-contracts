// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.4;

import "./IAttestationCenter.sol";
import "./IFeeCalculator.sol";

error CalculateBaseRewardFeesBlocked();

/// @notice Struct to decode task data
struct TaskData {
    uint256 task_size;
    address[] performers;
}
abstract contract FeeCalculatorBase is IFeeCalculator {
    function getAttestationCenterContract()
        public
        view
        virtual
        returns (IAttestationCenter);
    function getPerformerMultiplier() public view virtual returns (uint256);
    function getAttestorMultiplier() public view virtual returns (uint256);

    /// @dev This function should never be called since base reward fees are disabled
    function calculateBaseRewardFees(
        FeeCalculatorData calldata
    ) external pure returns (uint256, uint256, uint256) {
        revert CalculateBaseRewardFeesBlocked();
    }

    /// @notice Calculates fees per attester based on the aggregation of it's performer rewards and the attestor rewards.
    /// @param _feeCalculatorData Struct containing attester IDs.
    /// @return feesPerId Array of FeePerId containing attester IDs and their allocated reward.
    function calculateFeesPerId(
        FeeCalculatorData calldata _feeCalculatorData
    ) external view returns (FeePerId[] memory feesPerId) {
        // Decode task data to extract task size and performer addresses
        TaskData memory taskData = abi.decode(
            _feeCalculatorData.data.data,
            (TaskData)
        );

        uint256 taskSize = taskData.task_size;
        address[] memory performerAddresses = taskData.performers;
        uint256[] memory attesterIds = _feeCalculatorData.attestersIds;

        // Calculate max possible unique operators
        uint256 maxOperators = performerAddresses.length + attesterIds.length;

        // Temporary array to hold all fees (may contain duplicates)
        FeePerId[] memory tempFees = new FeePerId[](maxOperators);
        IAttestationCenter attestationCenterContract = getAttestationCenterContract();
        uint256 performerMultiplier = getPerformerMultiplier();
        uint256 attestorMultiplier = getAttestorMultiplier();

        uint256 uniqueCount = 0;
        // Create a mapping to track operator fees (using memory simulation)
        // We'll use a simple linear search approach for consolidation

        // Step 1: Process performers
        for (uint256 i = 0; i < performerAddresses.length; i++) {
            uint256 operatorId = attestationCenterContract
                .operatorsIdsByAddress(performerAddresses[i]);

            // Skip if operator is not registered (operatorId == 0)
            if (operatorId == 0) continue;

            uint256 performerReward = (performerMultiplier * taskSize) / 1e18;

            // Check if this operator already exists in our array
            bool found = false;
            for (uint256 j = 0; j < uniqueCount; j++) {
                if (tempFees[j].index == operatorId) {
                    tempFees[j].fee += performerReward;
                    found = true;
                    break;
                }
            }

            if (!found) {
                tempFees[uniqueCount] = FeePerId({
                    index: operatorId,
                    fee: performerReward
                });
                uniqueCount++;
            }
        }

        // Step 2: Process attesters
        for (uint256 i = 0; i < attesterIds.length; i++) {
            uint256 operatorId = attesterIds[i];

            // Skip if operator ID is 0
            if (operatorId == 0) continue;

            uint256 attesterReward = (attestorMultiplier * taskSize) / 1e18;

            // Check if this operator already exists in our array
            bool found = false;
            for (uint256 j = 0; j < uniqueCount; j++) {
                if (tempFees[j].index == operatorId) {
                    tempFees[j].fee += attesterReward;
                    found = true;
                    break;
                }
            }

            if (!found) {
                tempFees[uniqueCount] = FeePerId({
                    index: operatorId,
                    fee: attesterReward
                });
                uniqueCount++;
            }
        }

        // Step 3: Trim the array to remove empty entries
        feesPerId = _trimArray(tempFees, uniqueCount);

        return feesPerId;
    }
    /// @notice Helper function to trim memory array to actual size
    /// @param _array Original array with potential empty entries
    /// @param _actualLength Actual number of valid entries
    /// @return trimmed Trimmed array with only valid entries
    function _trimArray(
        FeePerId[] memory _array,
        uint256 _actualLength
    ) private pure returns (FeePerId[] memory trimmed) {
        trimmed = new FeePerId[](_actualLength);
        for (uint256 i = 0; i < _actualLength; i++) {
            trimmed[i] = _array[i];
        }
        return trimmed;
    }

    /// @notice Returns whether this contract calculates base reward fees (always false).
    function isBaseRewardFee() external pure override returns (bool) {
        return false;
    }
}
