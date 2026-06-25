#!/bin/bash
# 1. Verify VPC created
aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=enterprise-platform" \
  --query 'Vpcs[*].{ID:VpcId,CIDR:CidrBlock,State:State}' \
  --output table

# 2. Verify all 6 subnets created (3 public + 3 private)
aws ec2 describe-subnets \
  --filters "Name=tag:Project,Values=enterprise-platform" \
  --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock,AZ:AvailabilityZone,Type:Tags[?Key==`Type`]|[0].Value}' \
  --output table

# 3. Verify Internet Gateway
aws ec2 describe-internet-gateways \
  --filters "Name=tag:Project,Values=enterprise-platform" \
  --query 'InternetGateways[*].{ID:InternetGatewayId,State:Attachments[0].State}' \
  --output table

# 4. Verify NAT Gateway
aws ec2 describe-nat-gateways \
  --filter "Name=tag:Project,Values=enterprise-platform" \
  --query 'NatGateways[*].{ID:NatGatewayId,State:State,IP:NatGatewayAddresses[0].PublicIp}' \
  --output table

# 5. Verify Route Tables
aws ec2 describe-route-tables \
  --filters "Name=tag:Project,Values=enterprise-platform" \
  --query 'RouteTables[*].{ID:RouteTableId,Name:Tags[?Key==`Name`]|[0].Value}' \
  --output table
