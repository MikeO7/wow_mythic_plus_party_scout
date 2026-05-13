local PGF = {}
local function setup_pgf()
    -- Create a mock environment and load Util.lua
    local f, err = loadfile("Modules/Util.lua")
    if not f then error(err) end
    f(nil, PGF)
end

setup_pgf()

local function assert_eq(expected, actual, msg)
    if expected ~= actual then
        error("Assertion failed: " .. (msg or "") .. " | Expected: " .. tostring(expected) .. ", Actual: " .. tostring(actual))
    end
end

-- Test isNotArticle indirectly through PGF.IsMostLikelySameInstance

print("Running tests for PGF.IsMostLikelySameInstance ...")

-- "the" should be stripped
local res1, jaccard1 = PGF.IsMostLikelySameInstance("Wasserwerke", "die Wasserwerke")
assert_eq(true, res1, "Wasserwerke should match die Wasserwerke")
assert_eq(1, jaccard1, "Wasserwerke should have 1.0 jaccard index with die Wasserwerke")

local res2, jaccard2 = PGF.IsMostLikelySameInstance("der Wasserwerke", "Wasserwerke")
assert_eq(true, res2, "der Wasserwerke should match Wasserwerke")
assert_eq(1, jaccard2, "der Wasserwerke should have 1.0 jaccard index with Wasserwerke")

local res3, jaccard3 = PGF.IsMostLikelySameInstance("the apple", "apple")
assert_eq(true, res3, "the apple should match apple")
assert_eq(1, jaccard3, "the apple should have 1.0 jaccard index with apple")

print("All tests passed.")
