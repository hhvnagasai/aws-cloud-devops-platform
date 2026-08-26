# RDS MySQL Module

## Purpose

Creates an Amazon RDS MySQL database instance for the application.

The module is designed to be reusable across environments such as `dev` and `prod`.

## Resources

This module creates:

- RDS DB subnet group
- RDS MySQL DB instance

The module does not create:

- VPC
- Subnets
- Security groups
- KMS keys
- IAM roles
- Secrets Manager secrets

These resources are managed by their respective modules.

## Network Design

The RDS instance is deployed into existing private subnets.

Public access is disabled.

Database access is controlled through security groups.

Expected application flow:

ECS Fargate → RDS MySQL

The database port is `3306`.

## Security

RDS storage encryption is enabled using the existing customer-managed KMS key.

The database is not publicly accessible.

The RDS master password is managed by AWS through Secrets Manager.

## Database

Current application requirement:

- Engine: MySQL
- Database: `crm`
- Port: `3306`

## Environment Design

The module does not contain environment-specific values.

Environment configurations provide values such as:

- Instance class
- Storage size
- Backup retention
- Deletion protection
- Subnet IDs
- Security group IDs
- KMS key ARN

This allows the same module to be reused for different environments.

## Outputs

The module exposes:

- RDS instance ID
- RDS instance ARN
- RDS endpoint
- RDS port
- Database name
- Master user secret ARN
