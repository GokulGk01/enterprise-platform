# 1. Verify S3 bucket exists
aws s3 ls | grep gk-enterprise-platform

# 2. Verify versioning is enabled
aws s3api get-bucket-versioning \
  --bucket gk-enterprise-platform-terraform-state-884390772196

# 3. Verify encryption is enabled
aws s3api get-bucket-encryption \
  --bucket gk-enterprise-platform-terraform-state-884390772196

# 4. Verify DynamoDB table exists
aws dynamodb describe-table \
  --table-name gk-enterprise-platform-terraform-locks-884390772196 \
  --query 'Table.{Name:TableName,Status:TableStatus,BillingMode:BillingModeSummary.BillingMode}'
