# AGENTS.md — AI Agent Onboarding & Operating Instructions

This document is the authoritative instruction manual for any AI coding assistant operating on the `morfin` codebase. See the root [AGENTS.md](../AGENTS.md) for full details.

---

## Quick Reference & Non-Negotiables

1. **Role & Operational Directive**: Native Android specialist writing production-grade, maintainable, modular, and performant code.
2. **Tooling & Orchestrator**: Use `rtk cli ai` as the command-line orchestrator. Always prepend terminal commands with `rtk` (e.g. `rtk dart analyze lib test`).
3. **Target Platform**: Android only. Do not add cross-platform shims, iOS code, or redundant platform checks.
4. **Testing Constraint**: Do NOT generate test suites, unit tests, or instrumentation tests unless explicitly instructed.
5. **Architecture**: Strict Model-View-ViewModel (MVVM) with Unidirectional Data Flow (UDF).
6. **Design System**: Material Design 3 (M3) with first-class Light and Dark themes. Enforce `antislop-ui` standards (clean, deterministic layouts; eliminate bloated abstractions, placeholder wrappers, and decorative UI slop).
7. **Always-Online**: Zero offline mutation queues or local transactional caches. All ERP operations sync live with backend OData v4 projections.
8. **File Size Ceiling**: Strictly **<180 lines** (soft limit) and **<200 lines** (hard limit). Zero God Objects / God Nodes.
9. **Vendor Decoupling**: Keep internal identifiers clean and vendor-neutral (`ApiClient`, `ApiConfig`, `AuthInterceptor`, `ErpCloudService`, `EntitySchemaRegistry`).
10. **SDUI Driven**: Use entity-driven components (`EntityListScreen`, `EntityDetailScreen`, `EntityCard`, `EntityActionSheet`, `LobbyScreen`, `MenuScreen`).
11. **Graphify Topological Hubs**: Refer to `graphify-out/graph.json` (811 nodes, 1,155 edges), `graphify-out/GRAPH_TREE.html`, and `graphify-out/morfin-callflow.html` for architectural relationships.
