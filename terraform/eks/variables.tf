# ============================================================
# terraform/eks/variables.tf
# ============================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "enterprise-platform"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "enterprise-platform-dev"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.36"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

# ── Hardcoded IDs from Module 1 ────────────────────────────
variable "vpc_id" {
  description = "VPC ID from Module 1"
  type        = string
  default     = "vpc-0ea7792daaed660b0"
  # Exact VPC created by networking module
  # Hardcoded to avoid ambiguity with 8 VPCs
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from Module 1"
  type        = list(string)
  default = [
    "subnet-09a355b495ba56e3a",
    "subnet-061f0dcb70d8668d9",
    "subnet-065f76a23619a4d5d"
  ]
  # EKS nodes placed here
}

variable "public_subnet_ids" {
  description = "Public subnet IDs from Module 1"
  type        = list(string)
  default = [
    "subnet-0e0637ddd4f74cca4",
    "subnet-0fd21e2e1be7abb8b",
    "subnet-0cbbc43c4a451e53e"
  ]
  # Load balancers placed here
}

