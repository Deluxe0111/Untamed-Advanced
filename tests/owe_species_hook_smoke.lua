-- Pure-contract tests for the optional Untamed OWE species hook.
local Hook = assert(loadfile("owe_species_hook.lua"))()
local calls, wanted = 0, false
local spriteAvailable = true
local runtime = {
    wantsHook = function(name)
        assert(name == "untamed.owe.species")
        return wanted
    end,
    call = function(name, native, encounter, context)
        calls = calls + 1
        assert(name == "untamed.owe.species")
        assert(context.source == "untamed_advanced"
            and context.mapId == "FR_ROUTE_1"
            and context.terrain == "land"
            and context.x == 5 and context.y == 9)
        assert(encounter.species == 16 and encounter.level == 7)
        local copy = {species=25,level=encounter.level}
        return copy
    end,
}
local engine = {
    ModHooks = runtime,
    mapId = function() return "FR_ROUTE_1" end,
    Pokemon = {
        national = function(sp) return ({[16]=16,[25]=25})[sp] end,
    },
    expansionSpecies = function(sp, personality)
        assert(personality==0)
        return sp
    end,
    Gfx = { sheetFor = function(sp, female, shiny)
        return spriteAvailable and sp==25 and not female and not shiny
            and 100 or nil
    end },
}
assert(Hook.apply(engine,16,7,"land",5,9)==16
    and calls == 0,"no hook must leave native OWE unchanged")
wanted=true
assert(Hook.apply(engine,16,7,"land",5,9)==25 and calls==1,
    "valid replacement updates sprite and eventual battle species")
spriteAvailable=false
assert(Hook.apply(engine,16,7,"land",5,9)==16,
    "missing sprite refuses replacement")
spriteAvailable=true
runtime.call=function()
    calls=calls+1
    return {species=999,level=7}
end
assert(Hook.apply(engine,16,7,"land",5,9)==16,
    "invalid Gen3 species refuses replacement")
runtime.call=function() return {species="unknown"} end
assert(Hook.apply(engine,16,7,"land",5,9)==16,
    "nonnumeric species leaves native OWE intact")
runtime.call=function() return nil end
assert(Hook.apply(engine,16,7,"land",5,9)==16,
    "missing provider result does not break spawn")
assert(Hook.apply({mapId=engine.mapId},16,7,"land",5,9)==16,
    "without shared runtime Untamed retains vanilla behaviour")
print("Untamed OWE randomiser adapter: PASS")
