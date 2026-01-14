# Security Considerations & Best Practices

The `no_JIT` hook is a security-critical component. This document outlines its security model, potential risks, and best practices.

## Core Security Assertions

1.  **Oracle-Free:** The hook's logic is self-contained and does not rely on any external price or data oracles. This eliminates a major class of manipulation vectors.
2.  **Permissioned Configuration:** All critical parameters (`thresholdTau`, `phiPenalty`) are controlled by a designated `governor` address. This prevents unauthorized changes.
3.  **No Fund Custody:** The hook contract **does not** hold or manage any user funds, tokens, or liquidity. It only influences pool parameters (the fee) during a swap.

## Potential Risks & Mitigations

### 1. Governance Risk
- **Risk:** A compromised or malicious governor could set parameters to unfavorable values (e.g., setting `phiPenalty` to 100% to halt trading).
- **Mitigation:** The `governor` address **MUST** be a robust, time-locked multisig wallet or a fully audited DAO contract. It should **NEVER** be a regular Externally Owned Account (EOA).

### 2. Gas Bumping & Re-orgs
- **Risk:** An attacker could try to manipulate the perceived `deltaL` by having liquidity additions re-ordered within a block or across short-lived chain re-orgs.
- **Mitigation:** The hook's logic is stateless across blocks. It resets `deltaL` on the first transaction of a new block (`block.number > lastBlock`). This makes it resilient to most re-orgs, as the state will be correctly recalculated in the canonical chain.

### 3. Parameter Calibration Risk
- **Risk:** An incorrectly calibrated `thresholdTau` could either fail to detect real attacks (if too high) or incorrectly punish legitimate large liquidity deposits (if too low).
- **Mitigation:** The `governor` should implement a data-driven process for setting this parameter, potentially based on historical analysis of the pool's liquidity patterns. The parameter should be adaptable.

## Audits

This codebase is provided for academic and experimental use and has not yet undergone a formal third-party security audit. We strongly recommend a full audit before any mainnet deployment with significant value at stake.

---
We encourage responsible disclosure of any potential vulnerabilities. Please open a confidential issue or contact the project maintainers directly.
