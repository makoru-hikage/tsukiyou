# 🌕 Moon Estate: Monthly Financial & Technical Breakdown
**Project Status:** Budget Approved (₱2,916.23 / ₱3,000.00)
**Region:** ap-northeast-2 (Seoul, South Korea)
**Engine:** Claude 4.6 Sonnet (Adaptive Thinking Enabled)

---

## 🏗️ Technical Inventory (Terraform Managed)

| Resource Category | AWS Component | Primary Purpose |
| :--- | :--- | :--- |
| **Identity (IAM)** | `aws_iam_openid_connect_provider` | Secure GitHub Actions handshake |
| **Governance** | `aws_bedrock_model_invocation_logging_configuration` | Audit trail for Sonnet 4.6 |
| **Intelligence** | `anthropic.claude-4-6-sonnet` | SRE/Architect Reasoning Engine |
| **Networking** | `aws_vpc_endpoint` | PrivateLink for zero-internet traffic |
| **Security** | `aws_kms_key` | Moon-Master-Key (AES-256) |
| **Storage** | `aws_s3_bucket` | State Storage (Object Lock & Versioning) |

---

## 📉 Financial Breakdown (BDO Platinum Statement)

| Item | USD Cost | PHP (₱58.50) | \% of Total |
| :--- | :--- | :--- | :--- |
| **AWS Infrastructure (Base)** | **$43.72** | **₱2,557.62** | 87.7% |
| **PH Digital VAT (12%)** | $5.25 | ₱307.13 | 10.5% |
| **Foreign Fee (1.8%)** | $0.88 | ₱51.48 | 1.8% |
| **FINAL MONTHLY IMPACT** | **$49.85** | **₱2,916.23** | **100%** |

---

## 🛡️ Governance Snippet: Logging Configuration
*This resource ensures all Sonnet 4.6 interactions are saved to your S3 vault.*

```hcl
resource "aws_bedrock_model_invocation_logging_configuration" "moon_estate_governor" {
  logging_config {
    text_data_delivery_s3_config {
      bucket_name = "moon-estate-bedrock-logs-seoul"
      key_prefix  = "sonnet-4-6-audit/"
      sse_kms_key_id = aws_kms_key.moon_master.arn
    }
  }
}
```
