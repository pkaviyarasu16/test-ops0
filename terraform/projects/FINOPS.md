# FinOps — AWS Demo S3 Bucket ROIVATION demo

Cost tracking for the S3 bucket and supporting resources provisioned by this project.

## Estimated cost — from the IaC repo

**Total estimated monthly cost:** $1.00/mo USD
**Resources priced:** 5
**Estimate generated:** 2026-06-02T16:52:02.459Z (from `Repo cost estimate (Infracost on current files)`)
**Source:** Infracost run against current `.tf` files

### By resource type

| Resource Type | Monthly Cost | % of total |
| --- | --- | --- |
| secrets (`aws_kms_key`) | $1.00 | 100% |
| storage (`aws_s3_bucket` ×3) | $0.00 | 0% |
| other (`aws_sns_topic`) | $0.00 | 0% |

### Top 10 most expensive resources

| Resource Name | Type | Monthly Cost |
| --- | --- | --- |
| `aws_kms_key.s3` | `aws_kms_key` | $1.00/mo |
| `aws_s3_bucket.logs` | `aws_s3_bucket` | $0.00/mo |
| `aws_s3_bucket.replica` | `aws_s3_bucket` | $0.00/mo |
| `aws_s3_bucket.this["roi-vation-ops0-s3"]` | `aws_s3_bucket` | $0.00/mo |
| `aws_sns_topic.s3_events` | `aws_sns_topic` | $0.00/mo |

### Cost delta vs previous estimate

| | Previous (2026-06-02T16:49:31.931Z) | Current (2026-06-02T16:52:02.459Z) | Delta |
| --- | --- | --- | --- |
| Total monthly cost | $0.00/mo | $1.00/mo | **+$1.00/mo** |
| Resources priced | 1 | 5 | +4 |

The delta is driven by four new resources entering the repo since the previous estimate: a customer-managed KMS key (`aws_kms_key.s3`, +$1.00/mo flat fee), two additional S3 buckets (`logs`, `replica` — $0 baseline), and an SNS topic for bucket event notifications (`s3_events` — $0 baseline). The S3 buckets and SNS topic bill on usage, not provisioning, so their listed $0.00/mo is the floor — actual cost scales with storage volume, requests, and message publishes.

## Deployed cost — what's actually running

No successful deployment yet — this section will populate after the first `apply` finishes. The Estimated section above reflects the cost the repo would incur once deployed.

## Optimization opportunities

The baseline monthly cost is dominated by the single customer-managed KMS key. The S3 buckets and SNS topic have no provisioning fee and will bill on usage. Several open incidents on the bucket are security findings that also have downstream cost implications once usage grows:

- **KMS key cost is fixed at ~$1/mo per key** — if `aws_s3_bucket.logs` and `aws_s3_bucket.replica` end up needing their own CMKs (P3 incidents flag they're not KMS-encrypted today), each additional key adds another ~$1/mo. Consider reusing `aws_kms_key.s3` across all three buckets via key policy rather than provisioning separate keys.
- **Enable a lifecycle configuration** (open incident P3 on `aws_s3_bucket.replica`) — transition infrequently-accessed objects to S3 Standard-IA or Glacier to keep storage costs flat as the bucket grows.
- **Enable access logging** (open incident P2 on `aws_s3_bucket.replica`) — required for cost attribution and detecting anomalous request patterns that inflate the bill.
- **Cross-region replication** (open incident P3 on `aws_s3_bucket.logs`) — be aware that enabling this *increases* cost (replica storage + inter-region data transfer); evaluate against your RPO before turning it on.
- **SNS topic** (`aws_sns_topic.s3_events`) — first 1M publishes/month are free; cost only becomes meaningful at high event volumes.

Once a deployment runs and real usage accrues, this section will be refreshed with concrete savings recommendations from actual billing data.
