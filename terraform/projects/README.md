# ops0-dev

Terraform project that adopts existing AWS infrastructure into managed state via Terraform 1.5+ import blocks.

## What this provisions

This project does not create new infrastructure — it imports resources that already exist in the connected AWS account (`us-east-2`) so they can be managed as code going forward. The initial import covers one EC2 instance discovered during a cloud scan.

## Architecture

mermaid
architecture-beta
    group aws(logos:aws)["AWS us-east-2"]
    group vpc(logos:aws)["VPC vpc-0acd0d092982fa7dd"] in aws
    group az(logos:aws)["AZ us-east-2a"] in vpc

    service ec2(logos:aws-ec2)["ops0-qa t2.medium"] in az


## Modules

- `provider.tf` — AWS provider pinned to `~> 5.0`, region driven by `var.region`.
- `variables.tf` — Input variables including the `ec2_instances` map that keys imported instances by logical name.
- `main.tf` — `aws_instance.this` keyed by `for_each` so future EC2 imports slot in without restructuring.
- `imports.tf` — Terraform 1.5+ `import` blocks that adopt existing AWS resources into state.
- `outputs.tf` — IDs, ARNs, and IPs of managed instances.

## Inputs

| Name | Type | Description | Default | Required? |
|---|---|---|---|---|
| `region` | `string` | AWS region where the imported resources live | `us-east-2` | No |
| `conversation_id` | `string` | ops0 conversation ID | — | Yes |
| `ec2_instances` | `map(object)` | EC2 instances to manage, keyed by logical name | 1 entry (`ops0_qa`) | No |

## Outputs

| Name | Description | Sensitive? |
|---|---|---|
| `instance_ids` | Map of logical name to EC2 instance ID | No |
| `instance_arns` | Map of logical name to EC2 instance ARN | No |
| `instance_private_ips` | Map of logical name to private IP | No |
| `instance_public_ips` | Map of logical name to public IP | No |

## Recommended items

- No ops0 recommendations applied yet — will surface after the first deployment / scan.

## Status summary

- **Compliance** → No policies attached yet. See [EVIDENCE.md](./EVIDENCE.md).
- **Vulnerabilities** → No scan yet. See [VULNERABILITIES.md](./VULNERABILITIES.md).
- **Cost** → No estimate yet. See [FINOPS.md](./FINOPS.md).
- **Drift** → No drift check yet. See [DRIFT.md](./DRIFT.md).

## Deploy

In ops0: push these files to the connected GitHub repo, then click **Deploy**. The `import` blocks run during `terraform apply` and bring existing AWS resources under management without recreating them.

## Operate

- The `aws_instance.this` resource uses `lifecycle.ignore_changes` for AMI, user_data, block devices, and network interfaces so the initial import does not force replacement. Tighten this once the imported state has been reconciled.
- Add new EC2 instances by extending the `ec2_instances` map in `terraform.tfvars` and adding a matching `import` block in `imports.tf`.

## Troubleshooting

- **Import fails with tag mismatch** — the resource in AWS has tags not reflected here. Update `ec2_instances[<key>].tags` to match exactly, then re-run.
- **Plan shows replacement after import** — an attribute the config doesn't set differs from AWS. Add the attribute to `ignore_changes` or set it explicitly in `main.tf`.
