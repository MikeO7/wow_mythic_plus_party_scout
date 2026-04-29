## 2024-05-18 - [Fix `load()` bytecode vulnerability]
**Vulnerability:** `load()` was used without explicitly specifying the `"t"` (text) mode parameter, which allowed it to load and execute binary bytecode payloads provided by the user.
**Learning:** WoW uses a modified Lua engine (similar to Lua 5.2 in this regard) where `load()` accepts an optional `mode` string. If omitted, the default is `"bt"`, meaning both binary and text formats are accepted. This can lead to arbitrary code execution if the input is malicious binary bytecode instead of text.
**Prevention:** Always explicitly set the mode parameter to `"t"` when using `load()` with untrusted user input to enforce text-only evaluation.
