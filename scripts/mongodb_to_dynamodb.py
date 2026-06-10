"""
MongoDB to DynamoDB Migration Script
-------------------------------------
Reads a JSON export from MongoDB and imports it into an AWS DynamoDB table.

Usage:
    python mongodb_to_dynamodb.py --file data.json --table Logs [--region us-east-1]

Requirements:
    pip install boto3
"""

import json
import boto3
import argparse
import sys
from botocore.exceptions import ClientError, NoCredentialsError


def parse_args():
    parser = argparse.ArgumentParser(description="Import MongoDB JSON export to DynamoDB")
    parser.add_argument("--file",   required=True, help="Path to the MongoDB JSON export file")
    parser.add_argument("--table",  required=True, help="DynamoDB table name")
    parser.add_argument("--region", default="us-east-1", help="AWS region (default: us-east-1)")
    return parser.parse_args()


def load_json(filepath):
    """Load and return JSON data from file."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            data = json.load(f)
        if not isinstance(data, list):
            print("ERROR: JSON file must contain an array of documents.")
            sys.exit(1)
        return data
    except FileNotFoundError:
        print(f"ERROR: File not found: {filepath}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON — {e}")
        sys.exit(1)


def get_table(table_name, region):
    """Return a DynamoDB Table resource, or exit if not reachable."""
    try:
        dynamodb = boto3.resource("dynamodb", region_name=region)
        table = dynamodb.Table(table_name)
        # Trigger a describe call to verify the table exists
        table.load()
        return table
    except NoCredentialsError:
        print("ERROR: AWS credentials not found. Run `aws configure` first.")
        sys.exit(1)
    except ClientError as e:
        print(f"ERROR: Could not connect to table '{table_name}': {e.response['Error']['Message']}")
        sys.exit(1)


def import_records(table, records):
    """Batch-write records into DynamoDB with basic error reporting."""
    success = 0
    failed = 0

    with table.batch_writer() as batch:
        for i, record in enumerate(records):
            try:
                batch.put_item(Item=record)
                success += 1
            except ClientError as e:
                print(f"  [SKIP] Record {i} failed: {e.response['Error']['Message']}")
                failed += 1

    return success, failed


def main():
    args = parse_args()

    print(f"Loading data from: {args.file}")
    records = load_json(args.file)
    print(f"  {len(records)} records found.")

    print(f"Connecting to DynamoDB table '{args.table}' in {args.region}...")
    table = get_table(args.table, args.region)

    print("Importing records...")
    success, failed = import_records(table, records)

    print(f"\nDone. {success} imported, {failed} failed.")


if __name__ == "__main__":
    main()
