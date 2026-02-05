// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.4;

import "./FeeCalculatorBase.sol";

contract FeeCalculatorProd is FeeCalculatorBase {
    /// @notice Reference to the AttestationCenter contract
    IAttestationCenter public immutable attestationCenter;

    /// @notice Multiplier for performer rewards (scaled by 1e18)
    /// @dev Default: 1.0 * 1e18 = 1e18
    uint256 public performerMultiplier;

    /// @notice Multiplier for attestor rewards (scaled by 1e18)
    /// @dev Default: 0.1 * 1e18 = 1e17
    uint256 public attestorMultiplier;

    address public owner;

    event MultipliersUpdated(
        uint256 performerMultiplier,
        uint256 attestorMultiplier
    );

    error Unauthorized();
    error InvalidMultiplier();

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    /// @notice Constructor
    /// @param _attestationCenter Address of the AttestationCenter contract
    /// @param _performerMultiplier Initial performer multiplier (scaled by 1e18)
    /// @param _attestorMultiplier Initial attestor multiplier (scaled by 1e18)
    constructor(
        address _attestationCenter,
        uint256 _performerMultiplier,
        uint256 _attestorMultiplier
    ) {
        attestationCenter = IAttestationCenter(_attestationCenter);
        performerMultiplier = _performerMultiplier;
        attestorMultiplier = _attestorMultiplier;
        owner = msg.sender;
    }

    function getAttestationCenterContract()
        public
        view
        override
        returns (IAttestationCenter)
    {
        return IAttestationCenter(attestationCenter);
    }

    function getPerformerMultiplier() public view override returns (uint256) {
        return performerMultiplier;
    }

    function getAttestorMultiplier() public view override returns (uint256) {
        return attestorMultiplier;
    }

    function setMultipliers(
        uint256 _performerMultiplier,
        uint256 _attestorMultiplier
    ) external onlyOwner {
        if (_performerMultiplier == 0 || _attestorMultiplier == 0) {
            revert InvalidMultiplier();
        }
        performerMultiplier = _performerMultiplier;
        attestorMultiplier = _attestorMultiplier;
        emit MultipliersUpdated(_performerMultiplier, _attestorMultiplier);
    }
}
