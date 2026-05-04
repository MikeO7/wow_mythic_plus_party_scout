## 2024-05-18 - [Fix `load()` bytecode vulnerability]
**Vulnerability:** `load()` was used without explicitly specifying the `"t"` (text) mode parameter, which allowed it to load and execute binary bytecode payloads provided by the user.
**Learning:** WoW uses a modified Lua engine (similar to Lua 5.2 in this regard) where `load()` accepts an optional `mode` string. If omitted, the default is `"bt"`, meaning both binary and text formats are accepted. This can lead to arbitrary code execution if the input is malicious binary bytecode instead of text.
**Prevention:** Always explicitly set the mode parameter to `"t"` when using `load()` with untrusted user input to enforce text-only evaluation.

## 2024-10-25 - [Fix Lua Error Path Disclosure]
**Vulnerability:** Internal file paths and line numbers were exposed in UI error popups when Lua execution failed.
**Learning:** The sanitization regex `^%[string \"[^\"]+\"%]:%d+:%s*` only hid chunk names (from `load()`), but failed to hide stack traces/paths when errors originated from internal module files like `Modules/Expression.lua:45:`. This leaks implementation details.
**Prevention:** Use a more comprehensive non-greedy pattern like `^.-:%d+:%s*` to catch and remove all source prefixes (chunk strings or file paths) up to the line number and error message.

## 2025-05-04 - [Fix Stack Overflow in Custom Expression Parser]
**Vulnerability:** The recursive descent parser (`Modules/Expression.lua`) for LFG search filters lacked depth limits, allowing stack overflow DoS attacks from deeply nested input strings like excessive parentheses or chained negations.
**Learning:** In Lua, recursive functions without explicit depth checks can quickly exhaust the C stack space, leading to an uncatchable fatal error that hard-crashes the WoW client UI. Deeply nested tables could theoretically cause issues during `Evaluate` as well.
**Prevention:** Always implement a `depth` parameter (incremented recursively) in parsers and AST evaluation logic, raising a handled `error("expression too complex")` when a safe threshold (e.g., 50) is exceeded.
