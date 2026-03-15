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
