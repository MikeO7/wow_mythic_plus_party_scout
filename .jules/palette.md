## 2024-05-20 - EditBox Focus Management
**Learning:** WoW EditBox components can trap user keyboard input. If `OnEscapePressed` (or `OnEnterPressed`) isn't explicitly handled to call `ClearFocus()`, the user might be stuck or unexpectedly trigger the Game Menu without properly exiting the input field.
**Action:** Always add `OnEscapePressed` (and `OnEnterPressed`) script handlers to `EditBox` components that call `self:ClearFocus()` to ensure a smooth keyboard navigation experience.
## 2025-02-12 - EditBox Keyboard Trapping
**Learning:** In WoW addons, `EditBox` components can trap user keyboard input when hidden via `self:Hide()` if `ClearFocus()` is not explicitly called. This prevents players from using normal game keybinds until they manually click out of the hidden box.
**Action:** Always call `editBox:ClearFocus()` in the `OnEscapePressed` (and `OnEnterPressed`) script handlers of `EditBox` elements, regardless of whether the element is also being hidden.
## 2025-02-12 - EditBox Focus Management and Keyboard Trapping
**Learning:** Hidden `EditBox` elements in WoW addon UI continue to trap user keyboard input and prevent normal game keybind usage (e.g., movement or game menu) if they are hidden before focus is properly cleared. Using `OnEscapePressed` is necessary but not sufficient for edge cases where components are programmatically hidden.
**Action:** Always append an `OnHide` event handler (using `HookScript` securely, e.g., `element:HookScript("OnHide", function(self) self:ClearFocus() end)`) during `EditBox` element initialization to guarantee focus is cleared and game keybinds are freed regardless of how the element is hidden.
