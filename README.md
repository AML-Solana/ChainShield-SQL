# Forensic Analysis Amendment: Identity Resolution for Node Cluster 0x0134e4...

## ⚠️ Executive Summary Pivot
**Status Update:** RESOLVED (Legitimate Institutional Flow)

Previous iterations of this report flagged the high-volume transaction activity ($2.5M+ USD blocks) around wallet `0x0134e46b9cc3443387e6d3a4d1098f35a0dcdb7a` as an unidentified high-risk entity or a potential exploit drainage network. 

Following a comprehensive tracking of the **Genesis Link (Funding)** and downstream **Counterparty Analysis**, we have successfully resolved the identities behind this network. This cluster does **NOT** represent malicious activity. Instead, it is the programmatic treasury management and arbitrage infrastructure belonging to **Fasanara Capital** ($4B+ AUM institutional asset manager). 

The malicious elements previously detected (e.g., lookalike `ÚЅDТ` transfers) are confirmed to be external **Address Poisoning Phishing Attacks** targeting this institutional pipeline, rather than a compromise of the ecosystem itself.

---

## 🗺️ Resolved Architecture & Capital Flow

Our deep-dive forensic analysis traced the capital lifecycle through four distinct layers, mapping the institutional corridor:

1. **The Capital Source (Prime Brokerage):**
   * **Wallet:** `0xA3E9C2130da76f1409010414A3a3c9F954e280c9` (**FalconX 1**)
   * **Function:** Acts as the fiat-to-crypto liquidity gateway. It provided the original ETH gas funding to initialize the downstream client execution wallets during standard programmatic withdrawals.

2. **The Execution Gateway:**
   * **Wallet:** `0x0134e46b9cc3443387e6d3a4d1098f35a0dcdb7a`
   * **Function:** Serves as the primary programmatic landing page for incoming broker settlements (moving massive flat blocks of USDT).

3. **The Trading Hub Engine:**
   * **Wallet:** `0x697B116c043DbC389001F6AD46fB3A7f83a45975`
   * **Function:** Operates as the centralized execution environment where stablecoins are deployed and traded into native assets (ETH).

4. **Off-Chain Custody & Treasury Reserve:**
   * **Entities:** **Copper.co Custody** (Nodes 14, 15, 17, 19, 33) & `0x28AC5fe7f2cec0c6D3fB6c9085703F0071377201` (**Fasanara Capital Treasury Wallet**)
   * **Function:** High-volume automated scripts sweep rounded asset blocks (e.g., 2,000 ETH, 4,000 ETH) off-chain into Copper's ClearLoop custody network or push inventory into **Binance Deposit Nodes** for exchange liquidity and algorithmic arbitrage.

---

## 🛡️ Clarification on "Fake Token" Transactions
During the early stage of the investigation, multiple transaction logs revealed the presence of zero-value transfers and counterfeit stablecoins matching the $2.5M real transaction values. 

* **Mechanism:** This has been identified as a standard automated **Address Poisoning / Dusting campaign**. 
* **Intent:** Malicious third-party bots monitored the Fasanara/FalconX block transfers, minted lookalike tokens (`ÚЅDТ`), and broadcasted matching spoofed amounts to populate the wallet's history. The goal was to deceive human operators into copy-pasting an attacker's lookalike address during manual script intervention.
* **Finding:** The internal security of the Fasanara Capital programmatic loop remained completely uncompromised. Malicious transactions should be filtered using an `Amount > 0` and strict contract address validation parameter.

## 🏁 Conclusion & Classification Change
* **Old Classification:** High-Risk / Suspicious Whales / Exploit Mapping Needed.
* **New Classification:** Verified Institutional Architecture (Fasanara Capital / FalconX / Copper.co).

No further tracking of the remaining sub-nodes is required for threat mitigation. Case closed as a verified entity.


---------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🕒 Archived Initial Phase Analysis

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

---

### 🔬 Case Study: Automated Routing Nexus (0x6f9e2a)

The table below documents a 4-day structural window capturing rapid multi-million dollar pass-through transactions and programmatic micro-pings.

| Block Time (UTC) | Sender Address | Receiver Address | Amount (USDT) | Transaction Hash |
| :--- | :--- | :--- | :--- | :--- |
| 2026-07-06 03:52:11 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012988 | `0xb8b2182d...7dea` |
| 2026-07-06 03:52:11 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 95,049.0947 | `0x3ca46440...b5d3` |
| 2026-07-06 03:49:47 | `0x0134e85e...cdb7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xb4f0c7e5...80e2` |
| 2026-07-06 03:49:35 | `0x0134e46b...cdb7a` | `0x6f9e2a95...1cd6` | 95,049.0936 | `0x9f6c1bcb...f720` |
| 2026-07-05 14:18:23 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xfd04e695...eb89` |
| 2026-07-05 14:17:35 | `0xce617616...27d9` | `0x6f9e2a95...1cd6` | 0.00024978 | `0x5e20c070...d940` |
| 2026-07-05 14:16:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xdbe3a9bc...6594` |
| 2026-07-05 14:16:23 | `0x6f9e2a95...1cd6` | `0xce617616...27d9` | *Gas Flush* | `0xecfe62b4...b422` |
| 2026-07-05 14:14:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x550fd1ac...b352` |
| 2026-07-05 14:14:23 | `0x6f9e2a95...1cd6` | `0xce617616...27d9` | *Gas Flush* | `0xd31e88a0...0ba9` |
| 2026-07-05 14:13:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x6304a30d...2ae7` |
| 2026-07-05 14:13:47 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xc53cf185...cf8d` |
| 2026-07-05 14:13:47 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x2cc70398...7e94` |
| 2026-07-05 14:13:47 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xc53cf185...cf8d` |
| 2026-07-05 14:13:11 | `0x6f9e2a95...1cd6` | `0xce613e00...27d9` | 2,497,804.167 | `0xe2b257b9...c901` |
| 2026-07-05 14:13:11 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xab998c68...2449` |
| 2026-07-05 14:13:11 | `0xce617616...27d9` | `0x6f9e2a95...1cd6` | 0.00024978 | `0x78fe357c...9f4b` |
| 2026-07-05 14:12:35 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xc1881dc8...2c26` |
| 2026-07-05 14:12:11 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0x12990af2...8dc2` |
| 2026-07-05 14:11:59 | `0x6f9e2a95...1cd6` | `0xce6143e4...27d9` | *Gas Flush* | `0x4550d3ca...9dc0` |
| 2026-07-05 14:11:59 | `0x6f9e2a95...1cd6` | `0xce6873a7...27d9` | *Gas Flush* | `0x61a9c699...3652` |
| 2026-07-05 14:11:47 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012989 | `0xe8c5a0c0...8fd2` |
| 2026-07-05 14:11:35 | `0x6f9e2a95...1cd6` | `0xce613e00...27d9` | 2,497,804.167 | `0x81649077...0b76` |
| 2026-07-05 14:09:47 | `0x01387ae5...1b7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xaa144d8c...4800` |
| 2026-07-05 14:09:23 | `0x0134ab5f...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0x65e28bfc...2ab9` |
| 2026-07-05 14:09:23 | `0x0134e85e...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0x65e28bfc...2ab9` |
| 2026-07-05 14:08:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 249,780.4167 | `0x4272ce9b...2cac` |
| 2026-07-05 14:08:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 249,780.4167 | `0xe610910d...9177` |
| 2026-07-03 17:49:35 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012988 | `0x53c5acc4...8152` |
| 2026-07-03 10:36:35 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 97,812.1906 | `0xce7b7f78...45ea` |
| 2026-07-03 10:35:23 | `0x0134e85e...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xfb87f141...bdb0` |
| 2026-07-03 10:33:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 97,812.1906 | `0x65d4e943...afe3` |
| 2026-07-03 02:23:35 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00010000 | `0xe5c6d0fd...2a37` |
| 2026-07-03 02:22:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019896 | `0xc8ce2a18...f29c` |
| 2026-07-02 23:05:23 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012998 | `0x97de0efa...d7e6` |
| 2026-07-02 19:10:35 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00009999 | `0xa96353a5...d033` |
| 2026-07-02 19:09:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019897 | `0xbf65f09b...d25d` |
| 2026-07-02 18:40:59 | `0x45f3b106...2fd5` | `0x6f9e2a95...1cd6` | 0.00009999 | `0x18acc8cc...b332` |
| 2026-07-02 18:39:59 | `0x6f9e2a95...1cd6` | `0x45f3b106...2fd5` | *Gas Flush* | `0x507c0f42...50f6` |
| 2026-07-02 18:39:23 | `0x6f9e2a95...1cd6` | `0x45f3b5fc...2fd5` | 24,965.2297 | `0xa67d6e5c...9cf4` |
| 2026-07-02 18:36:35 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 24,965.2292 | `0x76a4ce48...8b32` |
| 2026-07-02 15:55:23 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00010000 | `0xf9e29d52...4152` |
| 2026-07-02 15:54:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019899 | `0x4260257b...d962` |
| 2026-07-01 21:16:35 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 96,668.0446 | `0xa8327fe5...2612` |
| 2026-07-01 21:14:11 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 96,668.0446 | `0xfd618b4d...2a72` |
| 2026-07-01 11:17:35 | `0x6f9e2a95...1cd6` | `0x7c678247...d327` | 93,771.5587 | `0x323dde9e...cd33` |
| 2026-07-01 11:14:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 93,771.5586 | `0x3fcf1698...ee32` |
| 2026-07-01 08:26:35 | `0x6f9e2a95...1cd6` | `0x7c6f4ea2...d327` | *Residual Base* | `0xcaa343e4...a84e` |

---

### 🔬 Case Study: Automated Routing Nexus (0x6f9e2a)

The table below documents a 4-day structural window capturing rapid multi-million dollar pass-through transactions and programmatic micro-pings.

| Block Time (UTC) | Sender Address | Receiver Address | Amount (USDT) | Transaction Hash |
| :--- | :--- | :--- | :--- | :--- |
| 2026-07-06 03:52:11 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012988 | `0xb8b2182d...7dea` |
| 2026-07-06 03:52:11 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 95,049.0947 | `0x3ca46440...b5d3` |
| 2026-07-06 03:49:47 | `0x0134e85e...cdb7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xb4f0c7e5...80e2` |
| 2026-07-06 03:49:35 | `0x0134e46b...cdb7a` | `0x6f9e2a95...1cd6` | 95,049.0936 | `0x9f6c1bcb...f720` |
| 2026-07-05 14:18:23 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xfd04e695...eb89` |
| 2026-07-05 14:17:35 | `0xce617616...27d9` | `0x6f9e2a95...1cd6` | 0.00024978 | `0x5e20c070...d940` |
| 2026-07-05 14:16:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xdbe3a9bc...6594` |
| 2026-07-05 14:16:23 | `0x6f9e2a95...1cd6` | `0xce617616...27d9` | *Gas Flush* | `0xecfe62b4...b422` |
| 2026-07-05 14:14:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x550fd1ac...b352` |
| 2026-07-05 14:14:23 | `0x6f9e2a95...1cd6` | `0xce617616...27d9` | *Gas Flush* | `0xd31e88a0...0ba9` |
| 2026-07-05 14:13:59 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x6304a30d...2ae7` |
| 2026-07-05 14:13:47 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xc53cf185...cf8d` |
| 2026-07-05 14:13:47 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0x2cc70398...7e94` |
| 2026-07-05 14:13:47 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0xc53cf185...cf8d` |
| 2026-07-05 14:13:11 | `0x6f9e2a95...1cd6` | `0xce613e00...27d9` | 2,497,804.167 | `0xe2b257b9...c901` |
| 2026-07-05 14:13:11 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xab998c68...2449` |
| 2026-07-05 14:13:11 | `0xce617616...27d9` | `0x6f9e2a95...1cd6` | 0.00024978 | `0x78fe357c...9f4b` |
| 2026-07-05 14:12:35 | `0x6f9e2a95...1cd6` | `0xce61665a...27d9` | *Gas Flush* | `0xc1881dc8...2c26` |
| 2026-07-05 14:12:11 | `0xce61665a...27d9` | `0x6f9e2a95...1cd6` | 0.00009991 | `0x12990af2...8dc2` |
| 2026-07-05 14:11:59 | `0x6f9e2a95...1cd6` | `0xce6143e4...27d9` | *Gas Flush* | `0x4550d3ca...9dc0` |
| 2026-07-05 14:11:59 | `0x6f9e2a95...1cd6` | `0xce6873a7...27d9` | *Gas Flush* | `0x61a9c699...3652` |
| 2026-07-05 14:11:47 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012989 | `0xe8c5a0c0...8fd2` |
| 2026-07-05 14:11:35 | `0x6f9e2a95...1cd6` | `0xce613e00...27d9` | 2,497,804.167 | `0x81649077...0b76` |
| 2026-07-05 14:09:47 | `0x01387ae5...1b7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xaa144d8c...4800` |
| 2026-07-05 14:09:23 | `0x0134ab5f...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0x65e28bfc...2ab9` |
| 2026-07-05 14:09:23 | `0x0134e85e...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0x65e28bfc...2ab9` |
| 2026-07-05 14:08:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 249,780.4167 | `0x4272ce9b...2cac` |
| 2026-07-05 14:08:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 249,780.4167 | `0xe610910d...9177` |
| 2026-07-03 17:49:35 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012988 | `0x53c5acc4...8152` |
| 2026-07-03 10:36:35 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 97,812.1906 | `0xce7b7f78...45ea` |
| 2026-07-03 10:35:23 | `0x0134e85e...db7a` | `0x6f9e2a95...1cd6` | *Gas Ping* | `0xfb87f141...bdb0` |
| 2026-07-03 10:33:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 97,812.1906 | `0x65d4e943...afe3` |
| 2026-07-03 02:23:35 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00010000 | `0xe5c6d0fd...2a37` |
| 2026-07-03 02:22:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019896 | `0xc8ce2a18...f29c` |
| 2026-07-02 23:05:23 | `0x0134eef2...4db7a` | `0x6f9e2a95...1cd6` | 0.00012998 | `0x97de0efa...d7e6` |
| 2026-07-02 19:10:35 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00009999 | `0xa96353a5...d033` |
| 2026-07-02 19:09:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019897 | `0xbf65f09b...d25d` |
| 2026-07-02 18:40:59 | `0x45f3b106...2fd5` | `0x6f9e2a95...1cd6` | 0.00009999 | `0x18acc8cc...b332` |
| 2026-07-02 18:39:59 | `0x6f9e2a95...1cd6` | `0x45f3b106...2fd5` | *Gas Flush* | `0x507c0f42...50f6` |
| 2026-07-02 18:39:23 | `0x6f9e2a95...1cd6` | `0x45f3b5fc...2fd5` | 24,965.2297 | `0xa67d6e5c...9cf4` |
| 2026-07-02 18:36:35 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 24,965.2292 | `0x76a4ce48...8b32` |
| 2026-07-02 15:55:23 | `0x44bba6f1...b109` | `0x6f9e2a95...1cd6` | 0.00010000 | `0xf9e29d52...4152` |
| 2026-07-02 15:54:47 | `0x44bbb53d...b109` | `0x6f9e2a95...1cd6` | 0.00019899 | `0x4260257b...d962` |
| 2026-07-01 21:16:35 | `0x6f9e2a95...1cd6` | `0x28ac5fe7...7201` | 96,668.0446 | `0xa8327fe5...2612` |
| 2026-07-01 21:14:11 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 96,668.0446 | `0xfd618b4d...2a72` |
| 2026-07-01 11:17:35 | `0x6f9e2a95...1cd6` | `0x7c678247...d327` | 93,771.5587 | `0x323dde9e...cd33` |
| 2026-07-01 11:14:59 | `0x0134e46b...db7a` | `0x6f9e2a95...1cd6` | 93,771.5586 | `0x3fcf1698...ee32` |
| 2026-07-01 08:26:35 | `0x6f9e2a95...1cd6` | `0x7c6f4ea2...d327` | *Residual Base* | `0xcaa343e4...a84e` |
