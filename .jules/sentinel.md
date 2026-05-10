## 2024-05-18 - [Fix `load()` bytecode vulnerability]
**Vulnerability:** `load()` was used without explicitly specifying the `"t"` (text) mode parameter, which allowed it to load and execute binary bytecode payloads provided by the user.
**Learning:** WoW uses a modified Lua engine (similar to Lua 5.2 in this regard) where `load()` accepts an optional `mode` string. If omitted, the default is `"bt"`, meaning both binary and text formats are accepted. This can lead to arbitrary code execution if the input is malicious binary bytecode instead of text.
**Prevention:** Always explicitly set the mode parameter to `"t"` when using `load()` with untrusted user input to enforce text-only evaluation.

## 2024-10-25 - [Fix Lua Error Path Disclosure]
**Vulnerability:** Internal file paths and line numbers were exposed in UI error popups when Lua execution failed.
**Learning:** The sanitization regex `^%[string \"[^\"]+\"%]:%d+:%s*` only hid chunk names (from `load()`), but failed to hide stack traces/paths when errors originated from internal module files like `Modules/Expression.lua:45:`. This leaks implementation details.
**Prevention:** Use a more comprehensive non-greedy pattern like `^.-:%d+:%s*` to catch and remove all source prefixes (chunk strings or file paths) up to the line number and error message.

## 2026-05-10 - [Fix C Stack Overflow DoS via AST Parsing]
**Vulnerability:** The expression parser and evaluator for the custom LFG filtering language were fully recursive with no depth limits. A malicious user could provide a deeply nested expression like `((...((1))...))` or `1+1+1...` causing a C stack overflow, which results in a hard WoW client crash (Denial of Service).
**Learning:** Lua's call stack is tied to the underlying C stack for function calls. Deeply nested, unrestricted recursion easily exhausts this limit. Client crashes are a critical issue in WoW Addons since it removes the user entirely from the game.
**Prevention:** Always implement an explicit depth counter and hard cap (e.g., maximum depth of 50) when processing user-supplied recursive structures like AST nodes or serialized tables to prevent stack exhaustion.
