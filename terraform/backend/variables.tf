variable "aws_region" {
  description = "AWS region where backend resources are created"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID, used to make S3 bucket name globally unique"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used as prefix for all resources"
  type        = string
  default     = "Gk-enterprise-platform"
}
variable "environment" {
  description = "Environment name, used for tagging resources"
  type        = string
  default     = "dev"
}

