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
