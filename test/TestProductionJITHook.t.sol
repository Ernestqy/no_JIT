// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

import "../contracts/TestProductionJITHook.sol";

contract GovernorMock {
    function callSet(TestProductionJITHook hook, TestProductionJITHook.FeeTier[] calldata tiers) external {
        hook.setFeeTiers(tiers);
    }
}

contract TestProductionJITHookTest {
    function testConstructorRejectsEOA() public {
        // address with no code in test env
        bool didRevert = false;
        try new TestProductionJITHook(address(0), address(0x123)) {
            // shouldn't succeed
            didRevert = false;
        } catch {
            didRevert = true;
        }
        require(didRevert, "Expected revert when governor isn't contract");
    }

    function testSetFeeTiersAuthAndValidation() public {
        GovernorMock gov = new GovernorMock();
        TestProductionJITHook hook = new TestProductionJITHook(address(0), address(gov));

        // prepare valid tiers
        TestProductionJITHook.FeeTier[] memory tiers = new TestProductionJITHook.FeeTier[](2);
        tiers[0] = TestProductionJITHook.FeeTier({thresholdRatioBps: 100, feePips: 1000});
        tiers[1] = TestProductionJITHook.FeeTier({thresholdRatioBps: 200, feePips: 2000});

        // call via governor contract
        gov.callSet(hook, tiers);
        require(hook.tiersCount() == 2, "tiers not set");

        // now try invalid (non-increasing) tiers and expect revert
        TestProductionJITHook.FeeTier[] memory bad = new TestProductionJITHook.FeeTier[](2);
        bad[0] = TestProductionJITHook.FeeTier({thresholdRatioBps: 200, feePips: 1000});
        bad[1] = TestProductionJITHook.FeeTier({thresholdRatioBps: 100, feePips: 2000});

        bool reverted = false;
        try gov.callSet(hook, bad) {
            reverted = false;
        } catch {
            reverted = true;
        }
        require(reverted, "Expected revert on non-increasing thresholds");
    }
}
