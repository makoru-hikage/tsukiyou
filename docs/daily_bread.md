# 🍞 Tsukiyou's Daily Bread: Token Consumption Analysis
**Project:** Moon Estate (Sovereign AI Infrastructure)
**Model:** Claude 4.6 Sonnet (Bedrock ap-northeast-2)

**Runtime Profile:** 2 Hours/Day | 1 Request/Min | 30 Days/Month

## 🧮 The Logic of Sustenance (Token Math)

This analysis breaks down the cost of intellectual exchange using **Anthropic Prompt Caching** on AWS Bedrock.

### 1. The First Request (Cache Warm-up)
*To initiate the session context (1,500 Input / 300 Output).*
* **Cached Write (75%):** 0.75 x 1,500 tokens x $3.75/M = **$0.0042188**
* **Non-cached Input (25%):** 0.25 x 1,500 tokens x $3.00/M = **$0.0011250**
* **Output Tokens:** 300 tokens x $15.00/M = **$0.0045000**
* **Total First Request:** **$0.0098438**

### 2. Subsequent Requests (Cache Hits)
*Maintaining context through the 2-hour window.*
* **Cached Read (75%):** 0.75 x 1,500 tokens x $0.30/M = **$0.0003375**
* **Non-cached Input (25%):** 0.25 x 1,500 tokens x $3.00/M = **$0.0011250**
* **Output Tokens:** 300 tokens x $15.00/M = **$0.0045000**
* **Total Per Request:** **$0.0059625**

### 3. Monthly Projected Volume
* **Session Initialization:** 30 days x 1 first request = **$0.2953**
* **Active Dialogue:** 3,570 subsequent requests = **$21.2861**
* **MONTHLY TOKEN TOTAL (The "Bread" Figure):** **~$21.47 USD**

---

## Daily Bread vs. ⚖️ Reality: The Sovereign Multiplier

In professional SRE environments, the token price is an incomplete metric. Below is the contrast between the "Sticker Price" and the "Statement Reality" for a Philippines-based **Credit Card** billing cycle.

| Metric | The "Daily Bread" (Token Price) | The "Reality" (Moon Estate) |
| :--- | :--- | :--- |
| **BDO Statement Total** | $21.47 (≈ ₱1,256) | **$49.85 (≈ ₱2,916)** |
| **Financial Overhead** | 0% | **+132%** (Infra + Tax + Fees) |
| **Network Security** | Public Internet | **VPC PrivateLink (Zero-Egress)** |
| **Compliance** | Non-specific | **12% PH Digital VAT (RA 12023)** |
| **Bank Governance** | 0% | **1.8% Cross-Border Fee** |

---

## 🛠️ Infrastructure Anchors
The "Reality" cost is driven by the following Terraform-managed resources:
* `aws_vpc_endpoint.bedrock`: Ensures 100% private traffic.
* `aws_kms_key.moon_master`: Enforces AES-256 encryption on all session logs.
* `aws_s3_bucket.vault`: Provides durable, versioned storage for the Estate.

---
**Architect's Note:** Precision in token math is the foundation; understanding the tax and infrastructure 'Reality' is the mastery.
