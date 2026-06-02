# Vulnerabilities — AWS Demo S3 Bucket ROIVATION demo

**Last scan:** 2026-06-02T17:05:44Z (just completed)
**Scanner:** Checkov
**Targets:** `aws_s3_bucket.this["roi-vation-ops0-s3"]`, `aws_s3_bucket.logs`, `aws_s3_bucket.replica`, `aws_kms_key.s3`

## Severity distribution

| Critical | High | Medium | Low | Unknown |
|----------|------|--------|-----|---------|
| 0        | 0    | 1      | 7   | 0       |

Total findings: **8**

## Findings by file

Findings are spread across the log bucket, the replica bucket, and the KMS key. The primary bucket (`aws_s3_bucket.this["roi-vation-ops0-s3"]`) is clean in this scan.

| Check                                            | Severity    | Resource                                       | Description                                                          | Remediation                                                                                                  |
|--------------------------------------------------|-------------|------------------------------------------------|----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| S3 access logging enabled                        | P2 / Medium | `aws_s3_bucket.replica`                        | Replica bucket has no server access logging configured               | Add an `aws_s3_bucket_logging` resource pointing at the dedicated log bucket                                 |
| S3 buckets encrypted with KMS by default         | P3 / Low    | `aws_s3_bucket.logs`                           | Log bucket default encryption is not using a customer-managed KMS key | Add `aws_s3_bucket_server_side_encryption_configuration` with `sse_algorithm = "aws:kms"` and a KMS key ARN  |
| S3 buckets encrypted with KMS by default         | P3 / Low    | `aws_s3_bucket.replica`                        | Replica bucket default encryption is not using a customer-managed KMS key | Add `aws_s3_bucket_server_side_encryption_configuration` with `sse_algorithm = "aws:kms"` and a KMS key ARN  |
| S3 bucket cross-region replication               | P3 / Low    | `aws_s3_bucket.logs`                           | Cross-region replication is not enabled on the log bucket            | Add an `aws_s3_bucket_replication_configuration` resource targeting a bucket in a second region              |
| S3 bucket lifecycle configuration                | P3 / Low    | `aws_s3_bucket.replica`                        | No lifecycle rules defined on the replica bucket                     | Add an `aws_s3_bucket_lifecycle_configuration` resource (transition to IA/Glacier, expire old versions)      |
| S3 bucket event notifications                    | P3 / Low    | `aws_s3_bucket.logs`                           | Event notifications are not enabled on the log bucket                | Add an `aws_s3_bucket_notification` resource wired to SNS / SQS / Lambda                                     |
| S3 bucket event notifications                    | P3 / Low    | `aws_s3_bucket.replica`                        | Event notifications are not enabled on the replica bucket            | Add an `aws_s3_bucket_notification` resource wired to SNS / SQS / Lambda                                     |
| KMS key policy defined                           | P3 / Low    | `aws_kms_key.s3`                               | No explicit key policy is defined on the S3 KMS key                  | Add a `policy` argument with a least-privilege key policy scoping access to the S3 service and key admins    |

## Top remediation actions

1. **Enable access logging on the replica bucket (P2).** Attach an `aws_s3_bucket_logging` resource pointing the replica bucket at the existing log bucket — this is the only Medium-severity finding in the scan.
2. **Switch logs and replica buckets to SSE-KMS (P3).** Replace SSE-S3 with SSE-KMS on `aws_s3_bucket.logs` and `aws_s3_bucket.replica` using `aws_kms_key.s3` so key usage is auditable in CloudTrail.
3. **Define an explicit KMS key policy (P3).** Add a least-privilege `policy` to `aws_kms_key.s3` instead of relying on the default policy — required by most compliance baselines.
4. **Add lifecycle rules to the replica bucket (P3).** Even a basic rule that expires noncurrent versions after 30 days reduces cost and limits blast radius.
5. **Wire event notifications on logs and replica buckets (P3).** Add `aws_s3_bucket_notification` resources to both so downstream tooling can react to writes/deletes consistently across all buckets.

Cross-region replication on the log bucket (P3) can be deferred until the data classification justifies the cost.

## History

| Scan                          | Critical | High | Medium | Low | Total |
|-------------------------------|----------|------|--------|-----|-------|
| Latest (2026-06-02T17:05:44Z) | 0        | 0    | 1      | 7   | 8     |
| Previous (2026-06-02T16:52:02Z) | 0      | 0    | 1      | 7   | 8     |
| Earlier                       | 0        | 1    | 1      | 4   | 6     |

Results are stable vs the previous scan — same 8 findings, same severity mix. The High-severity Public Access Block finding from the earlier scan remains cleared. No new regressions and no new fixes landed between the last two scans.
