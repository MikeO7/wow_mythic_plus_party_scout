## [1.2.0] - [Bug]
Root Cause: [API Change/Logic Error] The addon was using the restricted `loadstring()` API, which has been removed or restricted in modern WoW environments.
Prevention: [Check for InCombatLockdown / Nil Frame] Ensure that any dynamic Lua evaluation uses the modern `load()` API.
