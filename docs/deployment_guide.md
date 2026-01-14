# Deployment & Integration Guide

Deploying the `no_JIT` Hook adds a powerful layer of economic security to any Uniswap v4 pool. This guide outlines the steps for deployment and integration.

## Prerequisites

- **A Deployed Uniswap v4 Core:** You need a running instance of the Uniswap v4 contracts (`PoolManager`).
- **Foundry:** For compiling and deploying.
- **Governor Address:** An address (ideally a Multisig or DAO Timelock) that will have administrative control over the hook's parameters.

## Step 1: Deployment

The hook contract is self-contained. Deploy it using Foundry:

```bash
# Ensure your .env file has PRIVATE_KEY and an RPC_URL
forge create src/ProductionJITHook.sol:ProductionJITHook \
    --rpc-url $RPC_URL \
    --private-key $PRIVATE_KEY \
    --constructor-args <POOL_MANAGER_ADDRESS> <GOVERNOR_ADDRESS> \
    --verify
```

- **`<POOL_MANAGER_ADDRESS>`:** The address of the deployed `PoolManager.sol`.
- **`<GOVERNOR_ADDRESS>`:** The address designated for governance.

Take note of the deployed hook's address.

## Step 2: Pool Initialization with the Hook

When creating a new Uniswap v4 pool, you must specify the hook address during initialization.

The `PoolManager`'s `initialize` function takes a `hook` parameter. Provide the address of your newly deployed `ProductionJITHook` contract here.

**Example using Foundry script:**

```solidity
// In a Forge script
IPoolManager.PoolKey memory key = IPoolManager.PoolKey({
    currency0: token0,
    currency1: token1,
    fee: 3000,
    tickSpacing: 60,
    hooks: address(deployedJitHook) // <-- CRITICAL STEP
});

poolManager.initialize(key, initialSqrtPriceX96, bytes(""));
```

**Important:** The hook must be set at the time of pool creation. It cannot be added to an existing pool.

## Step 3: Initial Configuration (by Governor)

Once deployed, the governor must configure the hook's parameters to activate the defense.

```solidity
// This would be a call from the Governor address
function configureHook(ProductionJITHook hook) public {
    // Corresponds to τ in the paper
    // Example: Set threshold to 10% of total liquidity
    hook.setThreshold(1000); // 1000 bps = 10%

    // Corresponds to φ_penalty in the paper
    // Example: Set penalty fee to 1.00%
    hook.setPenaltyFee(10000); // 10000 pips = 1%
}
```

After this transaction is confirmed, the `no_JIT` defense is fully active for all swaps in the associated pool.

## Integration Considerations

- **Gas Overhead:** The `beforeSwap` and `afterAddLiquidity` logic is highly optimized. It involves 1 SLOAD and 1 SSTORE per liquidity addition in a block, and 1 SLOAD per swap. The overhead is minimal and predictable.
- **Frontend Integration:** Ensure your dApp's frontend can correctly interpret potential swap failures or altered fee information if a trade is identified as part of a JIT attack.
