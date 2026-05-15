-- test_remaining_slots.lua
local mock_PGF = {
    C = {
        ROLE_REMAINING_KEYS = {
            DAMAGER = "DAMAGER_REMAINING",
            HEALER = "HEALER_REMAINING",
            TANK = "TANK_REMAINING"
        }
    },
    Table_Copy_Shallow = function(t)
        local res = {}
        if t then
            for k,v in pairs(t) do res[k] = v end
        end
        return res
    end
}

-- Global mock for WoW APIs
_G.GetNumGroupMembers = function() return 0 end
_G.IsInRaid = function() return false end

-- 1. Test case where GetSpecialization returns nil
_G.GetSpecialization = function() return nil end
_G.GetSpecializationRole = function(spec)
    assert(spec ~= nil, "GetSpecializationRole called with nil")
    return "TANK"
end

local chunk = loadfile("Modules/RemainingSlots.lua")
chunk(nil, mock_PGF)

-- Run HasRemainingSlotsForLocalPlayerRole with nil specialization
local result1 = mock_PGF.HasRemainingSlotsForLocalPlayerRole({ DAMAGER_REMAINING = 1 })
assert(result1 == true, "Expected true when DAMAGER slot is available for nil specialization")

-- Run GetPartyRoles with nil specialization
local roles1 = mock_PGF.GetPartyRoles()
assert(roles1.DAMAGER == 1, "Expected 1 DAMAGER in party roles when specialization is nil")

-- Run GetMemberCountsAfterJoin with nil specialization
local counts1 = mock_PGF.GetMemberCountsAfterJoin({ DAMAGER_REMAINING = 1 })
assert(counts1.DAMAGER == 1, "Expected 1 DAMAGER joined")
assert(counts1.DAMAGER_REMAINING == 0, "Expected DAMAGER_REMAINING to decrease by 1")

-- 2. Test case where GetSpecialization returns a valid spec
_G.GetSpecialization = function() return 102 end
_G.GetSpecializationRole = function(spec)
    assert(spec == 102, "GetSpecializationRole called with incorrect spec")
    return "HEALER"
end

-- Run HasRemainingSlotsForLocalPlayerRole with valid specialization
local result2 = mock_PGF.HasRemainingSlotsForLocalPlayerRole({ HEALER_REMAINING = 1 })
assert(result2 == true, "Expected true when HEALER slot is available for valid specialization")

-- Run GetPartyRoles with valid specialization
local roles2 = mock_PGF.GetPartyRoles()
assert(roles2.HEALER == 1, "Expected 1 HEALER in party roles when specialization is valid")

-- Run GetMemberCountsAfterJoin with valid specialization
local counts2 = mock_PGF.GetMemberCountsAfterJoin({ HEALER_REMAINING = 1 })
assert(counts2.HEALER == 1, "Expected 1 HEALER joined")
assert(counts2.HEALER_REMAINING == 0, "Expected HEALER_REMAINING to decrease by 1")

print("All tests passed!")