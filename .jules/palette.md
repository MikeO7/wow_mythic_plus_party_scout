## 2024-05-20 - EditBox Focus Management
**Learning:** WoW EditBox components can trap user keyboard input. If `OnEscapePressed` (or `OnEnterPressed`) isn't explicitly handled to call `ClearFocus()`, the user might be stuck or unexpectedly trigger the Game Menu without properly exiting the input field.
**Action:** Always add `OnEscapePressed` (and `OnEnterPressed`) script handlers to `EditBox` components that call `self:ClearFocus()` to ensure a smooth keyboard navigation experience.
## 2025-02-12 - EditBox Keyboard Trapping
**Learning:** In WoW addons, `EditBox` components can trap user keyboard input when hidden via `self:Hide()` if `ClearFocus()` is not explicitly called. This prevents players from using normal game keybinds until they manually click out of the hidden box.
**Action:** Always call `editBox:ClearFocus()` in the `OnEscapePressed` (and `OnEnterPressed`) script handlers of `EditBox` elements, regardless of whether the element is also being hidden.
## 2025-02-12 - EditBox Focus Management OnHide
**Learning:** WoW EditBox components can trap user keyboard input when hidden via `self:Hide()` or when their parent frame is hidden if `ClearFocus()` is not explicitly called on the EditBox. This prevents players from using normal game keybinds until they manually click out of the hidden box. Adding an `OnHide` hook ensures focus is always released when the box leaves the screen.
**Action:** Always call `editBox:ClearFocus()` in the `OnHide` script handlers of `EditBox` elements (using `HookScript` to append behavior safely) to ensure a smooth keyboard navigation experience and prevent keybind trapping.
