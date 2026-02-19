# VibeVault E-commerce Platform Roadmap

Based on the PRD/HLD and current progress.

---

## Table of Contents

1. [Current State](#current-state)
2. [Time Commitment](#time-commitment)
3. [Learning Resources](#learning-resources)
   - [Theory (System Design)](#theory-system-design)
   - [Hands-on (DevOps & Cloud)](#hands-on-devops--cloud)
   - [Recommended AWS Courses (KodeKloud)](#recommended-aws-courses-kodekloud)
4. [Month 1: Foundation (~270 hours)](#month-1-foundation-270-hours)
   - [Week 1: Terraform Fundamentals](#week-1-terraform-fundamentals-68-hours)
   - [Week 2: Terraform AWS + Infrastructure](#week-2-terraform-aws--infrastructure-68-hours)
   - [Week 3: Kubernetes Fundamentals](#week-3-kubernetes-fundamentals-68-hours)
   - [Week 4: Kubernetes Advanced + Local Testing](#week-4-kubernetes-advanced--local-testing-68-hours)
5. [Month 2: Implementation Sprint (~270 hours)](#month-2-implementation-sprint-270-hours)
   - [Week 5: Deploy to EKS + Kong](#week-5-deploy-to-eks--kong-68-hours)
   - [Week 6: CI/CD Pipeline](#week-6-cicd-pipeline-68-hours)
   - [Week 7: Elasticsearch Integration](#week-7-elasticsearch-integration-68-hours)
   - [Week 8: Kafka + Cart Service](#week-8-kafka--cart-service-68-hours)
6. [Post 2-Months: Remaining Work](#post-2-months-remaining-work) *(Month 3-4)*
   - [Week 9-10: Order Service + Saga Pattern](#week-9-10-order-service--saga-pattern-60-hours-estimated) *(Month 3)*
   - [Week 11-12: Payment + Notification + Redis](#week-11-12-payment--notification--redis-60-hours-estimated) *(Month 3)*
   - [Week 13-14: Performance Benchmarking & Optimization](#week-13-14-performance-benchmarking--optimization-70-hours-estimated) *(Month 4)*
7. [Performance Benchmarking by Microservice](#performance-benchmarking-by-microservice) *(Month 4, Week 13-14)*
   - [User Service Benchmarks](#user-service-benchmarks-8-hours)
   - [Product Service Benchmarks](#product-service-benchmarks-10-hours)
   - [Cart Service Benchmarks](#cart-service-benchmarks-8-hours)
   - [Order Service Benchmarks](#order-service-benchmarks-10-hours)
   - [Payment Service Benchmarks](#payment-service-benchmarks-8-hours)
   - [Notification Service Benchmarks](#notification-service-benchmarks-6-hours)
   - [Cross-Cutting Benchmarks](#cross-cutting-benchmarks-12-hours)
8. [Benchmarking Schedule](#benchmarking-schedule)
9. [Benchmark Documentation Template](#benchmark-documentation-template)
10. [Additional Study Materials by Topic](#additional-study-materials-by-topic)
11. [Architecture Overview (Target State)](#architecture-overview-target-state)
12. [Curriculum ↔ Project Mapping](#curriculum--project-mapping)
13. [AWS Services Summary](#aws-services-summary)
14. [2-Month Achievement Summary](#2-month-achievement-summary)
15. [Job Application Timeline](#job-application-timeline) *(Start applying: Month 3)*
    - [When to Start Applying](#when-to-start-applying)
    - [Application Preparation Checklist](#application-preparation-checklist)
    - [Target Roles & Expected CTC](#target-roles--expected-ctc)
    - [Application Strategy Matrix](#application-strategy-matrix)
    - [Company Targets by Tier](#company-targets-by-tier)
    - [Week-by-Week Application Plan](#week-by-week-application-plan)
    - [Interview Tracking Template](#interview-tracking-template)
16. [Optional: DevOps Skills Enhancement](#optional-devops-skills-enhancement-if-time-permits) *(+60 hours)*
    - [Helm Charts](#optional-module-1-helm-charts-6-hours) (6 hrs)
    - [ArgoCD GitOps](#optional-module-2-argocd-gitops-8-hours) (8 hrs)
    - [Ansible Basics](#optional-module-3-ansible-basics-10-hours) (10 hrs)
    - [ELK Stack](#optional-module-4-elk-stack---centralized-logging-8-hours) (8 hrs)
    - [Service Mesh - Istio](#optional-module-5-service-mesh---istio-10-hours) (10 hrs)
    - [Advanced Scripting](#optional-module-6-advanced-scripting-8-hours) (8 hrs)
    - [Linux Administration](#optional-module-7-linux-administration-10-hours) (10 hrs)
17. [SDE 2 Interview Preparation](#sde-2-interview-preparation-80-hours) *(~90 hours)*
    - [Your Profile Positioning](#your-profile-positioning)
    - [DSA Preparation Track](#dsa-preparation-track-40-hours) (40 hrs)
    - [High Level Design Practice](#high-level-design-practice-20-hours) (20 hrs)
    - [Low Level Design Practice](#low-level-design-practice-10-hours) (10 hrs)
    - [Behavioral Preparation](#behavioral-preparation-10-hours) (10 hrs)
    - [Mock Interview Schedule](#mock-interview-schedule-10-hours) (10 hrs)
    - [Resume Positioning](#resume-positioning)
18. [Capstone Project Report (Master's Degree)](#capstone-project-report-masters-degree)
    - [Report Requirements](#report-requirements)
    - [Report Structure & Tasks](#report-structure--tasks)
    - [Report Timeline](#report-timeline)
19. [References](#references)

---

## Current State
- ✅ User Management Service (userservice)
- ✅ Product Catalog Service (productservice)
- ✅ Docker containerization

---

## Time Commitment

**Start Date:** Thursday, February 5, 2026

### Daily Schedule
- **Weekdays (Mon-Fri):** 9 hours/day
- **Weekends (Sat-Sun):** 11-12 hours/day
- **Weekly Total:** ~68 hours

### Timeline Overview
| Phase | Dates | Weeks | Hours |
|-------|-------|-------|-------|
| Month 1: Foundation | Feb 5 - Mar 4, 2026 | Week 1-4 | ~270 hrs |
| Month 2: Implementation | Mar 5 - Apr 1, 2026 | Week 5-8 | ~270 hrs |
| Month 3-4: Remaining Work | Apr 2 onwards | Week 9-14 | ~400 hrs |

### Month 1 (~270 hours)
- Weekdays: 9 hours/day
- Weekends: 11-12 hours/day
- **Focus:** 50% Learning, 50% Implementation

### Month 2 (~270 hours)
- Weekdays: 9 hours/day
- Weekends: 11-12 hours/day
- **Focus:** 20% Learning, 80% Implementation

**Total: ~540 hours over 2 months** (Project-first approach, DSA/LLD deferred)

---

## Learning Resources

### Theory (System Design)
**Scaler HLD Curriculum** - 20 lectures covering:
- System Design fundamentals, Load Balancing, Caching
- CAP theorem, Database replication & sharding
- Kafka, Elasticsearch, Microservices patterns
- Distributed transactions, Saga pattern

**Reference Book:** *"Designing Data-Intensive Applications"* by Martin Kleppmann

**Recommended YouTube Channels:**
- [ByteByteGo - Alex Xu](https://www.youtube.com/@ByteByteGo)
- [Asli Engineering - Arpit Bhayani](https://www.youtube.com/@AsliEngineering)
- [Hussein Nasser](https://www.youtube.com/@hnasr)
- [Martin Kleppmann](https://www.youtube.com/@kleppmann)

**Engineering Blogs:**
- [AWS Architecture Blog](https://aws.amazon.com/blogs/architecture/)
- [Netflix Tech Blog](https://netflixtechblog.com)
- [Meta Engineering](https://engineering.fb.com)

### Hands-on (DevOps & Cloud)
**KodeKloud** - Practical labs for:
- Terraform
- Kubernetes
- Jenkins
- AWS

#### Recommended AWS Courses (KodeKloud)

**Approach: Build-first, course-when-stuck.** Terraform Basics (completed) covered enough AWS fundamentals. Learn AWS services by writing Terraform modules with Claude + official docs. Only take a course if stuck on something for 30+ minutes and Claude + docs aren't cutting it.

| Status | Course | Use As | Est. Hours |
|--------|--------|--------|------------|
| 📖 **ON-DEMAND** | [AWS IAM](https://learn.kodekloud.com/courses/aws-iam) | Skim relevant sections if IAM roles/policies/IRSA become confusing during Terraform work | 4-6 hrs |
| 📖 **ON-DEMAND** | [AWS Workshop with Terraform](https://learn.kodekloud.com/courses/learn-by-doing-aws-workshop-with-terraform) | Reference if stuck on specific AWS+Terraform patterns | 8-10 hrs |
| 📖 **ON-DEMAND** | [AWS RDS](https://learn.kodekloud.com/courses/aws-rds) | Reference if stuck on parameter groups, subnet groups, Multi-AZ | 4-5 hrs |
| 📖 **ON-DEMAND** | [AWS EC2](https://learn.kodekloud.com/courses/amazon-elastic-compute-cloud-ec2) | Reference if stuck on security groups, networking, Jenkins on EC2 | 4-5 hrs |

**Courses to Skip (for this project):**
- ❌ [AWS Solutions Architect Associate](https://learn.kodekloud.com/courses/aws-solutions-architect-associate-certification) - Certification-focused, covers 50+ services. Overkill for your timeline.
- ❌ [AWS Certified Developer Associate](https://learn.kodekloud.com/courses/aws-certified-developer-associate) - Focuses on Lambda, DynamoDB, API Gateway - services you're not using.
- ❌ [AWS for Beginners](https://learn.kodekloud.com/courses/aws-for-beginners-with-hands-on-labs) - Too basic if doing the Terraform workshop.

---

## Month 1: Foundation (~270 hours)
**Feb 5 - Mar 4, 2026**

### Week 1: Terraform Fundamentals (~68 hours)
**Feb 5 - Feb 11, 2026**

| Day | Date | Hours | Task                                                                                           |
|-----|------|-------|------------------------------------------------------------------------------------------------|
| Thu | Feb 5 | 9 | ✅ KodeKloud: Terraform Basics course (intro + HCL + state + providers + modules + AWS section) |
| Fri | Feb 6 | 9 | ✅ KodeKloud: Terraform Basics course (continued)                                               |
| Sat | Feb 7 | 11 | ✅ KodeKloud: Terraform Basics course (completed, including AWS with Terraform section)         |
| Sun | Feb 8 | 12 | ✅ Scaler L1: System Design 101 + Start writing VPC Terraform module (with Claude + AWS docs)   |
| Mon | Feb 9 | 9 | ✅ Scaler L2: Load Balancing & Consistent Hashing + Continue VPC module (subnets, NAT, IGW)     |
| Tue | Feb 10 | 9 | ✅ Complete VPC module + start EKS module basics                                                |
| Wed | Feb 11 | 9 | ✅ Continue EKS module + test locally with `terraform plan`                                      |

> **Note:** AWS courses (IAM, RDS, EC2, Workshop) are kept as on-demand references — skim specific sections only if stuck for 30+ minutes and Claude + docs aren't sufficient. Learn IAM roles/policies by writing them in Terraform and debugging real `AccessDenied` errors.

#### 📚 Scaler HLD - Lecture 1: System Design 101
**Topics Covered:**
- High Level Design (HLD) - what & why
- Case Study - bookmarking website
- DNS, IP Addresses, Domains (how internet works)
- Horizontal vs Vertical Scaling
- Load Balancing - what & why
- Heartbeat & HealthCheck
- Scaling Mindset

**Study Materials:**
- Notes: HLD 1 - System Design 101
- Resources:
  - [DNS Explanation - Cloudflare](https://www.cloudflare.com/learning/dns/what-is-dns/)
  - [Load Balancer Tutorial](https://avinetworks.com/what-is-load-balancing/)
  - [AWS ELB Getting Started](https://aws.amazon.com/elasticloadbalancing/getting-started/)

#### 📚 Scaler HLD - Lecture 2: Load Balancing & Consistent Hashing
**Topics Covered:**
- Load Balancing Techniques
- Horizontal vs Vertical Partitioning
- Sharding
- Routing Algorithms
- Round Robin
- Consistent Hashing
- Stateless Servers

**Study Materials:**
- Notes: HLD 2 - Load Balancing & Consistent Hashing
- Mandatory Reading: [Load Balancer Deep Dive](https://docs.google.com/document/d/1DxQzLpu1XPe_mRWsewNWtKL6E4uwKHQhBp7GX6Sg7qI/)
- Resources:
  - [Hash Functions - Wikipedia](https://en.wikipedia.org/wiki/Hash_function)
  - [Consistent Hashing Explained](https://www.youtube.com/watch?v=UF9Ez834UN4)

**Week 1 Deliverable:** Terraform VPC module + EKS module started

---

### Week 2: Terraform AWS + Infrastructure (~68 hours)
**Feb 12 - Feb 18, 2026**

| Day | Date | Hours | Task                                                                                          |
|-----|------|-------|-----------------------------------------------------------------------------------------------|
| Thu | Feb 12 | 9 | ✅ Complete EKS module + IAM roles for EKS (use Claude + AWS docs)                             |
| Fri | Feb 13 | 9 | ✅ Terraform: RDS module (parameter groups, subnet groups — reference AWS RDS course if stuck) |
| Sat | Feb 14 | 11 | ✅ Terraform: ECR module + Scaler L18: Microservices Architecture                              |
| Sun | Feb 15 | 12 | ✅ Scaler L19: Microservices Communication + Wire all Terraform modules together               |
| Mon | Feb 16 | 9 | ✅ Deploy infrastructure to AWS (`terraform apply`)                                            |
| Tue | Feb 17 | 9 | ✅ Debug deployment issues + verify all resources                                              |
| Wed | Feb 18 | 9 | ✅ Final infrastructure testing + documentation                                                |

> **Note:** Freed ~20 hours from dropped AWS courses. This time is now allocated to deeper hands-on Terraform work and earlier module completion. Reference AWS courses on-demand if specific services become blocking.

#### 📚 Scaler HLD - Lecture 18: Monolith vs Microservices
**Topics Covered:**
- Types of Scale
- Monolithic Architecture - Pros & Cons
- Modular Monolith
- Microservices Architecture - Pros & Cons
- Typical Backend Architecture
- Untrusted vs Trusted Layer
- Service vs Server
- API Gateway & Reverse Proxy
- Load Balancers
- Trusted Virtual Private Cloud (VPC)
- Authentication vs Authorization
- When to use Monolith vs Microservices
- Service Oriented Architecture

**Study Materials:**
- Notes: HLD 18 - Monolith vs Microservices vs SOA
- Resources:
  - [Microservices.io Patterns](https://microservices.io/)
  - [Proxy vs Reverse Proxy](https://www.youtube.com/watch?v=4NB0NDtOwIQ)
  - [API Gateway - ByteByteGo](https://blog.bytebytego.com/p/api-gateway)
  - [Reverse Proxy vs API Gateway vs LB](https://www.youtube.com/watch?v=RqfaTIWc3LQ)

#### 📚 Scaler HLD - Lecture 19: Microservices Communication & Observability
**Topics Covered:**
- Client to Microservices Communication
- API Gateway, GraphQL, Backend for Frontend
- Microservice to Microservice communication
- Synchronous: RESTful APIs, SOAP, gRPC, IPC
- Asynchronous: Message Queues, Event Driven
- Observability: Metrics, Monitoring, Alerts
- Logging & ELK Stack
- Distributed Tracing, Traces & Spans, Correlation ID
- Resilience: Circuit Breaker, Bulkhead, Graceful Degradation
- Chaos Engineering, Sidecar pattern

**Study Materials:**
- Notes: HLD 19 - Microservices Communication & Observability
- Resources:
  - [gRPC vs REST](https://aws.amazon.com/compare/the-difference-between-grpc-and-rest/)
  - [gRPC vs WebSockets](https://ably.com/topic/grpc-vs-websocket)
  - [Observability - AWS](https://docs.aws.amazon.com/whitepapers/latest/microservices-on-aws/observability.html)
  - [Measuring Latency](https://www.youtube.com/watch?v=lJ8ydIuPFeU)

**Week 2 Deliverable:** All Terraform modules (VPC, EKS, RDS, ECR) deployed

---

### Week 3: Kubernetes Fundamentals (~68 hours)
**Feb 19 - Feb 25, 2026**

| Day | Date | Hours | Task                                                                 |
|-----|------|-------|----------------------------------------------------------------------|
| Thu | Feb 19 | 9 | ✅ KodeKloud: K8s Architecture, Pods, Deployments                     |
| Fri | Feb 20 | 9 | ✅ KodeKloud: ReplicaSets, Services, Networking                       |
| Sat | Feb 21 | 11 | KodeKloud: ConfigMaps, Secrets, Volumes                              |
| Sun | Feb 22 | 12 | KodeKloud: Ingress, RBAC, Network Policies                           |
| Mon | Feb 23 | 9 | Write K8s manifests for userservice (Deployment, Service, ConfigMap) |
| Tue | Feb 24 | 9 | Write K8s manifests for productservice + Secrets management          |
| Wed | Feb 25 | 9 | Test both services on Minikube + debug issues                        |

**Week 3 Deliverable:** K8s manifests for both services (Deployment, Service, ConfigMap, Secrets)

---

### Week 4: Kubernetes Advanced + Local Testing (~68 hours)
**Feb 26 - Mar 4, 2026**

| Day | Date | Hours | Task |
|-----|------|-------|------|
| Thu | Feb 26 | 9 | KodeKloud: Helm basics + create Helm charts for services |
| Fri | Feb 27 | 9 | KodeKloud: EKS specifics + aws-load-balancer-controller |
| Sat | Feb 28 | 11 | Test services on Minikube + debug issues |
| Sun | Mar 1 | 12 | Scaler L3: Caching + Scaler L4: Redis case study |
| Mon | Mar 2 | 9 | Advanced debugging + health checks + readiness probes |
| Tue | Mar 3 | 9 | Resource limits, HPA configuration |
| Wed | Mar 4 | 9 | Final Minikube testing + prepare for EKS deployment |

#### 📚 Scaler HLD - Lecture 3: Caching
**Topics Covered:**
- Memory Hierarchy
- In-Browser caches
- Content Delivery Networks (CDN)
- Backend Caching
- Local vs Global Cache
- Single vs Distributed Cache
- Cache Invalidation & Eviction Algorithms
- Write Around / Write Through / Write Back / TTL
- Cache Consistency

**Study Materials:**
- Notes: HLD 3 - Caching
- Resources:
  - [CDN Basics - AWS](https://aws.amazon.com/what-is/cdn/)
  - [CDN - Akamai](https://www.akamai.com/glossary/what-is-a-cdn)
  - [AnyCast Networks](https://www.cloudflare.com/learning/cdn/glossary/anycast-network/)
  - [CDN Cache Invalidation - AWS](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html)

#### 📚 Scaler HLD - Lecture 4: Redis Case Study
**Topics Covered:**
- Designing a Cache
- Caching testcases in Scaler Code Judge
- Global vs Local Cache
- LRU Eviction
- CPU vs I/O bound processes
- Ranklist Computation
- Caching Leaderboard in Scaler Contests
- Redis Overview

**Study Materials:**
- Notes: HLD 4 - Caching Case Studies
- Mandatory Reading: [Redis Eviction Policies & Cluster Mode](https://docs.google.com/document/d/1k4nzubvtX_yLctUT4VWK8ZJt4KCcOEdRJdxQgWCaiU8/)
- Resources:
  - [Redis Online Editor](https://onecompiler.com/redis)
  - [Redis Quick Start](https://redis.io/learn/howtos/quick-start)
  - [Redis University](https://redis.io/university/)
  - [Redis Docs](https://redis.io/docs/latest/)

**Month 1 Milestone:**
```
✅ Terraform modules ready (VPC, EKS, RDS, ECR)
✅ AWS infrastructure deployed
✅ K8s manifests created and tested on Minikube
✅ Strong foundation in Terraform, K8s, System Design
✅ Understanding of caching concepts for later phases
```

---

## Month 2: Implementation Sprint (~270 hours)
**Mar 5 - Apr 1, 2026**

### Week 5: Deploy to EKS + Kong (~68 hours)
**Mar 5 - Mar 11, 2026**

| Day | Date | Hours | Task |
|-----|------|-------|------|
| Thu | Mar 5 | 9 | Deploy userservice to EKS + verify pods running |
| Fri | Mar 6 | 9 | Deploy productservice to EKS + verify pods running |
| Sat | Mar 7 | 11 | Debug networking, service discovery, inter-service communication |
| Sun | Mar 8 | 12 | Install Kong Ingress Controller + configure routes |
| Mon | Mar 9 | 9 | AWS ALB setup + SSL/TLS configuration |
| Tue | Mar 10 | 9 | DNS setup (Route53) + health checks |
| Wed | Mar 11 | 9 | End-to-end testing + capture baseline benchmarks |

**Week 5 Deliverable:** Both services running on EKS with Kong API Gateway

**📊 Benchmark Checkpoint:** Capture baseline API response times for User + Product services (save for Week 13-14 comparison)

---

### Week 6: CI/CD Pipeline (~68 hours)
**Mar 12 - Mar 18, 2026**

| Day | Date | Hours | Task |
|-----|------|-------|------|
| Thu | Mar 12 | 9 | KodeKloud: Jenkins fundamentals + Jenkins setup on EC2 |
| Fri | Mar 13 | 9 | Jenkins: Create pipeline for productservice (build + test) |
| Sat | Mar 14 | 11 | Jenkins: SonarQube integration + code quality gates |
| Sun | Mar 15 | 12 | Jenkins: ECR push + EKS deploy stages |
| Mon | Mar 16 | 9 | Pipeline for userservice + shared pipeline libraries |
| Tue | Mar 17 | 9 | Test full CI/CD flow + webhook triggers |
| Wed | Mar 18 | 9 | Pipeline optimization + measure build/deploy times |

**Week 6 Deliverable:** Automated pipeline: Build → Test → SonarQube → ECR → EKS

**📊 Benchmark Checkpoint:** Measure CI/CD pipeline duration (build time, deploy time)

#### 🎯 Stretch Goal: ArgoCD for GitOps (~8-12 hours)

If time permits, replace Jenkins EKS deployment with ArgoCD for a cleaner CI/CD separation:

| Task | Hours | Description |
|------|-------|-------------|
| ArgoCD fundamentals | 3 | Understand GitOps, ArgoCD architecture |
| Install ArgoCD on EKS | 2 | Helm install + initial config |
| Create GitOps repo | 2 | K8s manifests repo for ArgoCD to watch |
| Configure Applications | 2 | ArgoCD apps for userservice & productservice |
| Test auto-sync | 2 | Push manifest change → watch auto-deploy |

**Modified Architecture with ArgoCD:**
```
Jenkins (CI)                    ArgoCD (CD)
─────────────                   ───────────
Build → Test → SonarQube        Watches GitOps repo
       ↓                               ↓
Push image to ECR               Auto-syncs to EKS
       ↓                               ↑
Update image tag in ────────────────────┘
GitOps repo
```

**Why ArgoCD?**
- **Pull-based:** Runs inside cluster, no need to expose K8s API to Jenkins
- **GitOps:** Git becomes single source of truth for cluster state
- **Drift detection:** Auto-detects and fixes manual cluster changes
- **Industry standard:** Widely used in production K8s environments

**Resources:**
- [ArgoCD Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [ArgoCD + Jenkins Integration](https://argo-cd.readthedocs.io/en/stable/user-guide/ci_integration/)
- [GitOps with ArgoCD - YouTube](https://www.youtube.com/watch?v=MeU5_k9ssrs)

---

### Week 7: Elasticsearch Integration (~68 hours)
**Mar 19 - Mar 25, 2026**

| Day | Date | Hours | Task |
|-----|------|-------|------|
| Thu | Mar 19 | 9 | Scaler L9: Typeahead design + Scaler L13: Elasticsearch deep dive |
| Fri | Mar 20 | 9 | ES Docker local setup + basic queries |
| Sat | Mar 21 | 11 | Implement SearchServiceESImpl + index mapping |
| Sun | Mar 22 | 12 | Index products + test search + fuzzy matching |
| Mon | Mar 23 | 9 | Relevance tuning + autocomplete suggestions |
| Tue | Mar 24 | 9 | Deploy ES to AWS OpenSearch + configure VPC access |
| Wed | Mar 25 | 9 | Benchmark: MySQL LIKE vs Elasticsearch latency |

#### 📚 Scaler HLD - Lecture 9: Typeahead (Google, Amazon)
**Topics Covered:**
- HLD Interviews - 5 step process
- Problem Statement & Functional Requirements
- MVP Features & Features to avoid
- Non-Functional Requirements
- Scale Estimation & Pareto Principle (80-20 rule)
- Avg. vs Peak Load
- Read vs Write heavy systems
- Tries & Hashtables
- Optimizing Writes - Batching & Sampling
- Recency & Personalization

**Study Materials:**
- Notes: HLD 9 - Case Study: Typeahead

#### 📚 Scaler HLD - Lecture 13: Elasticsearch
**Topics Covered:**
- Full Text Search - why SQL is suboptimal
- Usecases & Inverted Index
- Text Preprocessing pipeline:
  - Parsing, Tokenization, Normalization
  - Stop Word Removal, Reduction
  - Stemming, Lemmatization
- Indexing & Term Frequency
- Document Frequency, TF-IDF score
- Apache Lucene
- Sharding by Key, by Document ID
- Elasticsearch architecture
- Fan-out reads
- Sharding & Replication in ElasticSearch
- B+Trees, Binary vs Ternary vs k-ary

**Study Materials:**
- Notes: HLD 13 - Case Study: ElasticSearch
- Mandatory Readings:
  - [Elasticsearch Tutorial - Sematext](https://sematext.com/guides/elasticsearch/)
  - [Elasticsearch text analysis intro](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis.html)
  - [Search Playground](https://www.elastic.co/search-labs/search-playground)
- Resources:
  - [Mini Beginner's Crash Course - YouTube](https://www.youtube.com/watch?v=gS_nHTWZEJ8)
  - [Shard Placement - AWS Blog](https://aws.amazon.com/blogs/opensource/demystifying-elasticsearch-shard-allocation/)

**Week 7 Deliverable:** Elasticsearch-powered product search

**📊 Benchmark Checkpoint:** Compare MySQL LIKE vs Elasticsearch search latency (critical for capstone report!)

---

### Week 8: Kafka + Cart Service (~68 hours)
**Mar 26 - Apr 1, 2026**

| Day | Date | Hours | Task |
|-----|------|-------|------|
| Thu | Mar 26 | 9 | Scaler L12: Kafka deep dive + Kafka Docker local setup |
| Fri | Mar 27 | 9 | Spring Kafka basics + producer/consumer implementation |
| Sat | Mar 28 | 11 | Cart Service: MongoDB setup + schema design |
| Sun | Mar 29 | 12 | Cart Service: API implementation (add/remove/update cart) |
| Mon | Mar 30 | 9 | Cart Service: Kafka producer for cart events |
| Tue | Mar 31 | 9 | Deploy Cart Service to EKS + AWS MSK setup |
| Wed | Apr 1 | 9 | End-to-end testing + Month 2 review |

#### 📚 Scaler HLD - Lecture 12: Kafka & Zookeeper
**Topics Covered:**
- Publisher Subscriber & Message Queue
- Decoupling, Load Leveling, Buffering
- Async Task Processing
- Event Driven Architectures
- Pros & Cons of message queues
- Apache Kafka:
  - Event Schema
  - Producers & Consumers
  - Pull vs Push
  - Consumer Groups
  - Topics & Partitions
  - Message Retention & Ordering
  - Partition Key & Mapping
  - Consumer Offsets & Rebalancing
- Delivery Guarantees:
  - At most once
  - At least once
  - Exactly once
- Message Brokers & Fault Tolerance
- Apache ZooKeeper:
  - Distributed Configuration Management
  - KRaft
  - Persistent vs Ephemeral nodes
  - Master election

**Study Materials:**
- Notes: HLD 12 - Messaging Queues - Apache Kafka & Zookeeper
- Mandatory Readings:
  - [Kafka Fundamentals - Conduktor](https://www.conduktor.io/kafka/kafka-fundamentals/)
  - [Kafka Design - Official Docs](https://kafka.apache.org/documentation/#design)
- Resources:
  - [Choosing Partitions](https://www.confluent.io/blog/how-choose-number-topics-partitions-kafka-cluster/)
  - [Replication Factor](https://www.conduktor.io/kafka/kafka-topics-choosing-the-replication-factor-and-partitions-count/)
  - [Offset Management](https://docs.confluent.io/platform/current/clients/consumer.html#offset-management)
  - [Kafka vs RabbitMQ vs SQS](https://ably.com/topic/apache-kafka-vs-rabbitmq-vs-aws-sns-sqs)
  - [Zookeeper Design Goals](https://zookeeper.apache.org/doc/current/zookeeperOver.html#sc_designGoals)

**Month 2 Milestone:**
```
✅ 3 microservices on EKS (User, Product, Cart)
✅ Jenkins CI/CD pipeline with SonarQube
✅ Kong API Gateway routing traffic
✅ Elasticsearch-powered product search
✅ Kafka for async communication
✅ MongoDB for Cart Service
📊 Baseline benchmarks captured for all deployed services
```

---

## Post 2-Months: Remaining Work (Month 3-4)

### Week 9-10: Order Service + Saga Pattern (~60 hours estimated)

#### 📚 Scaler HLD - Lecture 20: Distributed Transactions
**Topics Covered:**
- Managing Data in Microservices
- Command Query Responsibility Segregation (CQRS)
- API Composition / Aggregation
- Consistency in Microservices
- Two Phase Commit (2PC)
- Saga Patterns:
  - Orchestration
  - Choreography
  - When to choose what
- Event Sourcing

**Study Materials:**
- Notes: HLD 20 - Data Management, Consistency & Distributed Transactions
- Resources:
  - [Saga Pattern - microservices.io](https://microservices.io/patterns/data/saga.html)
  - [Saga Pattern - AWS](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-data-persistence/saga-pattern.html)
  - [CQRS - Martin Fowler](https://martinfowler.com/bliki/CQRS.html)
  - [Two Phase Commit](https://www.youtube.com/watch?v=-_rdWB9hN1c)

### Week 11-12: Payment + Notification + Redis (~60 hours estimated)

#### 📚 Scaler HLD - Lecture 6: CAP/PACELC + Replication
**Topics Covered:**
- Consistency, Availability, Network Partitions
- CAP & PACELC theorem
- Proof by example
- A+P / C+P / A+C systems
- Database Replication vs Sharding
- Master-Slave Replication
- Eventual Consistency, Immediate Consistency
- Data Loss, Quorum, Tunable Consistency
- Multi-Master Replication

**Study Materials:**
- Notes: HLD 6 - CAP/PACELC theorem + Master Slave Replication
- Mandatory Reading: [Master Slave MySQL](https://dev.mysql.com/doc/refman/8.0/en/replication.html)
- Resources:
  - [Google Spanner vs CAP](https://www.youtube.com/watch?v=oeycOVX70aE)

### Week 13-14: Performance Benchmarking & Optimization (~70 hours) — Month 4

Performance benchmarking is critical for the capstone report's **Feature Development Process** section and demonstrates real engineering value.

> **Timeline:** This is Month 4, after all services are built. However, you should capture **baseline metrics** during development (see Incremental Benchmarking below).

#### Incremental Benchmarking Strategy

Don't wait until Week 13-14 to start benchmarking. Capture baselines as you build:

| Week | Service Built | Baseline to Capture |
|------|---------------|---------------------|
| Week 5 | User + Product on EKS | API response times, DB query times |
| Week 7 | Elasticsearch | Search latency (MySQL vs ES comparison) |
| Week 8 | Cart + Kafka | MongoDB queries, Kafka producer throughput |
| Week 9-10 | Order Service | Saga completion time, concurrent orders |
| Week 11-12 | Payment + Notification | Gateway latency, email throughput |
| **Week 13-14** | **All services** | **Full optimization pass + documentation** |

**Quick Baseline Capture (5 min per service):**
```bash
# Simple baseline with wrk (run after each deployment)
wrk -t4 -c50 -d30s http://localhost:8080/products
wrk -t4 -c50 -d30s http://localhost:8080/categories
wrk -t4 -c50 -d30s http://localhost:8081/auth/validate

# Save results to file
echo "$(date): Product API" >> benchmarks.log
wrk -t4 -c50 -d30s http://localhost:8080/products >> benchmarks.log
```

#### Monitoring Stack Setup (8 hours)

| Task | Hours | Description |
|------|-------|-------------|
| Prometheus setup | 2 | Deploy to EKS, configure scrape targets |
| Grafana dashboards | 3 | Import Spring Boot, JVM, MySQL dashboards |
| Micrometer integration | 2 | Add to all services, custom metrics |
| Alerting rules | 1 | Define SLO-based alerts |

#### Benchmarking Tools Setup (4 hours)

| Tool | Purpose | Setup |
|------|---------|-------|
| **k6** | Load testing | `brew install k6` or Docker |
| **wrk** | Quick HTTP benchmarks | `apt install wrk` |
| **Async Profiler** | CPU/memory flamegraphs | Download from GitHub |
| **JFR** | Production profiling | Built into JDK 21 |

---

## Performance Benchmarking by Microservice

### User Service Benchmarks (8 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Login latency | p95 response time | ~150ms | <50ms | Cache user sessions in Redis |
| Token validation | requests/sec | ~500 | 5000+ | Cache JWT + session lookup |
| Signup throughput | requests/sec | ~100 | 500+ | Async email verification |
| DB queries | queries per login | 3 | 1 | Eager fetch user + roles |

**Key Optimizations:**
- Add Redis for session caching (`@Cacheable` on session lookup)
- Index on `sessions.token` and `jwt.user_id`
- Connection pool tuning (HikariCP)

**Load Test Script:**
```javascript
// k6: user-service-load.js
import http from 'k6/http';
export const options = { vus: 100, duration: '2m' };
export default function() {
  http.post('http://localhost:8081/auth/validate',
    JSON.stringify({ token: 'test-token' }),
    { headers: { 'Content-Type': 'application/json' } }
  );
}
```

---

### Product Service Benchmarks (10 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Product listing | p95 response time | ~100ms | <30ms | Redis cache + pagination |
| Product search (MySQL) | p95 response time | ~300ms | <50ms | Elasticsearch migration |
| Autocomplete | p95 response time | ~80ms | <20ms | ES completion suggester |
| Category lookup | p95 response time | ~50ms | <5ms | Cache all categories (small dataset) |
| Concurrent reads | requests/sec | ~200 | 2000+ | Cache + connection pool |

**Database Optimizations:**
```sql
-- Add composite index for search
CREATE INDEX idx_product_search ON products(is_deleted, category_id, name, price);

-- Add index for date range queries
CREATE INDEX idx_product_created ON products(created_at);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM products
WHERE is_deleted = false AND name LIKE '%phone%'
ORDER BY created_at DESC LIMIT 10;
```

**Caching Implementation:**
```java
// Add to ProductServiceDBImpl
@Cacheable(value = "products", key = "#id", unless = "#result == null")
public ProductResponseDTO getProductById(UUID id) { ... }

@Cacheable(value = "categories", unless = "#result.isEmpty()")
public List<CategoryResponseDTO> getAllCategories() { ... }

@CacheEvict(value = "products", key = "#id")
public void updateProduct(UUID id, ProductRequestDTO dto) { ... }
```

---

### Cart Service Benchmarks (8 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Add to cart | p95 response time | ~80ms | <30ms | MongoDB write concern tuning |
| Get cart | p95 response time | ~60ms | <20ms | Redis cache + MongoDB index |
| Update quantity | p95 response time | ~70ms | <25ms | Optimistic locking |
| Cart merge (guest→user) | p95 response time | ~200ms | <100ms | Batch operations |
| Kafka produce | messages/sec | ~500 | 5000+ | Batch producer config |

**MongoDB Optimizations:**
```javascript
// Create indexes
db.carts.createIndex({ "userId": 1 }, { unique: true });
db.carts.createIndex({ "sessionId": 1 });
db.carts.createIndex({ "items.productId": 1 });
db.carts.createIndex({ "updatedAt": 1 }, { expireAfterSeconds: 604800 }); // 7-day TTL

// Analyze query performance
db.carts.find({ userId: "uuid" }).explain("executionStats");
```

**Kafka Producer Tuning:**
```yaml
spring:
  kafka:
    producer:
      batch-size: 16384
      linger-ms: 5
      buffer-memory: 33554432
      acks: 1  # Trade durability for speed
```

---

### Order Service Benchmarks (10 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Order creation | p95 response time | ~500ms | <200ms | Async saga steps |
| Saga completion | end-to-end time | ~2s | <1s | Parallel where possible |
| Compensating txn | rollback time | ~1s | <500ms | Pre-computed rollback |
| Order history | p95 response time | ~150ms | <50ms | Pagination + caching |
| Concurrent orders | orders/sec | ~50 | 500+ | Connection pool + async |

**Saga Performance Patterns:**
```
Orchestration Saga Timeline (Before):
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│ Reserve │───▶│ Payment │───▶│ Update  │───▶│ Notify  │
│ Stock   │    │ Process │    │ Stock   │    │ User    │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
    100ms         300ms          100ms          50ms     = 550ms total

Optimized (Parallel where safe):
┌─────────┐    ┌─────────┐    ┌──────────────────────┐
│ Reserve │───▶│ Payment │───▶│ Update Stock ║ Notify │
│ Stock   │    │ Process │    │   (parallel)         │
└─────────┘    └─────────┘    └──────────────────────┘
    100ms         300ms              100ms              = 500ms total
```

**Database Optimizations:**
```sql
-- Index for order queries
CREATE INDEX idx_order_user_status ON orders(user_id, status, created_at DESC);
CREATE INDEX idx_order_status ON orders(status) WHERE status IN ('PENDING', 'PROCESSING');

-- Partition orders table by date (for scale)
-- Consider for >10M orders
```

---

### Payment Service Benchmarks (8 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Payment initiation | p95 response time | ~200ms | <100ms | Async gateway call |
| Payment verification | p95 response time | ~300ms | <150ms | Webhook-based |
| Idempotency check | p95 response time | ~50ms | <10ms | Redis idempotency keys |
| Refund processing | p95 response time | ~400ms | <200ms | Batch processing |
| Concurrent payments | payments/sec | ~100 | 1000+ | Connection pool + circuit breaker |

**Idempotency with Redis:**
```java
@Around("@annotation(Idempotent)")
public Object checkIdempotency(ProceedingJoinPoint joinPoint) {
    String key = "idempotency:" + extractKey(joinPoint);
    Boolean isNew = redisTemplate.opsForValue()
        .setIfAbsent(key, "processing", Duration.ofHours(24));
    if (!isNew) {
        return getCachedResult(key);
    }
    Object result = joinPoint.proceed();
    cacheResult(key, result);
    return result;
}
```

**Circuit Breaker for Payment Gateway:**
```java
@CircuitBreaker(name = "paymentGateway", fallbackMethod = "paymentFallback")
@Retry(name = "paymentGateway")
@TimeLimiter(name = "paymentGateway")
public PaymentResponse processPayment(PaymentRequest request) {
    return paymentGatewayClient.charge(request);
}
```

---

### Notification Service Benchmarks (6 hours)

| Area | Metric | Before | Target | Optimization |
|------|--------|--------|--------|--------------|
| Email send | p95 response time | ~500ms | <100ms | Async with Kafka |
| Kafka consumption | messages/sec | ~100 | 1000+ | Batch consumer |
| Template rendering | p95 response time | ~50ms | <10ms | Cache compiled templates |
| SES throughput | emails/sec | ~14 | 50+ | Request SES quota increase |
| Dead letter handling | retry latency | ~1min | <30s | Exponential backoff |

**Kafka Consumer Tuning:**
```yaml
spring:
  kafka:
    consumer:
      max-poll-records: 100
      fetch-min-size: 1024
      fetch-max-wait: 500ms
    listener:
      concurrency: 3
      ack-mode: batch
```

**Template Caching:**
```java
@Configuration
public class ThymeleafConfig {
    @Bean
    public SpringTemplateEngine templateEngine() {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setCacheManager(new StandardCacheManager()); // Enable caching
        engine.getConfiguration().setTemplateCacheMaxSize(100);
        return engine;
    }
}
```

---

### Cross-Cutting Benchmarks (12 hours)

#### Kong API Gateway

| Metric | Target | Optimization |
|--------|--------|--------------|
| Gateway latency overhead | <5ms | Enable proxy caching |
| Rate limiting accuracy | 99%+ | Redis-based rate limiting |
| Auth plugin latency | <10ms | JWT caching |

#### Service-to-Service Communication

| Pattern | Latency | Throughput | Use Case |
|---------|---------|------------|----------|
| REST (sync) | 20-50ms | 500 req/s | Simple queries |
| gRPC (sync) | 5-20ms | 2000 req/s | High-frequency calls |
| Kafka (async) | N/A | 10000+ msg/s | Event-driven |

#### Database Connection Pooling

```yaml
# HikariCP tuning for all services
spring:
  datasource:
    hikari:
      minimum-idle: 5
      maximum-pool-size: 20
      idle-timeout: 300000
      max-lifetime: 1200000
      connection-timeout: 20000
      leak-detection-threshold: 60000
```

#### JVM Tuning

```bash
# Production JVM flags
JAVA_OPTS="-Xms512m -Xmx1024m \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UseStringDeduplication \
  -XX:+HeapDumpOnOutOfMemoryError \
  -Xlog:gc*:file=/var/log/gc.log:time"
```

---

## Benchmarking Schedule

| Day | Hours | Task |
|-----|-------|------|
| Mon | 6 | Setup Prometheus + Grafana on EKS |
| Tue | 6 | Add Micrometer to all services, deploy |
| Wed | 6 | Write k6 load test scripts for User + Product services |
| Thu | 6 | Run baseline benchmarks, document results |
| Fri | 6 | Implement Redis caching for Product + User services |
| Sat | 6 | Run post-optimization benchmarks |
| Sun | 8 | Document before/after for capstone report |
| Mon | 6 | Write k6 scripts for Cart + Order services |
| Tue | 6 | Implement MongoDB indexes + Kafka tuning |
| Wed | 6 | Benchmark Payment + Notification services |
| Thu | 6 | Database query optimization (EXPLAIN ANALYZE) |
| Fri | 6 | Cross-cutting: Kong, connection pools, JVM |
| Sat | 6 | Final benchmarks, generate reports |
| Sun | 8 | Compile all results for capstone report |

---

## Benchmark Documentation Template

For each optimization, document:

```markdown
### [Feature Name] Performance Optimization

**Problem Statement:**
- Current p95 latency: XXX ms
- Current throughput: XXX req/s
- Bottleneck identified: [DB query / Network / CPU / Memory]

**Solution Implemented:**
- [Description of optimization]
- Code changes: [file:line references]

**Results:**
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| p95 latency | XXX ms | XXX ms | XX% |
| Throughput | XXX req/s | XXX req/s | XX% |
| Error rate | X% | X% | XX% |

**Evidence:**
- [Screenshot of Grafana dashboard]
- [k6 report output]
- [EXPLAIN ANALYZE output]
```

---

## Additional Study Materials by Topic

### SQL vs NoSQL (Lecture 7)
**Topics:** ACID vs BASE, Denormalization, Key-Value/Document/Wide-Column DBs

**Resources:**
- [MongoDB Playground](https://mongoplayground.net/)
- [MongoDB Getting Started](https://www.mongodb.com/docs/manual/tutorial/getting-started/)
- [Cassandra Basics](https://cassandra.apache.org/_/cassandra-basics.html)

### Database Orchestration (Lecture 8)
**Topics:** Sharding with Replication, Adding/Removing Servers, Seamless Shard Creation

### Large File Storage - S3, HDFS (Lecture 14)
**Topics:** File chunking, Name Nodes & Data Nodes, Hadoop, Bittorrent

**Resources:**
- [AWS S3 Docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
- [HBase Internals - Video](https://www.youtube.com/watch?v=N0h8DISLawI)

### Rate Limiting (Lecture 16)
**Topics:** ID generation at scale, UUIDv4, Twitter Snowflake, ULID

**Resources:**
- [Rate Limiting Fundamentals - ByteByteGo](https://blog.bytebytego.com/p/rate-limiting-fundamentals)
- [Rate Limiting Algorithms](https://blog.algomaster.io/p/rate-limiting-algorithms-explained-with-code)
- [Twitter Snowflake](https://blog.x.com/engineering/en_us/a/2010/announcing-snowflake)

---

## Architecture Overview (Target State)

```
                                    ┌─────────────────┐
                                    │   CloudFront    │
                                    │     (CDN)       │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │   AWS ALB       │
                                    │ (Load Balancer) │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Kong Gateway   │
                                    │  (API Gateway)  │
                                    └────────┬────────┘
                                             │
        ┌──────────────┬─────────────┬───────┴───────┬──────────────┬──────────────┐
        │              │             │               │              │              │
        ▼              ▼             ▼               ▼              ▼              ▼
   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌───────────┐   ┌─────────┐   ┌────────────┐
   │  User   │   │ Product │   │  Cart   │   │   Order   │   │ Payment │   │Notification│
   │ Service │   │ Service │   │ Service │   │  Service  │   │ Service │   │  Service   │
   └────┬────┘   └────┬────┘   └───┬─────┘   └─────┬─────┘   └────┬────┘   └─────┬──────┘
        │             │            │               │              │              │
        ▼             ▼            │               ▼              ▼              ▼
   ┌─────────┐   ┌─────────┐       │          ┌─────────┐   ┌─────────┐    ┌─────────┐
   │  MySQL  │   │  MySQL  │       │          │  MySQL  │   │  MySQL  │    │ AWS SES │
   │  (RDS)  │   │  (RDS)  │       │          │  (RDS)  │   │  (RDS)  │    └─────────┘
   └─────────┘   └────┬────┘       │          └─────────┘   └─────────┘
                      │            │
                      ▼            ▼
                ┌───────────┐  ┌───────┐  ┌───────┐
                │OpenSearch │  │MongoDB│  │ Redis │
                │(ES)       │  └───────┘  └───────┘
                └───────────┘

                      ▲              ▲              ▲
                      │              │              │
                      └──────────────┴──────────────┘
                                     │
                              ┌──────┴──────┐
                              │    Kafka    │
                              │   (MSK)     │
                              └─────────────┘
```

---

## Curriculum ↔ Project Mapping

| Scaler HLD Lecture | Topic | VibeVault Application | When |
|--------------------|-------|----------------------|------|
| 1 | System Design 101, DNS, LB | AWS ALB, Route53, Health checks | Week 1 |
| 2 | Consistent Hashing, Sharding | Database design, future scaling | Week 1 |
| 3-4 | Caching, Redis | Redis for Cart, search cache | Week 4 |
| 5 | Facebook News Feed | Fan-out pattern understanding | Week 4 |
| 6 | CAP/PACELC, Replication | RDS Read Replicas | Post Month 2 |
| 7 | SQL vs NoSQL | MySQL vs MongoDB for Cart | Week 8 |
| 8 | Database Orchestration | RDS Multi-AZ, failover | Post Month 2 |
| 9 | Typeahead | Product suggestions ✅ (built!) | Week 7 |
| 12 | Kafka & Zookeeper | Event-driven architecture | Week 8 |
| 13 | Elasticsearch | Product full-text search | Week 7 |
| 18 | Microservices Architecture | Kong, VPC, service design | Week 2 |
| 19 | Communication, Observability | gRPC/REST, ELK stack, tracing | Week 2 |
| 20 | Distributed Transactions | Saga pattern for Order→Payment | Post Month 2 |

---

## AWS Services Summary

| Service | AWS Product | Purpose |
|---------|-------------|---------|
| Container Orchestration | EKS | Run microservices |
| Container Registry | ECR | Store Docker images |
| Relational Database | RDS (MySQL) | User, Product, Order, Payment data |
| NoSQL Database | DocumentDB/MongoDB | Cart data |
| Cache | ElastiCache (Redis) | Session, cart caching |
| Search | OpenSearch | Product search |
| Message Broker | MSK (Kafka) | Async communication |
| Email | SES | Transactional emails |
| Load Balancer | ALB | Traffic distribution |
| API Gateway | Kong (self-hosted) | Routing, rate limiting |
| Secrets | Secrets Manager | Credentials management |
| Infrastructure | Terraform | IaC |
| CI/CD | Jenkins | Build & deploy automation |
| GitOps (Stretch) | ArgoCD | Declarative K8s deployments |
| Code Quality | SonarQube | Static analysis |

---

## 2-Month Achievement Summary

### What You'll Complete (~70% of roadmap)
```
✅ Terraform IaC managing all AWS resources
✅ EKS cluster with 3 microservices (User, Product, Cart)
✅ Jenkins CI/CD pipeline with SonarQube
✅ Kong API Gateway
✅ Elasticsearch-powered product search
✅ Kafka for async communication
✅ MongoDB for Cart Service
🎯 (Stretch) ArgoCD for GitOps deployments
```

### Remaining for Month 3+ (~30% of roadmap + benchmarking)
```
⏳ Order Service with Saga pattern (~60 hrs)
⏳ Payment Service (~30 hrs)
⏳ Notification Service with SES (~30 hrs)
⏳ Redis caching layer (~10 hrs)
⏳ Performance Benchmarking & Optimization (~70 hrs) ← NEW
⏳ Production hardening (~20 hrs)
```

**Total Post Month-2 Effort: ~220 hours**

---

## Job Application Timeline

### When to Start Applying

| After | Skills You'll Have | Role Level | Ready? |
|-------|-------------------|------------|--------|
| Month 1 | Terraform, K8s basics, System Design theory | Junior | ⚠️ Weak |
| **Month 2** | 3 microservices on EKS, CI/CD, Elasticsearch, Kafka, Kong | Mid-level | ✅ **Start here** |
| Month 3 | + Saga pattern, Payment, Notifications, Redis | Mid-Senior | ✅ Strong |
| Month 4 | + Performance optimization, benchmarks, complete project | Senior | ✅ Very Strong |

> **Recommendation:** Start applying at the end of Month 2 (Week 8). Interview cycles take 4-8 weeks, so starting early means offers align with project completion.

### Skills Ready After Month 2

```
✅ Real deployed project (not just localhost)
✅ Microservices architecture (3 services)
✅ Cloud experience (AWS EKS, RDS, ECR)
✅ DevOps skills (Terraform, K8s, Jenkins CI/CD)
✅ Search (Elasticsearch)
✅ Event-driven (Kafka)
✅ API Gateway (Kong)
✅ Databases (MySQL, MongoDB)
✅ Containerization (Docker)
```

### Application Preparation Checklist

| Task | When | Effort |
|------|------|--------|
| Update LinkedIn with project details | Week 6 | 2 hrs |
| Update resume with tech stack | Week 6 | 2 hrs |
| Push clean code to GitHub (public repo) | Week 7 | 1 hr |
| Write README with architecture diagram | Week 7 | 2 hrs |
| Record 2-min demo video (optional) | Week 8 | 2 hrs |
| Start applying on LinkedIn, Naukri, company sites | Week 8 | Ongoing |

### Interview + Development Strategy

```
Month 2, Week 7-8:
├── Start applying to 5-10 companies/week
├── Focus on startups first (faster process)
├── Continue building Cart + Kafka
└── Each week you're stronger in interviews

Month 3, Week 9-12:
├── Ramp up applications (10-15/week)
├── Interview prep alongside development
├── Saga pattern → great distributed systems topic
└── Target bigger companies now

Month 4:
├── Should have multiple offers
├── Complete benchmarking
├── Negotiate with data
└── Join with project 90% complete
```

### Common Interview Questions (You'll Be Ready)

| Topic | Your Answer |
|-------|-------------|
| "Tell me about your project" | E-commerce platform with User, Product, Cart microservices on AWS EKS |
| "How do you handle search?" | Elasticsearch with fuzzy matching, benchmarked vs MySQL LIKE |
| "Message queues experience?" | Kafka for async Cart→Order communication |
| "CI/CD experience?" | Jenkins: Build → Test → SonarQube → ECR → EKS |
| "Kubernetes?" | EKS with Deployments, Services, ConfigMaps, Ingress |
| "Database design?" | MySQL (structured), MongoDB (Cart), Redis (caching) |
| "System design?" | Load balancing, caching, sharding, CAP theorem |

### Target Roles & Expected CTC

**After Month 2:**

| Role | Companies | Expected CTC (India) |
|------|-----------|---------------------|
| Backend Engineer (Mid) | Startups, Product companies | ₹15-30 LPA |
| Software Engineer II | Service companies | ₹12-20 LPA |
| Platform Engineer | Cloud-native companies | ₹18-35 LPA |
| DevOps Engineer | Any | ₹15-28 LPA |

**After Month 3-4 (with Saga, Payment, benchmarks):**

| Role | Companies | Expected CTC (India) |
|------|-----------|---------------------|
| Senior Backend Engineer | Flipkart, Razorpay, CRED | ₹30-50 LPA |
| SDE-2/SDE-3 | Amazon, Microsoft, Google | ₹35-60 LPA |
| Staff Engineer | High-growth startups | ₹40-70 LPA |

### Application Strategy Matrix

Given your profile (3 years cloud security + Master's + VibeVault project):

| Role | Company Type | Apply? | Reasoning |
|------|--------------|--------|-----------|
| **SDE 2** | Startups/Non-MAANG | ✅ **Primary (50%)** | Right level for 3 years experience |
| **SDE 1** | MAANG | ✅ **Parallel (30%)** | MAANG SDE 1 pays = Non-MAANG SDE 2 |
| **SDE 2** | MAANG | ⚠️ **Stretch (20%)** | High bar, attempt after Month 4 |
| **SDE 1** | Non-MAANG | ❌ **Skip** | Underleveled, limits salary |

### Why MAANG SDE 1 is Worth It

| Factor | MAANG SDE 1 | Non-MAANG SDE 2 |
|--------|-------------|-----------------|
| CTC | ₹35-55 LPA | ₹25-40 LPA |
| Brand value | Excellent | Moderate |
| Learning | Best practices at scale | Varies |
| Growth | SDE 2 in 1-2 years | Depends |

**You're NOT overqualified for MAANG SDE 1** - your 3 years are in cloud security, not backend. Domain switch + Master's = valid SDE 1 narrative.

### Company Targets by Tier

#### Tier 1: Primary Targets — SDE 2 at Startups/Product Companies

| Company | Why Good Fit | Expected CTC | Apply When |
|---------|--------------|--------------|------------|
| **Razorpay** | Payments + security background | ₹30-45 LPA | Month 3 |
| **CRED** | Cloud-native, diverse backgrounds | ₹35-50 LPA | Month 3 |
| **Zerodha** | Platform engineering focus | ₹25-40 LPA | Month 3 |
| **Flipkart** | E-commerce = your project | ₹30-45 LPA | Month 3 |
| **Swiggy** | Microservices heavy | ₹28-42 LPA | Month 3 |
| **Meesho** | Fast-growing, less competitive | ₹25-38 LPA | Month 3 |
| **PhonePe** | Fintech, security valued | ₹30-45 LPA | Month 3 |
| **BrowserStack** | DevTools, CNCF background | ₹28-40 LPA | Month 3 |
| **Postman** | API tools, developer focus | ₹30-45 LPA | Month 3 |
| **Atlassian** | Platform engineering | ₹40-55 LPA | Month 3-4 |

#### Tier 2: Parallel Track — SDE 1 at MAANG

| Company | Role/Level | Expected CTC | Interview Focus |
|---------|------------|--------------|-----------------|
| **Google** | L3 | ₹35-50 LPA | DSA heavy, Googleyness |
| **Amazon** | SDE 1 | ₹30-45 LPA | DSA + Leadership Principles |
| **Microsoft** | 59-60 | ₹35-48 LPA | Balanced (DSA + Design) |
| **Meta** | E3 | ₹40-55 LPA | Very DSA heavy |
| **Apple** | ICT2 | ₹35-50 LPA | Less common in India |

#### Tier 3: Stretch Goals — SDE 2 at MAANG

| Company | Role/Level | Expected CTC | When to Apply |
|---------|------------|--------------|---------------|
| **Google** | L4 | ₹55-80 LPA | Month 4+ if crushing interviews |
| **Amazon** | SDE 2 | ₹45-65 LPA | Month 4+ |
| **Microsoft** | 61-62 | ₹50-70 LPA | Month 4+ |
| **Meta** | E4 | ₹60-90 LPA | Month 4+ (very high bar) |

### Week-by-Week Application Plan

#### Month 3: Warm-up & Primary Targets

| Week | Applications | Target Companies | Goal |
|------|--------------|------------------|------|
| **Week 9** | 5-8 | Meesho, BrowserStack, early-stage startups | Build interview confidence |
| **Week 10** | 8-10 | Swiggy, PhonePe, mid-stage startups | Get interview calls |
| **Week 11** | 10-12 | Razorpay, CRED, Flipkart | Primary targets |
| **Week 12** | 10-12 | Zerodha, Atlassian, continue above | Expand pipeline |

#### Month 4: MAANG + Intensify

| Week | Applications | Target Companies | Goal |
|------|--------------|------------------|------|
| **Week 13** | 8-10 | Amazon, Microsoft (SDE 1) | MAANG pipeline |
| **Week 14** | 8-10 | Google (L3), continue startups | Parallel tracks |
| **Week 15** | 5-8 | Meta, remaining targets | Complete pipeline |
| **Week 16** | As needed | Follow-ups, new opportunities | Close offers |

### How to Position Yourself

#### For MAANG SDE 1 Applications

**Cover letter / Intro:**
```
"I have 3 years of experience in cloud security at Accenture and recently
completed my Master's in Computer Science. During my Master's, I built
VibeVault - a production-grade e-commerce platform with 6 microservices
deployed on AWS EKS.

I'm applying for SDE 1 because I'm transitioning into backend development
and want to learn from the best engineering practices at [Company]. My
cloud infrastructure background means I understand how systems operate
at scale, and I'm now focused on building the applications that run on
that infrastructure."
```

#### For Startup/Product Company SDE 2 Applications

**Cover letter / Intro:**
```
"I bring 3 years of experience with a unique combination: cloud
infrastructure expertise from Accenture, open-source contribution to
CNCF's OpenCost project, and hands-on backend development from my
Master's project where I built a 6-service microservices platform
with Kafka, Elasticsearch, and AWS EKS.

I understand both how to build systems and how to operate them securely
at scale - a combination that's valuable for any growing engineering team."
```

### Interview Tracking Template

Track your applications in a spreadsheet:

| Company | Role | Applied Date | Status | Next Step | Notes |
|---------|------|--------------|--------|-----------|-------|
| Razorpay | SDE 2 | DD/MM | Applied / Screen / Tech1 / Tech2 / HR / Offer | Follow up by X | Referral from Y |
| Amazon | SDE 1 | DD/MM | ... | ... | ... |

**Status stages:**
```
Applied → Screening → Tech Round 1 → Tech Round 2 →
HLD/LLD Round → Hiring Manager → HR → Offer → Negotiation → Accepted
```

### Referral Strategy

| Source | How to Approach |
|--------|-----------------|
| **LinkedIn connections** | "I'm exploring SDE roles at [Company]. Would you be open to referring me?" |
| **College alumni** | Check alumni network for employees at target companies |
| **CNCF community** | OpenCost contributors might work at target companies |
| **Scaler network** | Fellow students/alumni at target companies |

### Negotiation Tips

When you have multiple offers:

| Scenario | Strategy |
|----------|----------|
| Startup vs MAANG SDE 1 | MAANG for brand if CTC similar |
| Multiple startup offers | Use higher offer to negotiate |
| MAANG SDE 1 vs MAANG SDE 1 | Compare team, role, location |
| Low offer from dream company | Ask for signing bonus, stocks, review timeline |

**Key phrases:**
- "I have a competing offer at ₹X. Can you match or improve?"
- "I'm very excited about [Company], but the offer is below my expectations based on my experience and the market."
- "Is there flexibility in the stock component?"

### Application Tracking Milestones

| Milestone | Target | By When |
|-----------|--------|---------|
| Applications sent | 50+ | End of Month 3 |
| Interview calls | 10-15 | End of Month 3 |
| Completed interviews | 8-10 | End of Month 4 |
| Offers received | 2-3 | End of Month 4 |
| Accepted offer | 1 | Month 4-5 |

---

## Optional: DevOps Skills Enhancement (If Time Permits)

The core roadmap covers ~60-70% of DevOps skills. Complete these optional modules to become a strong **DevOps Engineer** or **Platform Engineer** candidate.

### DevOps Readiness After Core Roadmap

| DevOps Domain | Coverage | Status |
|---------------|----------|--------|
| Containerization (Docker) | Full | ✅ Ready |
| Orchestration (Kubernetes) | Full | ✅ Ready |
| IaC (Terraform) | Full | ✅ Ready |
| CI/CD (Jenkins) | Full | ✅ Ready |
| Cloud (AWS) | Full | ✅ Ready |
| Monitoring (Prometheus/Grafana) | Full | ✅ Ready |
| GitOps (ArgoCD) | Stretch goal | ⚠️ Basic |
| Config Management (Ansible) | Not covered | ❌ Gap |
| Service Mesh (Istio) | Not covered | ❌ Gap |
| Centralized Logging (ELK) | Not covered | ❌ Gap |
| Helm Charts | Not covered | ❌ Gap |
| Advanced Scripting | Not covered | ❌ Gap |

### Optional Module 1: Helm Charts (6 hours)

Convert Kubernetes manifests to Helm charts for better package management.

| Task | Hours | Description |
|------|-------|-------------|
| Helm fundamentals | 2 | KodeKloud or official docs |
| Create userservice chart | 1.5 | Chart.yaml, values.yaml, templates/ |
| Create productservice chart | 1.5 | Parameterize environment-specific values |
| Test with `helm install` | 1 | Deploy to Minikube/EKS |

**Deliverable:**
```
/helm
  /userservice
    Chart.yaml
    values.yaml
    templates/
      deployment.yaml
      service.yaml
      configmap.yaml
  /productservice
    ...
```

**Resources:**
- [Helm Official Docs](https://helm.sh/docs/)
- [KodeKloud Helm Course](https://kodekloud.com/)

---

### Optional Module 2: ArgoCD GitOps (8 hours)

> Note: This is already mentioned as a stretch goal in Week 6. Complete it to strengthen DevOps profile.

| Task | Hours | Description |
|------|-------|-------------|
| ArgoCD fundamentals | 2 | GitOps concepts, architecture |
| Install ArgoCD on EKS | 2 | Helm install + ingress setup |
| Create GitOps repository | 2 | Separate repo for K8s manifests |
| Configure Applications | 2 | Auto-sync for all microservices |

**Architecture:**
```
Code Repo                    GitOps Repo                 EKS Cluster
─────────                    ───────────                 ───────────
Push code
    │
    ▼
Jenkins (CI)
    │
    ├── Build + Test
    ├── Push to ECR
    └── Update image tag ───▶ K8s manifests ◀─── ArgoCD watches
                                                       │
                                                       ▼
                                               Auto-deploy to EKS
```

**Resources:**
- [ArgoCD Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [GitOps with ArgoCD - TechWorld with Nana](https://www.youtube.com/watch?v=MeU5_k9ssrs)

---

### Optional Module 3: Ansible Basics (10 hours)

Configuration management for EC2 instances and initial server setup.

| Task | Hours | Description |
|------|-------|-------------|
| Ansible fundamentals | 3 | KodeKloud Ansible Basics |
| Inventory and playbooks | 2 | Define hosts, write first playbook |
| Jenkins server setup playbook | 2 | Automate Jenkins + Docker install |
| Roles and best practices | 2 | Organize playbooks into roles |
| Test on EC2 | 1 | Provision and configure real instance |

**Deliverable:**
```yaml
# playbooks/setup-jenkins.yml
---
- hosts: jenkins_server
  become: yes
  roles:
    - common
    - java
    - docker
    - jenkins

# roles/jenkins/tasks/main.yml
- name: Add Jenkins repository key
  apt_key:
    url: https://pkg.jenkins.io/debian/jenkins.io.key
    state: present

- name: Install Jenkins
  apt:
    name: jenkins
    state: present
```

**Resources:**
- [KodeKloud Ansible for Beginners](https://kodekloud.com/)
- [Ansible Official Docs](https://docs.ansible.com/)
- [Jeff Geerling's Ansible 101](https://www.youtube.com/playlist?list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)

---

### Optional Module 4: ELK Stack - Centralized Logging (8 hours)

Ship logs from all microservices to Elasticsearch for centralized analysis.

| Task | Hours | Description |
|------|-------|-------------|
| ELK architecture | 1 | Elasticsearch + Logstash + Kibana |
| Deploy ELK on Docker/K8s | 2 | Use Elastic Helm charts |
| Configure Filebeat/Fluentd | 2 | Ship logs from all services |
| Create Kibana dashboards | 2 | Visualize logs, create alerts |
| Integrate with Spring Boot | 1 | Structured JSON logging |

**Architecture:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ User Service│     │Product Svc  │     │ Cart Service│
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌──────▼──────┐
                    │  Fluentd /  │
                    │  Filebeat   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │Elasticsearch│
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Kibana    │
                    └─────────────┘
```

**Resources:**
- [Elastic Stack on Kubernetes](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html)
- [Fluentd Kubernetes Logging](https://docs.fluentd.org/container-deployment/kubernetes)

---

### Optional Module 5: Service Mesh - Istio (10 hours)

Advanced traffic management, security (mTLS), and observability.

| Task | Hours | Description |
|------|-------|-------------|
| Service mesh concepts | 2 | Sidecar proxy, control plane |
| Install Istio on EKS | 2 | istioctl or Helm |
| Enable sidecar injection | 1 | Label namespaces |
| Traffic management | 2 | Canary deployments, traffic splitting |
| mTLS and security | 2 | Zero-trust networking |
| Observability (Kiali, Jaeger) | 1 | Distributed tracing |

**Use Cases:**
- Canary deployments (route 10% traffic to new version)
- Circuit breaking between services
- Mutual TLS without code changes
- Distributed tracing across microservices

**Resources:**
- [Istio Official Docs](https://istio.io/latest/docs/)
- [Istio by Example](https://istiobyexample.dev/)
- [KodeKloud Istio Course](https://kodekloud.com/)

---

### Optional Module 6: Advanced Scripting (8 hours)

Python/Bash scripts for automation tasks.

| Task | Hours | Description |
|------|-------|-------------|
| Bash scripting deep dive | 3 | Loops, functions, error handling |
| Python for DevOps | 3 | boto3, subprocess, automation |
| Write utility scripts | 2 | Deploy script, health check, cleanup |

**Example Scripts:**
```bash
#!/bin/bash
# scripts/deploy.sh - Blue-green deployment helper
set -e

SERVICE=$1
NEW_VERSION=$2

echo "Deploying $SERVICE version $NEW_VERSION..."
kubectl set image deployment/$SERVICE $SERVICE=ecr.aws/$SERVICE:$NEW_VERSION
kubectl rollout status deployment/$SERVICE
echo "Deployment complete!"
```

```python
# scripts/health_check.py
import boto3
import requests

def check_services():
    services = ['userservice', 'productservice', 'cartservice']
    for svc in services:
        resp = requests.get(f'http://{svc}/actuator/health')
        print(f"{svc}: {resp.json()['status']}")

if __name__ == '__main__':
    check_services()
```

**Resources:**
- [Bash Scripting Tutorial](https://linuxconfig.org/bash-scripting-tutorial)
- [Python for DevOps Book](https://www.oreilly.com/library/view/python-for-devops/9781492057680/)

---

### Optional Module 7: Linux Administration (10 hours)

Strengthen fundamentals for troubleshooting and system administration.

| Task | Hours | Description |
|------|-------|-------------|
| Linux Upskill Challenge | 6 | 20-day guided learning |
| Performance troubleshooting | 2 | top, htop, iostat, netstat |
| Systemd and services | 1 | Create custom services |
| Security basics | 1 | SSH hardening, firewall rules |

**Key Commands to Master:**
```bash
# Performance
top / htop          # CPU and memory
iostat              # Disk I/O
netstat / ss        # Network connections
df -h / du -sh      # Disk usage

# Troubleshooting
journalctl -u service   # Service logs
dmesg                   # Kernel messages
strace                  # System call tracing
lsof                    # Open files

# Networking
ip addr / ifconfig      # Network interfaces
curl / wget             # HTTP requests
dig / nslookup          # DNS lookups
tcpdump                 # Packet capture
```

**Resources:**
- [Linux Upskill Challenge](https://linuxupskillchallenge.org/)
- [Linux Journey](https://linuxjourney.com/)
- [RHCSA Study Guide](https://www.redhat.com/en/services/certification/rhcsa)

---

### DevOps Skills Summary

| Module | Hours | Priority | Impact |
|--------|-------|----------|--------|
| Helm Charts | 6 | High | K8s package management |
| ArgoCD GitOps | 8 | High | Modern CI/CD |
| Ansible | 10 | Medium | Config management |
| ELK Stack | 8 | Medium | Observability |
| Istio | 10 | Low | Advanced microservices |
| Scripting | 8 | Medium | Automation |
| Linux Admin | 10 | Medium | Troubleshooting |
| **Total** | **60** | | |

### Recommended Order (If Limited Time)

```
Must Do (14 hrs):     Helm + ArgoCD
                      → Makes you stand out in DevOps interviews

Should Do (18 hrs):   + Ansible + Scripting
                      → Covers traditional DevOps gaps

Nice to Have (28 hrs): + ELK + Linux Admin + Istio
                       → Senior DevOps / SRE ready
```

### DevOps Roles After Optional Modules

| Modules Completed | Roles You Qualify For | Expected CTC |
|-------------------|----------------------|--------------|
| Core only | DevOps Engineer (Junior/Mid) | ₹12-25 LPA |
| + Helm + ArgoCD | DevOps Engineer (Mid) | ₹18-35 LPA |
| + Ansible + Scripting | DevOps Engineer (Mid-Senior) | ₹25-45 LPA |
| All modules | Senior DevOps / Platform / SRE | ₹35-60 LPA |

---

## SDE 2 Interview Preparation (~80 hours)

Tailored preparation for SDE 2 roles, considering your background:
- **2 years 9 months** at Accenture (Azure Cloud Security, Azure Policies)
- **3 months** internship at CNCF OpenCost project
- **Master's in CS** (completing with VibeVault project)

### Your Profile Positioning

```
┌─────────────────────────────────────────────────────────────────────┐
│  "I spent 3 years in cloud security understanding how systems      │
│   fail and how to make them resilient. Now I want to build the     │
│   applications that run on that infrastructure. My VibeVault       │
│   project demonstrates I can design and implement scalable         │
│   microservices, while my cloud background means I think about     │
│   security, scalability, and operations from day one."             │
└─────────────────────────────────────────────────────────────────────┘
```

### SDE 2 Interview Structure

| Round | Weightage | Your Preparation Focus |
|-------|-----------|----------------------|
| DSA (1-2 rounds) | 30% | Must prove coding skills - this is critical |
| Low Level Design | 20% | Scaler LLD + practice problems |
| High Level Design | 25% | Your project + Scaler HLD + practice |
| Project Deep Dive | 15% | VibeVault architecture decisions |
| Behavioral | 10% | Career transition story + STAR format |

### Eligibility Assessment

| Aspect | Status | Notes |
|--------|--------|-------|
| Years of experience | ✅ 3 years | Meets 2-4 year SDE 2 requirement |
| Coding experience | ⚠️ Limited | Azure policies ≠ backend coding |
| System design | ✅ Strong | Cloud background + Scaler HLD |
| Project | ✅ Strong | VibeVault demonstrates backend skills |
| Education | ✅ Strong | Master's in CS |

**Verdict:** Eligible for SDE 2, but need strong DSA performance to prove coding skills.

---

### Target Roles (By Fit)

#### Tier 1: High Success Probability

| Role | Why It Fits | Target Companies |
|------|-------------|------------------|
| **Platform Engineer** | Cloud + K8s + Backend | Razorpay, Gojek, Atlassian |
| **Backend (Cloud teams)** | Azure/AWS experience valued | Microsoft, Amazon, Google Cloud |
| **SRE** | Cloud + observability | LinkedIn, Uber, Dropbox |

#### Tier 2: Good Fit

| Role | Prep Needed | Target Companies |
|------|-------------|------------------|
| **SDE 2 (Backend)** | Strong DSA + project showcase | Flipkart, CRED, Swiggy |
| **DevOps Engineer** | Natural fit | Any tech company |

#### Companies That Value Your Profile

| Company Type | Examples | Why They'll Like You |
|--------------|----------|---------------------|
| Cloud-native startups | Hasura, Postman, BrowserStack | Cloud + can build |
| DevTools | Grafana, HashiCorp, GitLab | CNCF background |
| Fintech | Razorpay, CRED, Zerodha | Security background |
| E-commerce | Flipkart, Meesho, Myntra | Your project is relevant |

---

### DSA Preparation Track (40 hours)

For SDE 2, you need ~80-100 well-understood problems (not 200+ like for junior roles).

#### Week-by-Week DSA Plan

| Week | Topics | Problems | Hours |
|------|--------|----------|-------|
| 1 | Arrays, Strings, Hashing | 15 Medium | 8 |
| 2 | Two Pointers, Sliding Window | 12 Medium | 7 |
| 3 | Trees, BST, BFS/DFS | 15 Medium-Hard | 8 |
| 4 | Graphs (BFS, DFS, Dijkstra) | 12 Medium-Hard | 7 |
| 5 | DP (1D and 2D) | 15 Medium-Hard | 10 |

#### Topic-Wise Problem List

**Arrays & Strings (15 problems)**
| # | Problem | Difficulty | Pattern |
|---|---------|------------|---------|
| 1 | Two Sum | Easy | Hashing |
| 2 | Best Time to Buy and Sell Stock | Easy | Kadane's |
| 3 | Contains Duplicate | Easy | Hashing |
| 4 | Product of Array Except Self | Medium | Prefix/Suffix |
| 5 | Maximum Subarray | Medium | Kadane's |
| 6 | 3Sum | Medium | Two Pointers |
| 7 | Container With Most Water | Medium | Two Pointers |
| 8 | Longest Substring Without Repeating | Medium | Sliding Window |
| 9 | Longest Palindromic Substring | Medium | Expand Around Center |
| 10 | Group Anagrams | Medium | Hashing |
| 11 | Valid Parentheses | Easy | Stack |
| 12 | Merge Intervals | Medium | Sorting |
| 13 | Next Permutation | Medium | Pattern |
| 14 | Trapping Rain Water | Hard | Two Pointers |
| 15 | Minimum Window Substring | Hard | Sliding Window |

**Trees & Graphs (27 problems)**
| # | Problem | Difficulty | Pattern |
|---|---------|------------|---------|
| 1 | Invert Binary Tree | Easy | Recursion |
| 2 | Maximum Depth of Binary Tree | Easy | DFS |
| 3 | Same Tree | Easy | DFS |
| 4 | Binary Tree Level Order Traversal | Medium | BFS |
| 5 | Validate BST | Medium | DFS + Range |
| 6 | Lowest Common Ancestor | Medium | DFS |
| 7 | Binary Tree Right Side View | Medium | BFS |
| 8 | Serialize/Deserialize Binary Tree | Hard | BFS/DFS |
| 9 | Number of Islands | Medium | DFS/BFS |
| 10 | Clone Graph | Medium | BFS + HashMap |
| 11 | Course Schedule | Medium | Topological Sort |
| 12 | Course Schedule II | Medium | Topological Sort |
| 13 | Pacific Atlantic Water Flow | Medium | DFS |
| 14 | Word Ladder | Hard | BFS |
| 15 | Alien Dictionary | Hard | Topological Sort |

**Dynamic Programming (20 problems)**
| # | Problem | Difficulty | Pattern |
|---|---------|------------|---------|
| 1 | Climbing Stairs | Easy | 1D DP |
| 2 | House Robber | Medium | 1D DP |
| 3 | House Robber II | Medium | 1D DP |
| 4 | Coin Change | Medium | 1D DP |
| 5 | Longest Increasing Subsequence | Medium | 1D DP |
| 6 | Word Break | Medium | 1D DP |
| 7 | Unique Paths | Medium | 2D DP |
| 8 | Jump Game | Medium | Greedy/DP |
| 9 | Decode Ways | Medium | 1D DP |
| 10 | Longest Common Subsequence | Medium | 2D DP |
| 11 | Edit Distance | Hard | 2D DP |
| 12 | 0/1 Knapsack | Medium | 2D DP |
| 13 | Partition Equal Subset Sum | Medium | 2D DP |
| 14 | Target Sum | Medium | 2D DP |
| 15 | Longest Palindromic Subsequence | Medium | 2D DP |

**System Design-ish DSA (8 problems)**
| # | Problem | Difficulty | Why Important |
|---|---------|------------|---------------|
| 1 | LRU Cache | Medium | Asked frequently |
| 2 | LFU Cache | Hard | Cache understanding |
| 3 | Design Twitter | Medium | System design lite |
| 4 | Min Stack | Medium | Stack design |
| 5 | Implement Trie | Medium | Search systems |
| 6 | Design Add and Search Words | Medium | Trie + DFS |
| 7 | Find Median from Data Stream | Hard | Heap design |
| 8 | Rate Limiter (custom) | Medium | Real-world design |

#### DSA Resources

| Resource | Use For | Link |
|----------|---------|------|
| NeetCode 150 | Curated patterns | [neetcode.io](https://neetcode.io/) |
| Striver's SDE Sheet | Indian interviews | [takeuforward.org](https://takeuforward.org/interviews/strivers-sde-sheet-top-coding-interview-problems/) |
| LeetCode | Practice | [leetcode.com](https://leetcode.com/) |
| AlgoExpert | Video explanations | [algoexpert.io](https://www.algoexpert.io/) |

---

### High Level Design Practice (20 hours)

Your Scaler HLD curriculum covers theory. Practice these specific problems:

#### Must-Practice HLD Problems

| # | Problem | Key Concepts | Prep Time |
|---|---------|--------------|-----------|
| 1 | **Design URL Shortener** | Hashing, DB, Base62 encoding | 2 hrs |
| 2 | **Design Twitter Feed** | Fan-out, caching, pub-sub | 2 hrs |
| 3 | **Design WhatsApp** | Messaging, presence, delivery guarantees | 2 hrs |
| 4 | **Design Rate Limiter** | Token bucket, sliding window, distributed | 2 hrs |
| 5 | **Design Notification System** | Push, email, queuing, prioritization | 2 hrs |
| 6 | **Design E-commerce** (Your Project!) | Cart, orders, payments, Saga | 2 hrs |
| 7 | **Design Uber/Ola** | Location, matching, real-time | 2 hrs |
| 8 | **Design YouTube** | Video upload, CDN, transcoding | 2 hrs |

#### HLD Answer Framework (Use for Every Problem)

```
1. REQUIREMENTS (3 min)
   ├── Functional: What should the system do?
   ├── Non-functional: Scale, latency, availability
   └── Clarifying questions

2. ESTIMATION (3 min)
   ├── Users: DAU, MAU
   ├── Traffic: QPS (read/write)
   ├── Storage: Data size over 5 years
   └── Bandwidth

3. HIGH-LEVEL DESIGN (10 min)
   ├── Draw main components
   ├── API design
   └── Data flow

4. DEEP DIVE (15 min)
   ├── Database schema
   ├── Scaling strategies
   ├── Caching
   └── Trade-offs

5. WRAP UP (4 min)
   ├── Bottlenecks
   ├── Monitoring
   └── Future improvements
```

#### Using Your Project in HLD Interviews

When asked to design an e-commerce system, payment system, or notification system:

```
"I actually built something similar in my VibeVault project. Let me walk you
through the architecture decisions I made..."

Then discuss:
├── Why microservices over monolith?
├── Why Saga pattern for Order→Payment?
├── Why Elasticsearch for search vs MySQL LIKE?
├── Why Kafka for async communication?
├── Why MongoDB for Cart vs MySQL?
└── Performance benchmarks (before/after)
```

#### HLD Resources

| Resource | Use For |
|----------|---------|
| [System Design Primer](https://github.com/donnemartin/system-design-primer) | Free comprehensive guide |
| [ByteByteGo](https://www.youtube.com/@ByteByteGo) | Visual explanations |
| [Designing Data-Intensive Applications](https://dataintensive.net/) | Deep theory |
| [Gaurav Sen](https://www.youtube.com/@gaborsen) | Indian interview focused |
| Your Scaler HLD Notes | Already curated |

---

### Low Level Design Practice (10 hours)

#### Must-Practice LLD Problems

| # | Problem | Concepts Tested | Time |
|---|---------|-----------------|------|
| 1 | **Parking Lot** | Classes, enums, relationships | 1.5 hrs |
| 2 | **BookMyShow** | Seat booking, concurrency, locking | 1.5 hrs |
| 3 | **Library Management** | CRUD, relationships, search | 1 hr |
| 4 | **Splitwise** | Expense sharing, graph algorithms | 1.5 hrs |
| 5 | **Tic-Tac-Toe** | Game state, validation | 1 hr |
| 6 | **Snake & Ladder** | State machine, dice, board | 1 hr |
| 7 | **Chess (basic)** | Inheritance, polymorphism | 1.5 hrs |
| 8 | **Elevator System** | State machine, scheduling | 1 hr |

#### LLD Answer Framework

```
1. CLARIFY REQUIREMENTS (2 min)
   └── What features to support?

2. IDENTIFY CLASSES (3 min)
   ├── Nouns → Classes
   └── Verbs → Methods

3. RELATIONSHIPS (2 min)
   ├── Has-A (composition)
   ├── Is-A (inheritance)
   └── Uses-A (dependency)

4. DESIGN PATTERNS (3 min)
   └── Which patterns apply?

5. CODE SKELETON (15 min)
   ├── Classes with key methods
   ├── Interfaces
   └── Main flow

6. HANDLE EDGE CASES (5 min)
```

#### Design Patterns to Know

| Pattern | When to Use | Example from Your Project |
|---------|-------------|---------------------------|
| **Singleton** | One instance | Database connection pool |
| **Factory** | Object creation | PaymentProcessorFactory (Razorpay, Stripe) |
| **Strategy** | Swappable algorithms | SearchStrategy (MySQL, Elasticsearch) |
| **Observer** | Event notifications | OrderCreated → Notify, UpdateInventory |
| **Builder** | Complex object construction | ProductRequestDTO builder |
| **Decorator** | Add behavior | Logging decorators |
| **Repository** | Data access abstraction | ProductRepository, UserRepository |

---

### Behavioral Preparation (10 hours)

#### Your Career Story (Memorize This)

**"Tell me about yourself" (2 min version):**
```
"I'm a software engineer with 3 years of experience, transitioning from
cloud security to backend development.

At Accenture, I spent nearly 3 years working on Azure cloud security,
implementing policies and governance for enterprise clients. This gave
me deep understanding of how large-scale systems operate and fail.

I also contributed to OpenCost, a CNCF project for Kubernetes cost
monitoring, which exposed me to open-source development and cloud-native
technologies.

Now I'm completing my Master's in CS, where I built VibeVault - a
production-grade e-commerce platform with 6 microservices, Kafka,
Elasticsearch, and deployed on AWS EKS. This project was intentional -
I wanted to prove I can build the applications that I've been securing
and deploying.

I'm looking for SDE 2 roles where I can combine my infrastructure
knowledge with backend development to build scalable, secure systems."
```

#### STAR Stories from Your Experience

| Question Type | Story Source | STAR Format |
|---------------|--------------|-------------|
| **Ownership** | VibeVault project | Built e2e, made all architecture decisions |
| **Technical Decision** | Saga vs 2PC, ES vs MySQL | Evaluated trade-offs, chose based on requirements |
| **Challenge** | Learning new stack | Java, Spring Boot, K8s in 4 months |
| **Conflict** | (Prepare from Accenture) | Disagreement with team/client, resolution |
| **Failure** | (Prepare authentic story) | What went wrong, what you learned |
| **Impact** | OpenCost contribution | Open-source impact, CNCF recognition |

#### Common Behavioral Questions

**About Career Transition:**
| Question | How to Answer |
|----------|---------------|
| "Why switch from cloud to backend?" | "Want to build what I've been securing" |
| "Why should we hire you over someone with backend experience?" | "I bring security-first thinking + infra knowledge + recent hands-on project" |
| "Will you go back to cloud roles?" | "Backend + Cloud = Platform Engineering is my goal" |

**About Your Project:**
| Question | How to Answer |
|----------|---------------|
| "Why did you choose this architecture?" | Explain trade-offs (monolith vs microservices, etc.) |
| "What was the hardest part?" | Saga pattern implementation, distributed transactions |
| "What would you do differently?" | Be honest, show growth mindset |

**General:**
| Question | Your STAR Story |
|----------|-----------------|
| "Tell me about a time you disagreed with someone" | Prepare from Accenture |
| "Describe a time you failed" | Authentic story, focus on learning |
| "How do you handle tight deadlines?" | VibeVault + Masters + Job search |

---

### Mock Interview Schedule (10 hours)

| Week | Mock Type | Platform | Focus |
|------|-----------|----------|-------|
| 1 | DSA Mock | Pramp / InterviewBit | Arrays, Strings |
| 2 | DSA Mock | Pramp | Trees, Graphs |
| 3 | LLD Mock | Peer / Pramp | Parking Lot, BookMyShow |
| 4 | HLD Mock | Peer / Interviewing.io | URL Shortener, Twitter |
| 5 | Full Loop | Interviewing.io | All rounds |

#### Mock Interview Resources

| Platform | Type | Cost |
|----------|------|------|
| [Pramp](https://www.pramp.com/) | Free peer mocks | Free |
| [Interviewing.io](https://interviewing.io/) | Anonymous with engineers | Paid |
| [InterviewBit](https://www.interviewbit.com/) | DSA practice | Free + Paid |
| Peer mock | Find on LinkedIn/Discord | Free |

---

### SDE 2 Prep Timeline

#### Integrated with Main Roadmap

```
Month 2 (Roadmap Week 5-8):
├── Building: User, Product, Cart on EKS
├── DSA: 25 problems (Arrays, Strings, Hashing)
└── Output: 3 services deployed + DSA foundation

Month 3 (Roadmap Week 9-12):
├── Building: Order, Payment, Notification
├── DSA: 35 problems (Trees, Graphs, DP)
├── LLD: Practice 4 problems
├── Start applying: Week 10
└── Output: 6 services + DSA intermediate

Month 4 (Roadmap Week 13-14 + Interview Prep):
├── Building: Performance benchmarking
├── DSA: 20 problems (DP, revision)
├── HLD: Practice 6 problems
├── Mocks: 4-5 mock interviews
├── Interview actively
└── Output: Complete project + interview ready

Month 5 (If needed):
├── Full interview mode
├── Company-specific prep
└── Negotiate offers
```

#### Weekly Schedule (During Month 3-4)

```
Monday:     DSA (2 hrs) + Project work (3 hrs)
Tuesday:    DSA (2 hrs) + Project work (3 hrs)
Wednesday:  LLD/HLD practice (2 hrs) + Project work (3 hrs)
Thursday:   DSA (2 hrs) + Project work (3 hrs)
Friday:     DSA (2 hrs) + Applications/networking (2 hrs)
Saturday:   Mock interview (2 hrs) + HLD practice (2 hrs)
Sunday:     Revision (2 hrs) + Behavioral prep (1 hr)

Total: ~35-40 hrs/week
```

---

### Resume Positioning

#### How to Present Your Experience

**Current (Weak):**
```
Azure Cloud Security Engineer - Accenture
- Worked on Azure policies
- Managed security governance
```

**Improved (Strong):**
```
Cloud Security Engineer - Accenture (2 yrs 9 mos)
- Designed and implemented Azure Policy governance for 50+ enterprise
  subscriptions, reducing security violations by 40%
- Automated security compliance checks using Azure Functions and Logic Apps
- Collaborated with development teams to integrate security into CI/CD pipelines
- Technologies: Azure, ARM Templates, PowerShell, Azure DevOps

Open Source Contributor - OpenCost (CNCF) (3 mos)
- Contributed to Kubernetes cost monitoring tool with 4k+ GitHub stars
- Implemented [specific feature/fix]
- Technologies: Go, Kubernetes, Prometheus
```

**Project Section:**
```
VibeVault E-commerce Platform (Master's Project)
- Architected microservices platform with 6 services handling 1000+ req/sec
- Implemented Saga pattern for distributed transactions across Order-Payment services
- Built product search with Elasticsearch, achieving 10x latency improvement over MySQL
- Deployed on AWS EKS with Terraform IaC and Jenkins CI/CD
- Technologies: Java, Spring Boot, MySQL, MongoDB, Redis, Kafka, Elasticsearch,
  Kubernetes, Terraform, AWS (EKS, RDS, MSK, OpenSearch)
```

---

### SDE 2 Prep Summary

| Component | Hours | When |
|-----------|-------|------|
| DSA Practice | 40 | Month 2-4 (ongoing) |
| HLD Practice | 20 | Month 3-4 |
| LLD Practice | 10 | Month 3 |
| Behavioral Prep | 10 | Month 3-4 |
| Mock Interviews | 10 | Month 4 |
| **Total** | **90** | |

### Expected Outcomes

| After | Status | What You Can Target |
|-------|--------|---------------------|
| Month 2 | Project deployed, DSA weak | Early-stage startups |
| Month 3 | 60% DSA done, LLD practiced | Mid-stage startups, product companies |
| Month 4 | Full prep complete | Flipkart, Razorpay, CRED, Amazon |
| Month 4 + Mocks | Interview battle-tested | FAANG, top unicorns |

---

## Capstone Project Report (Master's Degree)

A comprehensive project report is required as part of the Master of Science in Computer Science degree from Scaler Neovarsity - Woolf.

**Template:** [Project Report Template](./Scaler%20Neovarsity%20_%20Academy%20Project%20Report%20Template%20(Backend%20Specialization).md)

### Report Requirements
- **Minimum Length:** 40 pages
- **Format:** Times New Roman, 14pt headings, 12pt body, 1.5 line spacing
- **Margins:** 1.25" left/right, 1" top/bottom

### Report Structure & Tasks

| Section | Description | Effort |
|---------|-------------|--------|
| **Abstract** | 300-word summary of project purpose, methods, results, conclusions | 2 hrs |
| **Project Description** | Objectives, relevance, flow diagrams of VibeVault platform | 4 hrs |
| **Requirement Gathering** | Functional/Non-functional requirements, Use Case diagrams, Feature tables | 6 hrs |
| **Class Diagrams** | LLD diagrams for all microservices (User, Product, Cart, Order, Payment, Notification) | 8 hrs |
| **Database Schema Design** | Textual + visual schema for MySQL, MongoDB, Redis | 6 hrs |
| **Feature Development Process** | Deep-dive on 2-3 features with performance benchmarks (see Week 13-14 benchmarking data) | 8 hrs |
| **Deployment Flow** | AWS architecture: EKS, VPC, ALB, RDS, OpenSearch, MSK, SES with diagrams | 6 hrs |
| **Technologies Used** | Kafka, Elasticsearch, Spring Boot, Kubernetes, Terraform, Jenkins - real-world examples | 8 hrs |
| **Conclusion** | Key takeaways, practical applications, limitations, cost implications | 3 hrs |
| **References** | All sources, articles, documentation cited | 2 hrs |
| **Formatting & Review** | Tables/figures lists, proofreading, plagiarism check | 4 hrs |

**Total Estimated Effort:** ~57 hours

### Report Timeline

| Week | Tasks |
|------|-------|
| Week 1 | Abstract, Project Description, Requirement Gathering |
| Week 2 | Class Diagrams, Database Schema Design |
| Week 3 | Feature Development Process, Deployment Flow |
| Week 4 | Technologies Used, Conclusion, References, Final Review |

### Tools for Report
- **Diagrams:** [Excalidraw](https://excalidraw.com/), [Draw.io](https://draw.io)
- **Document:** Google Docs or MS Word (for formatting requirements)
- **Plagiarism Check:** Turnitin or similar tool

### Tips
- Take screenshots of working features, API responses, deployment dashboards as you build
- Document performance benchmarks (before/after optimization) during development
- Keep notes on architecture decisions and trade-offs for the Conclusion section
- Use the **Benchmark Documentation Template** from Week 13-14 for consistent reporting
- Grafana screenshots and k6 reports make excellent figures for the report
- Highlight cost implications of optimizations (e.g., Redis adds cost but reduces DB load)

---

## References

### Project Documentation
- [PRD & HLD Document](./PRD_%20HLD%20of%20Ecommerce%20Website.md)
- [Product Service Docker Setup](./README.md#docker-setup)

### Scaler HLD Curriculum
- [Curriculum & Notes PDF](./Scaler%20HLD%20Curriculum%20%26%20Notes.pdf)
- Reference Book: *Designing Data-Intensive Applications* by Martin Kleppmann

### KodeKloud Courses
- Terraform for Beginners
- Kubernetes for Beginners → CKA
- Jenkins
- AWS Solutions Architect

### Tools for HLD Diagrams
- [Excalidraw](https://excalidraw.com/) (Recommended)
- [Draw.io](https://draw.io)
