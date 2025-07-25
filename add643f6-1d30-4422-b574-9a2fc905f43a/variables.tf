variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test-eks-cluster"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for EKS cluster"
  type        = string
  default     = "arn:aws:iam::123456789012:role/eks-cluster-role"
}

variable "node_role_arn" {
  description = "ARN of the IAM role for EKS node group"
  type        = string
  default     = "arn:aws:iam::123456789012:role/eks-node-role"
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "test-node-group"
}

variable "desired_nodes" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}