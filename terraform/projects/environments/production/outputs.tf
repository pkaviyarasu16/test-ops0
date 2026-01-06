# Project Outputs

output "project_summary" {
  description = "Summary of the project infrastructure"
  value = {
    total_resources = 19
    resource_types = ["aws::athena::workgroup", "aws::ec2::internet-gateway", "aws::ec2::route-table", "aws::ec2::security-group", "aws::ec2::subnet", "aws::ec2::vpc", "aws::events::event-bus", "aws::logs::log-group"]
  }
}

