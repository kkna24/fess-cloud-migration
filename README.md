# FESS Cloud Migration — Capstone Project

**Fusion Enterprise Security Service (FESS)** migrated from on-premises servers to a **serverless three-tier architecture on AWS**.

> **Role:** Data Migration Specialist  
> **College:** Seneca Polytechnic  
> **Year:** 2024

---

## What This Project Does

A fictional company (Cloud Fusion Solutions) needed to move their legacy security event application off their own servers and into the cloud. This repo contains the **data migration layer** — the scripts and schema used to move:

- **MongoDB** (application logs) → **Amazon DynamoDB**
- **MSSQL** (user/event database) → **Amazon RDS (SQL Server)**

---

## Architecture

```
[Users]
   │
[CloudFront + S3]          ← Static frontend
   │
[Lambda + API Gateway]     ← Business logic (serverless)
   │
[DynamoDB]  [RDS]          ← Data tier
```

See [`docs/architecture.md`](docs/architecture.md) for a full breakdown.

---

## Repo Structure

```
├── scripts/
│   ├── mongodb_to_dynamodb.py   # Python: imports MongoDB JSON export into DynamoDB
│   ├── setup_dynamodb_table.sh  # Shell: creates the DynamoDB Logs table
│   └── mssql_to_rds.sh          # Shell: imports SQL schema into Amazon RDS
├── schema/
│   └── critical_event_db.sql    # SQL Server schema (Users, Events, Roles, etc.)
├── sample-data/
│   └── LogsDatabase.Logs.json   # Sample MongoDB log records
└── docs/
    └── architecture.md          # Architecture diagram and migration approach
```

---

## Prerequisites

- AWS account (Free Tier is sufficient for testing)
- AWS CLI installed and configured (`aws configure`)
- Python 3.8+
- `boto3` library (`pip install boto3`)
- `sqlcmd` (for MSSQL migration, Linux/EC2 only)

---

## How to Run

### 1. MongoDB → DynamoDB

**Create the table first:**
```bash
bash scripts/setup_dynamodb_table.sh
```

**Import the data:**
```bash
pip install boto3
python scripts/mongodb_to_dynamodb.py --file sample-data/LogsDatabase.Logs.json --table Logs
```

### 2. MSSQL → Amazon RDS

Edit the credentials at the top of `scripts/mssql_to_rds.sh`, then run:
```bash
bash scripts/mssql_to_rds.sh
```

This installs `sqlcmd`, tests the connection, imports the schema, and verifies the tables.

---

## AWS Services Used

| Service            | Purpose                          |
|--------------------|----------------------------------|
| Amazon DynamoDB    | NoSQL log storage                |
| Amazon RDS         | Relational DB (SQL Server)       |
| Amazon Cognito     | User authentication              |
| Amazon SNS         | Notifications / alerting         |
| AWS Lambda         | Serverless application logic     |
| Amazon S3          | Static file hosting              |
| Amazon CloudFront  | CDN / edge delivery              |

---

## Key Decisions

- **Why not AWS DMS?** AWS Database Migration Service was evaluated but not used due to IAM policy restrictions in the lab environment. Manual export/import was used with custom scripts instead.
- **Why DynamoDB for logs?** Logs are append-heavy and schema-less — DynamoDB's flexible document model and auto-scaling fit this use case better than a relational store.
- **Why RDS for the app DB?** The application data (Users, Events, Roles) has relational structure and foreign keys — RDS keeps that intact.

---

## What I Learned

- Hands-on experience with AWS data services (DynamoDB, RDS, IAM, CLI)
- Writing resilient Python migration scripts with proper error handling
- Working around policy/permission constraints with alternative approaches
- Database schema design (ASP.NET Identity tables + custom Events schema)
- Cloud architecture trade-offs: serverless vs. managed services
