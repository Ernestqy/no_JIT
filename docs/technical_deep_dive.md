# Technical Deep Dive

This document bridges the gap between our academic paper and the Solidity implementation.

## From HJI Equations to Solidity Logic

The core of our paper is the **Hamilton-Jacobi-Isaacs (HJI) equation**, which models the zero-sum game between the LP (Defender) and the JIT Attacker. The solution to this equation yields a **Nash Equilibrium**:

> The LP's optimal strategy is to commit to a threshold-based fee policy. If an attack signal is detected, a punitive fee high enough to negate the attacker's profit is applied.

This theoretical result is translated into `ProductionJITHook.sol` as follows:

### 1. The State Variable: `BlockAudit`
The primary state variable the LP observes is the change in liquidity within the current block.

```solidity
struct BlockAudit {
    uint128 deltaL;   // Corresponds to ΔL in the paper
    uint64 lastBlock;
}
mapping(PoolId => BlockAudit) public poolAudits;
```
This is updated in the `afterAddLiquidity` hook, which acts as our real-time sensor.

### 2. The Control Variable: `overrideFee`
The LP's control variable is the swap fee ($\phi$). Uniswap v4 allows us to override the default pool fee by returning a new fee with the `OVERRIDE_FEE_FLAG`.

### 3. The Equilibrium Strategy: `beforeSwap` Logic
The `beforeSwap` hook is where the equilibrium strategy is executed.

```solidity
function beforeSwap(...) returns (..., uint24 fee) {
    // 1. Observe the state (ΔL for the current block)
    BlockAudit memory audit = poolAudits[poolId];
    
    // 2. Evaluate the attack signal
    // The signal is a high ratio of ΔL to the total pool liquidity (L_total)
    uint256 currentRatioBps = (uint256(audit.deltaL) * 10000) / L_total;

    // 3. Apply the optimal policy (Theorem 1 in paper)
    if (currentRatioBps > thresholdTauBps) {
        // Attack detected: apply punitive fee (φ_penalty)
        return (... , PHI_PENALTY | LPFeeLibrary.OVERRIDE_FEE_FLAG);
    }

    // No attack: do nothing, use default fee
    return (... , 0);
}
```
This simple `if-then` statement is the direct implementation of the complex game-theoretic result.

## Why Oracle-Free is Crucial

The entire logic relies *only* on `block.number` and `pool.getLiquidity()`. This makes the hook:
- **Robust:** No single point of failure from an external oracle.
- **Secure:** Immune to oracle manipulation attacks.
- **Gas-Efficient:** Avoids costly external calls.

[➡️ **Learn how to deploy this hook...**](./deployment_guide.md)
