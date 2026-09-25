# AGENTS.md — AI Agent Onboarding & Operating Instructions

This document is the authoritative instruction manual for any AI coding assistant operating on the `morfin` codebase. See the root [AGENTS.md](../AGENTS.md) for full details.

---

## Quick Reference
1. **Always-Online**: Zero offline mutation queues. All ERP operations must sync live with backend OData projections.
2. **File Size Ceiling**: Strictly **<180 lines** (soft) and **<200 lines** (hard).
3. **Vendor Decoupling**: Keep internal identifiers generic (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`).
4. **RTK Prefix**: Always execute CLI commands prefixed with `rtk` (e.g. `rtk dart analyze lib test`).
5. **Graphify Topological Hubs**: Refer to `graphify-out/graph.json` and `graphify-out/GRAPH_TREE.html` for architectural relationships.
