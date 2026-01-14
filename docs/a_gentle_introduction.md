# A Gentle Introduction to no_JIT

## Part 1: The Problem - What is a JIT Attack?

Imagine you are a baker selling bread (providing liquidity). A big tour bus (a large swap) is about to arrive at your shop. A competitor sees this, quickly sets up a temporary stall right next to you, sells bread to the tourists at a slightly better price, captures all the profit, and then vanishes before you can react.

This is a **Just-In-Time (JIT) Liquidity Attack** in DeFi. Attackers:
1.  **Detect** a large pending swap in the mempool.
2.  **Front-run** it by adding a huge amount of their own liquidity in a very narrow price range.
3.  **Capture** the lion's share of the swap fees.
4.  **Back-run** the swap by immediately removing their liquidity.

This entire sequence happens atomically within a single block, making passive Liquidity Providers (LPs) helpless victims.

## Part 2: The Solution - A Credible Threat

How do you stop the competitor? You can't physically block them. But what if you could instantly change your price sign to say: "Any new stall opening just for the tour bus pays a 90% 'franchise fee' on their sales"?

The competitor, knowing this rule is automatically enforced, wouldn't even bother setting up. They are deterred *before* they act.

This is the core idea of **no_JIT**. It's a "smart sign" for Uniswap v4 pools.

- **It watches for "new stalls":** It measures any large liquidity injection ($\Delta L$) within the current block.
- **It enforces the "franchise fee":** If $\Delta L$ is suspiciously large, it automatically applies a punitive swap fee ($\phi_{penalty}$) to the incoming swap.

The result? The JIT attacker's profit calculation turns negative. The attack is no longer profitable, so it is never initiated. The credible threat alone is the defense.

[➡️ **Ready for more? Let's dive into the technical details...**](./technical_deep_dive.md)
