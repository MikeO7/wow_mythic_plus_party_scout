## [1.2.1] - [Bug] Fix EditBox focus trap
Root Cause: WoW Addon `EditBox` components (like `InputBoxTemplate`) do not automatically lose focus when Enter is pressed, causing them to trap user input.
Prevention: Added handlers for `OnEnterPressed` to call `:ClearFocus()` on all relevant `EditBox` UI components.
