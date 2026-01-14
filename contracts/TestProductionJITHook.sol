// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

/// @notice Simplified, testable version of ProductionJITHook for unit tests.
contract TestProductionJITHook {
    struct FeeTier {
        uint128 thresholdRatioBps;
        uint24 feePips;
    }

    FeeTier[] public feeTiers;
    address public immutable governor;

    uint256 public constant MAX_TIERS = 16;
    uint24 public constant MAX_FEEPIPS = 1_000_000;

    event FeeTiersUpdated(uint256 length, address indexed governor);

    constructor(address /*poolManager*/, address _governor) {
        require(_governor != address(0), "ZeroGovernor");
        require(_governor.code.length > 0, "GovernorNotContract");
        governor = _governor;
    }

    function setFeeTiers(FeeTier[] calldata _newTiers) external {
        require(msg.sender == governor, "Auth");
        require(_newTiers.length <= MAX_TIERS, "TooManyTiers");

        uint128 lastThreshold = 0;
        for (uint256 i = 0; i < _newTiers.length; i++) {
            require(_newTiers[i].thresholdRatioBps > 0, "ZeroThreshold");
            require(_newTiers[i].feePips <= MAX_FEEPIPS, "FeeTooLarge");
            require(_newTiers[i].thresholdRatioBps > lastThreshold, "NonIncreasingThresholds");
            lastThreshold = _newTiers[i].thresholdRatioBps;
        }

        delete feeTiers;
        for (uint256 i = 0; i < _newTiers.length; i++) {
            feeTiers.push(_newTiers[i]);
        }

        emit FeeTiersUpdated(feeTiers.length, governor);
    }

    function tiersCount() external view returns (uint256) {
        return feeTiers.length;
    }
}
