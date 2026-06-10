# Architecture Overview

## Project: FESS Cloud Migration (Capstone)

### What was migrated

The "Fusion Enterprise Security Service" (FESS) was an on-premises application migrated to a **serverless three-tier architecture on AWS**.

```
On-Premises                    AWS (After Migration)
─────────────────────────────────────────────────────
Web Server          →    Amazon CloudFront + S3
Application Server  →    AWS Lambda / API Gateway
MongoDB (Logs DB)   →    Amazon DynamoDB
MSSQL (App DB)      →    Amazon RDS (SQL Server)
Auth/Users          →    Amazon Cognito
Notifications       →    Amazon SNS
```

### Three-Tier Architecture

```
[User / Browser]
      │
  [Tier 1 – Presentation]
  Amazon CloudFront + S3 (static frontend)
      │
  [Tier 2 – Application]
  AWS Lambda + API Gateway (serverless logic)
      │
  [Tier 3 – Data]
  ┌─────────────────────────────────────────┐
  │  Amazon DynamoDB  │  Amazon RDS         │
  │  (Logs — NoSQL)   │  (App DB — MSSQL)   │
  └─────────────────────────────────────────┘
```

### Data Migration Approach

| Source      | Destination       | Method                        |
|-------------|-------------------|-------------------------------|
| MongoDB     | Amazon DynamoDB   | JSON Export → Python import   |
| MSSQL       | Amazon RDS        | SQL schema + sqlcmd import    |

AWS DMS (Database Migration Service) was evaluated but not used due to policy restrictions — manual export/import was used instead.

### Security & Compliance
- Encryption at rest and in transit (AWS KMS, TLS)
- IAM roles with least-privilege access
- GDPR and HIPAA compliant storage practices
- Amazon Cognito for identity and access management
