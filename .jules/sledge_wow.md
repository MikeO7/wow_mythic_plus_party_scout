## [1.2.1] - [Bug] Fix EditBox focus trap
Root Cause: WoW Addon `EditBox` components (like `InputBoxTemplate`) do not automatically lose focus when Enter is pressed, causing them to trap user input.
Prevention: Added handlers for `OnEnterPressed` to call `:ClearFocus()` on all relevant `EditBox` UI components.

## [@project-version@] - [Bug] Fix pcall non-string error crash & string sanitization
Root Cause: In Lua, `pcall()` can return a non-string error object, leading to UI exceptions when string methods like `:find()` are called. Additionally, the error strings exposed internal chunk names (e.g. `[string "PGF_Expression"]:1:`).
Prevention: Always explicitly coerce error variables to strings using `tostring()` before performing string operations or displaying them, and use string substitution to sanitize internal module details.
## v2.0 - [Bug] HUD/Layer overlap issues\nRoot Cause: Hardcoded stratas (HIGH/FULLSCREEN) instead of relative frame levels caused UI to overlap standard WOW frames unexpectedly.\nPrevention: Set dialog frameStrata to 'DIALOG' and compute relative FrameLevel using parent:GetFrameLevel() + offset.

## [2.1.0] - [Bug] Expression Parser DoS Vulnerability
Root Cause: Deeply nested recursive functions (AST parsers / expression evaluators) could trigger C stack overflows, resulting in a hard client crash (DoS vulnerability).
Prevention: Implemented a recursion depth limit (max depth of 50) within `Modules/Expression.lua`'s `Parse` and `Evaluate` functions to throw a controlled Lua error before a C stack overflow occurs.
