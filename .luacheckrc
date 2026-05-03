-- .luacheckrc for Mythic Plus Party Scout
std = "lua51"
codes = true

-- Exclude certain files
exclude_files = {
    "Libs/", -- If there are any libraries
}

-- Global configuration
globals = {
    "PremadeGroupsFilter",
    "PremadeGroupsFilterSettings",
    "PremadeGroupsFilterState",
}

-- Common WoW API globals (read-only)
read_globals = {
    -- FrameXML / GlobalStrings
    "_G", "math", "string", "table", "pairs", "ipairs", "select", "unpack", "tonumber", "tostring", "type", "pcall", "error", "assert", "time", "date",
    "bit", "CreateFrame", "hooksecurefunc", "GetAddOnMetadata", "RequestRaidInfo", "print", "wipe", "getmetatable", "setmetatable", "next",
    "math.floor", "math.ceil", "math.max", "math.min", "math.abs", "string.lower", "string.upper", "string.find", "string.gsub", "string.gmatch", "string.sub", "string.format", "table.insert", "table.remove", "table.sort",
    "abs", "max", "min", "floor", "ceil", "mod", "strlen", "strsub", "strlower", "strupper", "strfind", "strformat", "strtrim", "tAppendAll",
    
    -- C_ namespaces
    "C_AddOns", "C_LFGList", "C_MythicPlus", "C_PvP", "C_Timer", "C_UI", "C_XMLUtil", "C_Item", "C_ChallengeMode", "C_EventUtils",
    
    -- UI & Frames
    "UIParent", "GameTooltip", "LFGListFrame", "LFGListApplicationDialog", "PVEFrame", "SlashCmdList",
    "StaticPopup_Show", "StaticPopup_Hide", "StaticPopupDialogs", "StaticPopupSpecial_Show",
    "GroupFinderFrame", "LFGListPVEStub", "PVPQueueFrame_ShowFrame", "PVEFrame_ShowFrame", "SettingsTooltip",
    "ScrollUtil", "Settings",
    
    -- LFG related functions
    "LFGListSearchPanel_UpdateResults", "LFGListSearchPanel_DoSearch", "LFGListSearchPanel_UpdateResultList",
    "LFGListSearchPanel_UpdateButtonStatus", "LFGListSearchPanelUtil_CanSelectResult", "LFGListSearchPanel_SelectResult",
    "LFGListSearchPanel_SignUp", "LFGListApplicationDialog_UpdateRoles", "LFGListApplicationDialog_Show",
    "LFGListSearchEntry_Update", "LFGListSearchPanel_UpdateResults",
    "LFGListCategorySelection_SelectCategory", "LFGListCategorySelection_StartFindGroup",
    
    -- Enums & Constants
    "Enum", "GROUP_FINDER_CATEGORY_ID_DUNGEONS", "MAX_LFG_LIST_APPLICATIONS", "CLASS_ROLES", "RAID_CLASS_COLORS",
    "NORMAL_FONT_COLOR", "LFG_LIST_TOOLTIP_AGE", "LFG_LIST_GROUP_DATA_ROLE_ORDER", "CLASS_SORT_ORDER",
    "LFG_LIST_DELISTED_FONT_COLOR", "LFG_LIST_TOOLTIP_AUTO_ACCEPT", "WHITE_FONT_COLOR",
    "OKAY", "CANCEL", "CLOSE", "DONE",
    
    -- Helper functions
    "SecondsToTime", "GetNumSavedInstances", "GetSavedInstanceInfo", "GetSavedInstanceEncounterInfo",
    "GetAverageItemLevel", "IsShiftKeyDown", "InCombatLockdown", "GetCursorPosition", "GetBindingKey",
    "InputScrollFrame_OnLoad", "InputScrollFrame_OnTextChanged", "InputScrollFrame_OnEscapePressed",
    "InputBoxInstructions_OnTextChanged", "CreateScrollBoxListLinearView", "CreateDataProvider",
    "ipairs_reverse", "GetSpecializationRole", "GetSpecialization", "GetNumGroupMembers", "IsInRaid",
    "UnitGroupRolesAssigned", "UnitClass", "GetNormalizedRealmName", "UnitFactionGroup",
    "GetSpecializationInfoByID", "GetSpecializationInfo", "GetLocale",
    "GameTooltip_AddHighlightLine", "GameTooltip_AddNormalLine",
}

-- Ignore specific warnings
ignore = {
    "212", -- Unused argument (common in event handlers)
    "311", -- Value assigned to variable is unused
    "631", -- Line is too long
    "211/L", "211/C", "211/PGF", "211/PGFAddonName", "211/DIFFICULTY_TEXT", -- Boilerplate variables
    "432", -- Shadowing upvalue (too strict for UI code)
    "433", -- Shadowing loop variable
    "213", -- Unused loop variable (often used for indexing)
    "111", "112", -- Setting/mutating non-standard globals (Addon structure)
    "121", "122", -- Setting read-only globals/fields (Blizzard frame modifications)
    "581", -- style: 'not (x == y)' can be replaced by 'x ~= y'
}

-- Global definitions for external addons
globals = {
    "PremadeGroupsFilter",
    "PremadeGroupsFilterSettings",
    "PremadeGroupsFilterState",
    "RaiderIO",
    "RaiderIO_Profile",
    "RaiderIO_ProfileTooltip",
    "RaiderIO_Config",
    "PremadeRegions",
    "GAMEMENU_OPTIONS",
    "LFGListApplicationDialogDescription",
}

-- File specific overrides
files["Modules/MemberInfo.lua"] = {
    ignore = {"211/isLeader"},
}

files["Modules/Expression.lua"] = {
    read_globals = { "load", "setfenv" }
}
