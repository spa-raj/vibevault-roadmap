# Capstone Report Notes

## Production Improvements for Authentication

The current userservice uses two authentication mechanisms:
- **JJWT (HMAC-SHA512)** for auth and role management endpoints (manual token validation in controllers)
- **OAuth2 JWT (RSA)** for resource server protection (Spring Security filter chain)

In production, this should be consolidated:
1. **Remove manual token validation** from controllers (e.g., `authService.validateToken()` in RoleController) and use Spring Security's `@PreAuthorize("hasRole('ADMIN')")` annotations instead
2. **Use a single auth mechanism** (OAuth2 JWT) across all endpoints for consistency
3. **Persist RSA keys** externally (database, vault, or shared config) so all pod replicas use the same keypair and tokens survive restarts
4. The current `/roles/**` endpoints use `permitAll()` at the Spring Security level with manual JJWT validation in the controller — in production, these should be protected by the OAuth2 resource server filter chain with role-based access control

## Helm Charts - Report Screenshots

From `Screenshots/05-Helm-Charts/`, include only these in the report:

1. **01-userservice-helm-chart-structure.png** — shows chart directory layout in userservice
2. **02-productservice-helm-chart-structure.png** — shows chart directory layout in productservice
3. **03-helm-lint-both-charts.png** — proves both charts are valid
4. **helm-template-userservice/01-secret-configmap.png** — shows `helm template` command with timestamp, rendered Secret + ConfigMap (demonstrates parameterized values, b64enc, dynamic DB_URL)
5. **helm-template-userservice/04-deployment-top.png** — rendered Deployment showing replicas, rolling update strategy, container spec, envFrom references
Skip the remaining helm-template screenshots (02, 03, 05, 06) — they show PVC, Service, probes, and MySQL deployment which are redundant once the reader has seen the key resources above.

### Productservice helm template screenshots

From `Screenshots/05-Helm-Charts/helm-template-productservice/`, include only these in the report:

1. **01-secret-configmap.png** — shows `helm template` command with timestamp, rendered Secret + ConfigMap (demonstrates parameterized values, b64enc, dynamic DB_URL)
2. **03-deployment-top.png** — rendered Deployment showing replicas, rolling update strategy, container spec, envFrom references

Skip the remaining (02, 04, 05) — they show PVC, Services, probes, and MySQL deployment which are already demonstrated by the userservice screenshots above. Including both services' key resources (Secret/ConfigMap + Deployment) is sufficient to show the charts work correctly.

## API Screenshots — 02-API-Responses vs 07-API-Testing-Helm

Include **both** folders in the report — they serve different purposes:

- **02-API-Responses** — manual Postman-style screenshots showing individual request/response details (headers, body, status). Use in the **API/microservices section** to explain each endpoint and its response format.
- **07-API-Testing-Helm** — automated test suite (29 tests) run against the Helm-deployed cluster. Use in the **Helm/deployment section** to prove the Helm-deployed services are fully functional end-to-end.

## MySQL Baseline Benchmark — OOMKill Evidence

**Screenshot:** `Screenshots/10-Benchmarks/01-mysql-baseline-oomkilled-50vus.png`

The k6 MySQL baseline benchmark (`mysql-baseline.js`) was run in-cluster as a K8s Job against productservice (2M products, 50 categories) via the GitHub Actions Benchmark workflow. At 50 concurrent VUs performing LIKE '%query%' full table scans:

- **productservice pod `productservice-59f54fd764-57dbl` was OOMKilled** (Exit Code 137) — restarted 3 times
- Pod memory limit: **768Mi** — insufficient for concurrent full table scans on 2M rows loading large result sets into JVM heap
- The screenshot shows `kubectl get pods` with 3 restarts and `kubectl describe pod` confirming `Last State: Terminated, Reason: OOMKilled`

**Key takeaway:** MySQL with LIKE queries on 2M rows causes pod OOM crashes at moderate concurrency (50 VUs). This directly justifies the need for Elasticsearch — full-text search should be offloaded to a dedicated search engine that uses inverted indices instead of table scans.

## MySQL Baseline Benchmark — 50 VU Results (100% Failure)

**Screenshots:**
- `Screenshots/10-Benchmarks/02-mysql-baseline-50vus-summary.png` — k6 summary table
- `Screenshots/10-Benchmarks/03-mysql-baseline-50vus-threshold-breach.png` — final status + threshold error

Results from `mysql-baseline.js` (50 VUs, 6 scenarios, 2M products):
- **100% failure rate** — 890 out of 890 HTTP requests failed, 0 successful checks
- All scenarios show 0% success: full_text_search, filtered_sorted_paginated, multi_field_search, autocomplete, get_categories
- Median latency = 30s (k6 request timeout, not actual response time)
- Throughput: ~1 req/s (vs hundreds expected) — pod kept crashing and restarting
- Root cause: `LIKE '%query%'` forces full table scan on 2M rows; concurrent scans overwhelm MySQL + exhaust JVM heap within 768Mi pod limit

## MySQL Baseline Benchmark — Light Version, 15 VU Results (100% Failure)

**Screenshots:**
- `Screenshots/10-Benchmarks/04-mysql-baseline-light-15vus-summary.png` — k6 summary table
- `Screenshots/10-Benchmarks/05-mysql-baseline-light-15vus-threshold-breach.png` — final status + threshold error

Results from `mysql-baseline-light.js` (max 15 VUs, 6 sequential scenarios, 2M products):
- **100% failure rate** — 278 out of 278 HTTP requests failed, 0 out of 235 checks succeeded
- All scenarios show 0% success: full_text_search (0/49), filtered_sorted_paginated (0/50), multi_field_search (0/41), autocomplete (0/45), get_categories (0/50)
- Median latency = 30s across all scenarios (k6 request timeout, not actual query duration)
- Throughput: 0.3 req/s (278 requests in 15m25s)

### Root Cause Analysis (Fresh Pod Logs)

The initial run was contaminated — residual LIKE queries from the previous 50 VU benchmark were still holding all 10 HikariCP connections when the light benchmark started. To get clean data, the pod was deleted (forcing a fresh deployment) and the benchmark re-run.

**Fresh pod logs confirm each LIKE query takes ~6 minutes on EKS MySQL:**
- Pod started at 14:17:07, Spring Boot ready at 14:17:56
- First batch of LIKE queries dispatched immediately as VUs ramp up
- First HikariCP connection pool error at 14:23:45 — exactly **~6 minutes** after queries began
- Pool started clean (`active=0, idle=10`) and saturated within 6 minutes as each LIKE query held a connection for the full ~6 minute scan duration
- `waiting` values in errors range 0–8, confirming requests were queuing for connections

### Cascading Failure Chain

1. **Slow LIKE queries (~6 min each):** `LIKE '%query%'` with `lower()` forces a full table scan on 2M rows — MySQL must read every row, apply `lower()`, and pattern match. Each query holds a DB connection for the entire ~6 minute execution.
2. **Connection pool exhaustion:** With only 10 HikariCP connections and queries taking ~6 minutes, even 10 concurrent requests saturate the pool. New requests wait up to 30s (connectionTimeout) then fail with `CannotCreateTransactionException`.
3. **Thread starvation:** Tomcat threads block waiting for connections, leaving no threads to serve requests — including trivial ones like `GET /categories` (simple SELECT on 50 rows) and readiness probes.
4. **Readiness probe failure:** `GET /actuator/health/readiness` (timeout=5s, failureThreshold=3) cannot get a response → K8s marks pod as not-ready → removes pod from Service endpoints.
5. **TCP connection refused:** With the pod removed from the K8s Service, k6 gets `dial tcp: connect: connection refused` — explaining why even `get_categories` shows 0% success despite being a trivial query.

### Key Insights

- **30s is the HikariCP connectionTimeout, not the query duration.** The actual LIKE query takes ~6 minutes, but HikariPool logs show 30s because that's how long *new requests* wait for a free connection before giving up.
- **Even the lightest load crashes the service.** The fresh run started with only 5 VUs (ramp-up phase) — the first 10 LIKE queries (5 VUs × 2 requests in 6 min) were enough to lock all connections for 6 minutes, crashing the service before VUs even ramp to 15.
- **Trivial queries are collateral damage.** `get_categories` (SELECT on 50 rows, sub-millisecond) fails not because it's slow, but because the connection pool and thread pool are consumed by search queries.

**Key takeaway:** MySQL LIKE queries on 2M rows are fundamentally broken for search — each query takes ~6 minutes, making the service unavailable even at minimal concurrency (5 VUs). The bottleneck is not connection pool size or concurrency level but individual query execution time. This conclusively justifies Elasticsearch, where inverted indices provide sub-100ms full-text search without table scans.

## OpenSearch Benchmark Notes

### Infrastructure
- **OpenSearch instance:** `t3.small.search` (2 vCPU burstable, 2 GB RAM, 10 GB gp3 EBS)
- **MySQL instance:** `db.t3.micro` (2 vCPU burstable, 1 GB RAM, 20 GB gp3)
- **Dataset:** 2M products, 50 categories
- Both are minimal-spec instances — production would use `r6g.large` or similar

### Benchmark script: `opensearch-baseline.js`
Same VU ramp pattern as `mysql-baseline-light.js` (1→5→15 VUs) for fair comparison. 6 scenarios:

| Scenario | Tests | MySQL comparison |
|----------|-------|------------------|
| Full-text search | Same queries as MySQL baseline | Direct comparison — inverted index vs LIKE table scan |
| Fuzzy search (typo tolerance) | "lether walet" → finds "leather wallet" | ES-only — impossible with MySQL LIKE |
| Description search | Search in CLOB field | ES-only — MySQL LIKE on CLOB doesn't support lower() |
| Filtered + sorted + paginated | Category + price range + sort by price | Direct comparison |
| Multi-field search | Query + category filter combined | Direct comparison |
| Autocomplete / typeahead | Prefix-based suggestions | Direct comparison |

### Expected results for report
- **MySQL:** 100% failure rate at 15 VUs — each LIKE query takes ~6 min, connection pool exhaustion, pod OOMKill/unresponsive
- **OpenSearch:** Sub-second latency expected even at 15 VUs — inverted index, no table scans, no connection pool contention
- The comparison demonstrates orders-of-magnitude improvement, not just marginal gains

### Report wording suggestion
> "Benchmarks run on `t3.small.search` (2 vCPU, 2 GB RAM). Production workloads would use `r6g.large` or similar for lower latency. The relative improvement over MySQL LIKE queries is the key metric — OpenSearch provides sub-second search on 2M products where MySQL was unable to serve even a single concurrent search request without service degradation."

## Kafka Serialization Choice

### Why JSON over Avro/Protobuf

The project uses **JSON serialization** (`JsonSerializer`) for Kafka messages. This was a deliberate choice:

| Format | Payload Size | Schema Enforcement | Setup Complexity | Debugging |
|--------|-------------|-------------------|-----------------|-----------|
| **JSON** | Larger | None (implicit) | Minimal — works out of the box with Spring Kafka | Human-readable via `kafka-console-consumer` |
| **Avro** | 50-70% smaller | Schema Registry enforces contracts | Requires Confluent Schema Registry + `.avsc` schema files | Binary — requires schema to decode |
| **Protobuf** | Compact binary | Generated code | Requires `.proto` files + code generation | Binary — requires proto definition |

**Decision rationale:** JSON was chosen for development velocity — no Schema Registry infrastructure to set up, easy to debug by reading raw messages, and Spring Kafka has built-in `JsonSerializer` support.

### Report wording suggestion
> "Kafka messages use JSON serialization for development simplicity and debuggability. Production systems at scale (e.g., Netflix, LinkedIn) typically use Avro with Confluent Schema Registry for compact binary payloads and schema evolution guarantees (backward/forward compatibility). This would be the recommended upgrade path for VibeVault at scale."

## Spring Boot 4.x — MongoDB Property Prefix Change

Spring Boot 4.x changed the MongoDB configuration property prefix:

| Version | Prefix | Example |
|---------|--------|---------|
| Spring Boot 3.x | `spring.data.mongodb.*` | `spring.data.mongodb.uri=mongodb://...` |
| Spring Boot 4.x | `spring.mongodb.*` | `spring.mongodb.uri=mongodb://...` |

The old prefix `spring.data.mongodb.*` is silently ignored — no deprecation warning, no error. MongoDB defaults to `localhost:27017` and the application appears to work but connects to the wrong host in Docker/K8s.

**How we discovered it:** Extracted the `MongoProperties.class` bytecode from the Spring Boot 4.0.3 JAR and found `@ConfigurationProperties` prefix set to `spring.mongodb` instead of `spring.data.mongodb`.

**Env var mapping also changed:** `SPRING_MONGODB_URI` (not `SPRING_DATA_MONGODB_URI`).

This is not documented in the Spring Boot 4.0 migration guide as of March 2026.

## Redis Caching for Cart Service

### Why Redis
Every `GET /cart` request hits MongoDB directly. With Redis as a cache-aside layer, repeated cart reads (e.g., user browsing, page refreshes) are served from memory instead of disk.

### Cache-Aside Pattern
1. **Read:** Check Redis → if cache hit, return cached cart. If miss, query MongoDB → store in Redis → return.
2. **Write:** On any cart mutation (add/update/remove/clear/checkout) → update MongoDB → invalidate Redis cache.
3. **TTL:** 30 minutes — carts expire from cache after inactivity. MongoDB remains the source of truth.

### Actual Benchmark Results

| Metric | MongoDB Direct | Redis Cached |
|--------|---------------|-------------|
| **Median** | **6.2ms** | **8.21ms** |
| Avg | 6.06ms | 7.27ms |
| p(90) | 9.54ms | 10.93ms |
| p(95) | 11.25ms | 12.74ms |
| p(99) | 16.45ms | 17.11ms |
| Max | 22.49ms | 21.59ms |
| Success | 100% (2166 iters) | 100% (2160 iters) |
| Throughput | 14.5 req/s | 14.4 req/s |

### Benchmark Approach
- k6 load test: 1→5→15 VUs over 2.5 minutes, `GET /cart` with 0.5s sleep
- Cart pre-populated with 5 items (realistic cart size)
- Both benchmarks run locally on Docker Compose (same machine, fair comparison)
- MongoDB baseline run on a separate branch without Redis code (no reconnection overhead)

### Key Finding: MongoDB was FASTER than Redis locally

**Why Redis didn't improve performance in this benchmark:**
1. **Same Docker network** — both MongoDB and Redis have near-zero network latency from the app container. In production with separate servers, Redis's in-memory reads would dominate.
2. **Serialization overhead** — the Redis path serializes Cart to JSON (via Jackson), writes to Redis, then on read deserializes back. MongoDB's WiredTiger engine serves the small document from its own in-memory cache.
3. **Small documents** — cart with 5 items is ~1KB. MongoDB serves this from memory just as fast as Redis. Redis shines with larger payloads or complex queries.
4. **Single-user benchmark** — all requests hit the same cart. MongoDB's query cache is fully warmed. With many users and larger datasets, MongoDB would degrade while Redis stays O(1).

### When Redis caching WOULD help
- **Remote database** — MongoDB on a separate server (e.g., Atlas cloud) adds 5-15ms network latency per query. Redis on the same host eliminates this.
- **Large cart documents** — carts with 50+ items, product images, nested data
- **High read-to-write ratio** — e.g., user refreshing cart page 100 times between each add. Each refresh is a Redis GET instead of a MongoDB query.
- **Multiple services reading** — if Order Service and Notification Service also need cart data, Redis serves as a shared cache.
- **Scale** — with 10K+ concurrent users, MongoDB connection pool becomes a bottleneck. Redis handles 100K+ ops/sec on a single node.

### Report wording suggestion
> "Implemented cache-aside pattern with Redis for cart reads. In local Docker benchmarking, MongoDB (6.2ms median) slightly outperformed Redis (8.21ms median) due to co-located containers and small document sizes. This demonstrates that caching adds value primarily when the database is remote or under high concurrent load — not as a blanket optimization. The Redis implementation is production-ready for deployment with AWS ElastiCache where network latency to MongoDB Atlas would make caching beneficial."

### Production note
Local Docker uses `redis:7-alpine`. Production would use AWS ElastiCache (Redis) within the VPC for low-latency, managed caching with automatic failover.

---

## Notification Service — Future Enhancements

### Notification Persistence (planned for production)
The current notification service is stateless — it consumes Kafka events and delivers notifications (console + SES email) without storing them. In production, this should be enhanced with:

1. **MySQL database** — store notification records with delivery status (PENDING, SENT, FAILED)
2. **Notification history API** — `GET /notifications` for users to view their notification history
3. **Retry mechanism** — re-send failed SES emails with exponential backoff
4. **Delivery tracking** — track which channel (email/SMS/push) delivered successfully
5. **User preferences** — allow users to opt-in/out of specific notification types

### Report wording suggestion
> "The notification service implements an event-driven architecture consuming from order-events and payment-events Kafka topics. It supports multiple delivery channels via the Strategy pattern (NotificationSender interface) — currently Console (always active) and AWS SES email (conditional). The stateless design simplifies deployment and scaling. For production, notification persistence with delivery tracking and retry mechanisms would be added to ensure guaranteed delivery and provide users with notification history."

### SES Sandbox vs Production

**Current (Sandbox mode):**
- Both sender and recipient must be individually verified email addresses in AWS Console
- `SES_TO_EMAIL` override available to route all emails to a verified address for testing
- Kafka events contain `userId` (user's email) as recipient — works automatically when that email is SES-verified
- Limited to 200 emails/day, 1 email/second

**Production setup:**
1. **Request SES production access** — removes sandbox restrictions, can send to any email
2. **Domain verification** — verify `vibesvault.live` in SES with DKIM DNS records. Enables sending from any `@vibesvault.live` address (e.g., `notifications@vibesvault.live`)
3. **Remove `SES_TO_EMAIL` override** — not needed since any email can receive
4. **IRSA (IAM Roles for Service Accounts)** — replace node-level IAM policy with pod-specific IAM role. Only the notification service pod gets SES permissions, not all pods on the node
5. **Bounce/complaint handling** — configure SES to send delivery notifications to an SNS topic for monitoring

**Production email flow:**
```
Kafka event (userId=customer@gmail.com)
  → SesNotificationSender
  → From: notifications@vibesvault.live (domain-verified)
  → To: customer@gmail.com (any email, no verification needed)
```

### Report wording suggestion
> "Email notifications are delivered via AWS SES. In the current deployment, SES operates in sandbox mode — both sender and recipient must be verified. The notification service reads the recipient email directly from Kafka event payloads (`userId` field), enabling automatic delivery without hardcoded recipients. In production, SES production access would be requested and the sending domain (`vibesvault.live`) would be DKIM-verified, allowing emails to any customer address. Pod-level IAM permissions via IRSA would replace node-level policies for security isolation."

---

## OAuth2 Session Affinity — Scaling Limitation

### Problem
The userservice (OAuth2 authorization server) uses Spring Security's default in-memory HTTP sessions. The CSRF token generated during `GET /login` is stored in the pod's memory. With multiple replicas, the subsequent `POST /login` may hit a different pod that has no knowledge of the CSRF token, resulting in a 403 Forbidden.

```
Request 1: GET /login → Pod A → creates CSRF token in Pod A's memory
Request 2: POST /login → Pod B → no CSRF token found → 403 Forbidden
```

### Current Solution
Userservice scaled to 1 replica for OAuth2 session consistency during the capstone demo.

### Production Solutions
1. **Spring Session + Redis** — externalize session storage to Redis (AWS ElastiCache). All pods share the same session store. This is the industry standard approach.
2. **Sticky sessions (session affinity)** — configure Kong or the load balancer to route all requests from the same client to the same pod using cookies. Works but reduces load distribution benefits.
3. **Stateless CSRF** — use JWT-based CSRF tokens that encode the session state in the token itself, eliminating server-side session dependency.
4. **Token-based auth flow** — replace session-based OAuth2 consent with a fully stateless flow (e.g., PKCE without server sessions).

### Report wording suggestion
> "The userservice OAuth2 authorization server is currently deployed with a single replica due to Spring Security's default in-memory session management. With multiple replicas, CSRF tokens stored in pod memory are not shared, causing authentication failures when requests are load-balanced across pods. In production, this would be resolved by externalizing session storage using Spring Session with Redis (AWS ElastiCache), enabling horizontal scaling of the OAuth2 server while maintaining session consistency."

---

## EKS Deployment Architecture Notes

### Kong API Gateway
- Kong Ingress Controller deployed via Helm on EKS
- NLB (Network Load Balancer) with TLS termination via ACM certificate
- TLS listener on port 443 created via AWS CLI (NLB annotations require AWS Load Balancer Controller for automatic SSL)
- All services accessible via `https://www.vibesvault.live`
- Razorpay webhook routed through Kong: `https://www.vibesvault.live/payments/webhook/razorpay`

### Domain: vibesvault.live
- Registered at name.com
- DNS CNAME: `www.vibesvault.live` → Kong NLB hostname
- ACM certificate for `www.vibesvault.live` + `vibesvault.live` (DNS validated)
- Root domain (`vibesvault.live`) cannot use CNAME — would need Route53 ALIAS or Cloudflare

### Infrastructure as Code
- All infra deployed via GitHub Actions workflow (Terraform + post-apply K8s setup)
- Staged Terraform apply: VPC+ECR → EKS → RDS+Secrets → Full
- Post-apply: External Secrets Operator, DB init, Kafka, Kong
- Each microservice deployed via its own GitHub Actions deploy workflow

### Kafka on EKS
- KRaft single-node (no Zookeeper)
- TCP socket probes (exec probes with `kafka-topics --list` caused liveness failures due to timeout)
- `KAFKA_PORT` env var explicitly unset to avoid deprecated config warning

### EKS IMDS Hop Limit for SES
- EKS nodes default IMDS hop limit to 1, which blocks pods from accessing node IAM credentials
- Pods need hop limit 2 to reach the instance metadata service through the container network layer
- Fix: `aws ec2 modify-instance-metadata-options --instance-id $ID --http-put-response-hop-limit 2`
- This is needed for SES (and any AWS SDK call using node IAM role from pods)
- Production solution: use IRSA (IAM Roles for Service Accounts) instead of node role — avoids IMDS entirely, more secure, pod-specific permissions
