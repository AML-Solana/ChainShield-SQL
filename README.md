# ChainShield SQL: On-Chain Transaction Monitoring Engine 🛡️

A production-grade transaction monitoring system built in Trino SQL on Dune Analytics. This engine executes real-time behavioral analysis on live high-velocity ERC-20 transfers (USDT) to detect, isolate, and risk-score complex money laundering typologies based on Financial Action Task Force (FATF) guidelines.

---

## 📊 The Core Risk Architecture

Instead of flagging isolated incidents, the engine aggregates behavioral data across multiple parameters to assign a composite **Wallet Risk Score (0 - 100)**. This allows compliance teams to triage alerts efficiently and ignore protocol noise.

### 🧮 Multi-Factor Risk Matrix Weights

| Behavioral Risk Factor | Logic Condition | Risk Contribution |
| :--- | :--- | :--- |
| **Peeling Pattern Match** | Wallet matches strict 5-minute chronologically linked `LEAD` hop logic | **40 Points** |
| **High Volume Threshold** | Individual transfer amount exceeds $500,000 USDT | **30 Points** |
| **High Frequency Velocity** | Account executes $\ge$ 3 distinct suspicious transfers within the sliding window | **20 Points** |
| **Round Number Matching** | Transaction is an exact integer multiple of 1,000 (Indicative of automated scripts) | **10 Points** |

---

## 🛠️ Deep Technical Mechanics

* **Chronological Asset Tracing:** The engine utilizes downstream `LEAD()` window functions partitioned by the receiving wallet address to track fund retention, catching instances where an intermediate account receives a payload and forwards 90% to 100% of the volume to a subsequent destination within 300 seconds.
* **Rolling Velocity Windows:** Leverages analytical sliding frames (`RANGE BETWEEN`) to track cumulative outbounds per user over a shifting 60-minute window, alerting on rapid asset fragmentation.
* **Anti-False Positive Infrastructure:** Features an automated filtering layer that performs a `LEFT JOIN` against `labels.addresses` combined with strict regular expression filters to explicitly whitelist institutional primitives (e.g., Uniswap routers, Aave nodes, Morpho Blue vaults) that naturally present high programmatic turnover.

---

## 🔬 Live Forensic Triage Findings

During deployment on live Ethereum ledger data, the engine successfully bypassed automated protocol noise and exposed distinct high-value targets operating on-chain:

```text
wallet_address                              events  max_value       score   risk_tier
0xce613e00bbc2b6fa5a5aa35e928a7ec584f527d9  1       $2,497,804.16   70      🔴 CRITICAL RISK
0x6f9e2a9514d13505f664ef58f04a184bec071cd6  1       $2,497,804.16   70      🔴 CRITICAL RISK
0x0b2fdf416cf2951499de9a1adac65c8e9907c8c2  1       $799,292.55     70      🔴 CRITICAL RISK
0x2b1bad05d588185da65947a207288b365e3b558a  2       $547,426.52     70      🔴 CRITICAL RISK
