## 2024-05-19 - String Operation Bottlenecks in LFG List Updates
**Learning:** Functions like `PGF.IsMostLikelySameInstance` that perform heavy string allocations (bracket removal loops, gmatch/gsubs for tokenization) can cause significant UI stuttering when called frequently during frame updates. Since the set of instance names is small and bounded, repeated complex parsing is wasteful.
**Action:** Always lift static lookup tables (like regex pattern arrays) outside of functions to module scope to avoid re-instantiation. Use memoization (caching) via a composite string key for functions performing repetitive, deterministic, heavy string parsing when inputs have low cardinality.

## 2024-05-20 - Dynamic Lua Compilation Bottleneck in Filter Execution
**Learning:** Calling `load()` to compile Lua strings dynamically inside high-frequency loops, such as LFG list filtering which is evaluated per-search-result, causes redundant CPU overhead and can lead to UI blocking/stuttering since the expression text usually remains constant for a given filter pass.
**Action:** Always cache the compiled function object (e.g., via simple memoization checking the expression string) when executing dynamically provided expressions over collections.
## 2024-05-18 - Avoid Table and Metatable Allocations in Search Filters
**Learning:** WoW add-ons heavily rely on `OnUpdate` or frequent event triggers (like LFG search updates). Re-allocating tables, metatables, or extracting static regex numbers on *every single result* during filtering causes massive unnecessary garbage collection pressure and can stutter the UI.
**Action:** Always lift static metatables and their closures to the module scope. Use localized caches for repeated strings and pre-flatten static array loops (like keyword lookups) into single flat tables when hydrating large data structures sequentially.

## 2024-05-21 - Intermediate Table Allocations for Set Operations
**Learning:** Computing statistics like the Jaccard Index involves finding union and intersection sizes. Creating intermediate tables (like a `union` table) to hold these values creates redundant objects that are immediately discarded, increasing GC pressure and causing UI stutters in WoW addons.
**Action:** Avoid intermediate table allocations for mathematical set properties. Compute sizes and intersections iteratively directly within loops, and use mathematical formulas like the inclusion-exclusion principle (`|A U B| = |A| + |B| - |A \cap B|`) to derive secondary values without extra memory allocation.
## 2024-05-17 - Pre-allocate Metatables and Cache Session-Constant APIs
**Learning:** In World of Warcraft addons, creating objects (like tables and closures) inside high-frequency loops, such as LFG filter evaluation, causes significant garbage collection pressure which can lead to UI stuttering. Also, calling WoW APIs (`GetNormalizedRealmName`, `UnitFactionGroup`) that return session-constant data inside these loops adds cross-boundary C-call overhead unnecessarily.
**Action:** When working in paths called frequently (like `PutRaiderIOMetrics`), hoist table creations (e.g., fallback metatables or static mappings) and cache the results of static API calls in module-level local variables.
