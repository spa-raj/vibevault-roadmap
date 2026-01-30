# VibeVault E-commerce Platform Roadmap

Based on the PRD/HLD and current progress.

---

## Table of Contents

1. [Current State](#current-state)
2. [Time Commitment](#time-commitment)
3. [Learning Resources](#learning-resources)
   - [Theory (System Design)](#theory-system-design)
   - [Hands-on (DevOps & Cloud)](#hands-on-devops--cloud)
4. [Month 1: Foundation (~120 hours)](#month-1-foundation-120-hours)
   - [Week 1: Terraform Fundamentals](#week-1-terraform-fundamentals-30-hours)
   - [Week 2: Terraform AWS + Infrastructure](#week-2-terraform-aws--infrastructure-30-hours)
   - [Week 3: Kubernetes Fundamentals](#week-3-kubernetes-fundamentals-30-hours)
   - [Week 4: Kubernetes Advanced + Local Testing](#week-4-kubernetes-advanced--local-testing-30-hours)
5. [Month 2: Implementation Sprint (~190 hours)](#month-2-implementation-sprint-190-hours)
   - [Week 5: Deploy to EKS + Kong](#week-5-deploy-to-eks--kong-44-hours)
   - [Week 6: CI/CD Pipeline](#week-6-cicd-pipeline-44-hours)
   - [Week 7: Elasticsearch Integration](#week-7-elasticsearch-integration-44-hours)
   - [Week 8: Kafka + Cart Service](#week-8-kafka--cart-service-44-hours)
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
15. [Job Application Timeline](#job-application-timeline) *(Start applying: Month 2, Week 8)*
    - [When to Start Applying](#when-to-start-applying)
    - [Application Preparation Checklist](#application-preparation-checklist)
    - [Target Roles & Expected CTC](#target-roles--expected-ctc)
16. [Optional: DevOps Skills Enhancement](#optional-devops-skills-enhancement-if-time-permits) *(+60 hours)*
    - [Helm Charts](#optional-module-1-helm-charts-6-hours) (6 hrs)
    - [ArgoCD GitOps](#optional-module-2-argocd-gitops-8-hours) (8 hrs)
    - [Ansible Basics](#optional-module-3-ansible-basics-10-hours) (10 hrs)
    - [ELK Stack](#optional-module-4-elk-stack---centralized-logging-8-hours) (8 hrs)
    - [Service Mesh - Istio](#optional-module-5-service-mesh---istio-10-hours) (10 hrs)
    - [Advanced Scripting](#optional-module-6-advanced-scripting-8-hours) (8 hrs)
    - [Linux Administration](#optional-module-7-linux-administration-10-hours) (10 hrs)
17. [Capstone Project Report (Master's Degree)](#capstone-project-report-masters-degree)
    - [Report Requirements](#report-requirements)
    - [Report Structure & Tasks](#report-structure--tasks)
    - [Report Timeline](#report-timeline)
18. [References](#references)

---

## Current State
- ✅ User Management Service (userservice)
- ✅ Product Catalog Service (productservice)
- ✅ Docker containerization

---

## Time Commitment

### Month 1 (~120 hours)
- Weekdays: 4 hours/day (also doing Java/LLD + DSA)
- Sundays: 6 hours/day
- **Focus:** 60% Learning, 40% Implementation

### Month 2 (~190 hours)
- Weekdays: 6 hours/day
- Sundays: 8 hours/day
- **Focus:** 20% Learning, 80% Implementation

**Total: ~310 hours over 2 months**

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

---

## Month 1: Foundation (~120 hours)

### Week 1: Terraform Fundamentals (~30 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 4 | KodeKloud: Terraform intro + HCL basics |
| Tue | 4 | KodeKloud: Terraform state, providers |
| Wed | 4 | KodeKloud: Terraform modules |
| Thu | 4 | Scaler L1: System Design 101 |
| Fri | 4 | KodeKloud: Terraform + AWS provider |
| Sat | 4 | Hands-on: Write basic VPC module |
| Sun | 6 | Scaler L2 + Continue VPC module |

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

**Week 1 Deliverable:** Basic Terraform VPC module

---

### Week 2: Terraform AWS + Infrastructure (~30 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 4 | Terraform: EKS module basics |
| Tue | 4 | Terraform: RDS module |
| Wed | 4 | Terraform: ECR module |
| Thu | 4 | Scaler L18: Microservices Architecture |
| Fri | 4 | Terraform: Wire modules together |
| Sat | 4 | Deploy infrastructure to AWS |
| Sun | 6 | Debug + Scaler L19: Microservices Communication |

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

### Week 3: Kubernetes Fundamentals (~30 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 4 | KodeKloud: K8s Architecture, Pods |
| Tue | 4 | KodeKloud: Deployments, ReplicaSets |
| Wed | 4 | KodeKloud: Services, Networking |
| Thu | 4 | KodeKloud: ConfigMaps, Secrets |
| Fri | 4 | KodeKloud: Ingress, RBAC |
| Sat | 4 | Write K8s manifests for userservice |
| Sun | 6 | Write K8s manifests for productservice |

**Week 3 Deliverable:** K8s manifests for both services (Deployment, Service, ConfigMap, Secrets)

---

### Week 4: Kubernetes Advanced + Local Testing (~30 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 4 | KodeKloud: Helm basics |
| Tue | 4 | KodeKloud: EKS specifics |
| Wed | 4 | Test services on Minikube |
| Thu | 4 | Debug and fix issues |
| Fri | 4 | Scaler L3: Caching fundamentals |
| Sat | 4 | Scaler L4: Redis case study |
| Sun | 6 | Prepare for EKS deployment |

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

## Month 2: Implementation Sprint (~190 hours)

### Week 5: Deploy to EKS + Kong (~44 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 6 | Deploy userservice to EKS |
| Tue | 6 | Deploy productservice to EKS |
| Wed | 6 | Debug networking, service discovery |
| Thu | 6 | Install Kong Ingress Controller |
| Fri | 6 | Configure Kong routes |
| Sat | 6 | AWS ALB + DNS setup |
| Sun | 8 | End-to-end testing + fixes |

**Week 5 Deliverable:** Both services running on EKS with Kong API Gateway

**📊 Benchmark Checkpoint:** Capture baseline API response times for User + Product services (save for Week 13-14 comparison)

---

### Week 6: CI/CD Pipeline (~44 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 6 | KodeKloud: Jenkins fundamentals |
| Tue | 6 | Jenkins: Setup on EC2/EKS |
| Wed | 6 | Jenkins: Create pipeline for productservice |
| Thu | 6 | Jenkins: Add SonarQube integration |
| Fri | 6 | Jenkins: ECR push + EKS deploy stages |
| Sat | 6 | Pipeline for userservice |
| Sun | 8 | Test full CI/CD flow |

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

### Week 7: Elasticsearch Integration (~44 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 6 | Scaler L9: Typeahead design |
| Tue | 6 | Scaler L13: Elasticsearch deep dive |
| Wed | 6 | ES Docker local setup |
| Thu | 6 | Implement SearchServiceESImpl |
| Fri | 6 | Index products, test search |
| Sat | 6 | Fuzzy matching, relevance tuning |
| Sun | 8 | Deploy ES to AWS OpenSearch |

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

### Week 8: Kafka + Cart Service (~44 hours)

| Day | Hours | Task |
|-----|-------|------|
| Mon | 6 | Scaler L12: Kafka deep dive |
| Tue | 6 | Kafka Docker local setup |
| Wed | 6 | Spring Kafka basics |
| Thu | 6 | Cart Service: MongoDB setup |
| Fri | 6 | Cart Service: API implementation |
| Sat | 6 | Cart Service: Kafka producer |
| Sun | 8 | Deploy Cart Service to EKS |

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
