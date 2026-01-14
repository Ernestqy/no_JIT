<div align="center">
  <h1>no_JIT: A Game-Theoretic Defense for Uniswap v4 LPs</h1>
  
  <p>
    <strong>基于微分博弈论的 Uniswap v4 流动性保护钩子</strong>
    <br/>
    <em>Uniswap V4のLPを守る、微分ゲーム理論に基づくフック</em>
  </p>

  <!-- Shields/Badges -->
  <p>
    <a href="https://github.com/imbue-bit/no_JIT/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License"></a>
    <a href="https://soliditylang.org/"><img src="https://img.shields.io/badge/Solidity-^0.8.26-E91E63.svg?style=for-the-badge&logo=solidity" alt="Solidity"></a>
    <a href="https://uniswap.org/"><img src="https://img.shields.io/badge/Uniswap-v4-ff007a?style=for-the-badge&logo=uniswap" alt="Uniswap v4"></a>
    <a href="https://github.com/imbue-bit/no_JIT/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/imbue-bit/no_JIT/ci.yml?branch=main&style=for-the-badge&logo=githubactions&logoColor=white" alt="CI Status"></a>
  </p>
</div>

---

**`no_JIT`** is not just another MEV mitigation tool; it's an academically-grounded defense mechanism that transforms passive Liquidity Providers into strategic, active defenders. By implementing the Nash Equilibrium strategy derived from our **Hamilton-Jacobi-Isaacs (HJI) framework**, this Uniswap v4 Hook makes JIT attacks economically non-viable, ex-ante.

> **Read the full academic paper:** [*Defense in Predatory Markets: A Differential Game Framework...*](https://link-to-your-paper.pdf)

## 🚀 Key Innovations

| Feature                     | Description                                                                                             |
| --------------------------- | ------------------------------------------------------------------------------------------------------- |
| **🧠 Game-Theoretic Core**   | Moves beyond simple heuristics to a provably optimal defense strategy derived from differential games.  |
| **⚡️ Atomic Deterrence**    | Detects and punishes JIT liquidity within a single block, before the predatory swap executes.           |
| **🔒 Oracle-Free Design**   | Operates entirely on-chain using pool state variables, eliminating external data dependencies and risks.|
| **⛽️ Gas-Efficient Logic**  | Minimal overhead on swaps, ensuring it doesn't compromise the core user experience of the DEX.          |

## 📖 Dive Deeper

Ready to explore? We've structured our documentation to guide you from high-level concepts to deep technical implementation.

| Document                                          | Audience                    | Description                                         |
| ------------------------------------------------- | --------------------------- | --------------------------------------------------- |
| **[📚 A Gentle Introduction](./docs/a_gentle_introduction.md)** | Everyone                    | Understand JIT attacks and our core idea.           |
| **[🛠️ Technical Deep Dive](./docs/technical_deep_dive.md)** | Developers & Researchers  | Explore the math, code, and design decisions.     |
| **[🌍 Deployment Guide](./docs/deployment_guide.md)**       | Protocol Integrators        | Learn how to deploy and configure the hook.         |
| **[🛡️ Security](./docs/security.md)**                       | Security Auditors           | Review our security considerations and best practices.|

## ⚡ Quick Start

### Prerequisites
- [Foundry](https://book.getfoundry.sh/)
- [Git](https://git-scm.com/)

### Installation & Testing

```bash
# Clone the repository
git clone https://github.com/imbue-bit/no_JIT.git
cd no_JIT

# Install dependencies
forge install

# Run the test suite
forge test
```

## 🤝 Contributing

We welcome contributions from the community! Whether it's a bug report, a feature request, or a pull request, your input is valuable. Please check out our [**Contribution Guidelines**](./CONTRIBUTING.md) to get started.

## 📄 License

This project is licensed under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for details.
