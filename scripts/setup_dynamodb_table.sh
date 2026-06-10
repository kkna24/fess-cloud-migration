#!/bin/bash
# -------------------------------------------------------
# Create the DynamoDB Logs table
# Run this ONCE before importing data.
# Requires AWS CLI configured with valid credentials.
# -------------------------------------------------------

TABLE_NAME="Logs"
REGION="${AWS_DEFAULT_REGION:-us-east-1}"

echo "Creating DynamoDB table: $TABLE_NAME in $REGION"

aws dynamodb create-table \
  --table-name "$TABLE_NAME" \
  --attribute-definitions AttributeName=_id,AttributeType=S \
  --key-schema AttributeName=_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION"

echo "Waiting for table to become active..."
aws dynamodb wait table-exists --table-name "$TABLE_NAME" --region "$REGION"
echo "Table '$TABLE_NAME' is ready."
