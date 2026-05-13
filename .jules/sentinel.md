## 2024-05-18 - [Fix `load()` bytecode vulnerability]
**Vulnerability:** `load()` was used without explicitly specifying the `"t"` (text) mode parameter, which allowed it to load and execute binary bytecode payloads provided by the user.
**Learning:** WoW uses a modified Lua engine (similar to Lua 5.2 in this regard) where `load()` accepts an optional `mode` string. If omitted, the default is `"bt"`, meaning both binary and text formats are accepted. This can lead to arbitrary code execution if the input is malicious binary bytecode instead of text.
**Prevention:** Always explicitly set the mode parameter to `"t"` when using `load()` with untrusted user input to enforce text-only evaluation.

## 2024-10-25 - [Fix Lua Error Path Disclosure]
**Vulnerability:** Internal file paths and line numbers were exposed in UI error popups when Lua execution failed.
**Learning:** The sanitization regex `^%[string \"[^\"]+\"%]:%d+:%s*` only hid chunk names (from `load()`), but failed to hide stack traces/paths when errors originated from internal module files like `Modules/Expression.lua:45:`. This leaks implementation details.
**Prevention:** Use a more comprehensive non-greedy pattern like `^.-:%d+:%s*` to catch and remove all source prefixes (chunk strings or file paths) up to the line number and error message.
## 2024-05-24 - [Fix DoS vulnerability in AST evaluation]
**Vulnerability:** Deeply nested recursive functions during AST parsing and evaluation (`Modules/Expression.lua`) could trigger C stack overflows that result in hard client crashes (Denial of Service).
**Learning:** In WoW addons, standard recursive parsing functions acting on user input or extreme chains (e.g. `true and true and ...`) build extremely deep trees or recursively call themselves until the stack overflows.
**Prevention:** Always implement recursion depth limits (e.g. max depth of 50) and track it across both the parsing and evaluation phases to gracefully error out rather than blowing up the stack.
