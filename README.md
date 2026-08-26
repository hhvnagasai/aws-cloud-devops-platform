# AWS Cloud DevOps Platform

A production-oriented AWS Cloud DevOps platform designed to demonstrate the design, provisioning, deployment, security, observability, and continuous delivery of a containerized microservices application using Infrastructure as Code and modern cloud-native practices.

The project follows an industry-oriented approach with emphasis on:

- Security
- High availability
- Infrastructure as Code
- CI/CD automation
- Cost optimization
- Scalability
- Observability
- Maintainability
- Environment isolation
- Reproducible deployments

---

## Project Overview

This project implements an end-to-end DevOps platform on AWS for deploying and operating a microservices-based application.

The platform is built around AWS infrastructure provisioned using Terraform, containerized microservices, CI/CD tooling, centralized security controls, managed databases, container registries, monitoring, and a Kubernetes-based deployment architecture.

The implementation is being developed incrementally, with infrastructure and application modules validated independently before moving to the next stage.

---

## Core Architecture

The overall platform is designed around the following architecture:

```text
                         GitHub
                           |
                           |
                    Source Repository
                           |
                           v
                       Jenkins
                           |
                    CI/CD Pipeline
                           |
              +------------+------------+
              |                         |
              v                         v
             ECR                    Infrastructure
              |                    Terraform / AWS
              |                         |
              v                         v
      Container Images             AWS Platform
              |                         |
              |              +----------+----------+
              |              |                     |
              v              v                     v
        ECS / EKS       Networking            Security
              |              |                     |
              |              |                     |
              |          VPC / Subnets       IAM / KMS
              |          NAT / ALB            SG / Secrets
              |          Endpoints
              |
              v
       Microservices
              |
      +-------+--------+
      |                |
      v                v
    RDS             AWS Services
      |
      v
   MySQL
