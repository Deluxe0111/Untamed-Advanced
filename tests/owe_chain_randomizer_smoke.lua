-- Regression: Nuzlocke Random Wild uses visible species for chain popups,
-- but keeps the native slot only for forced spawning and shiny chain odds.
bit = { band=function() return 0 end, bxor=function() return 0 end,
    rshift=function() return 0 end }
local Owe = assert(loadfile("owe.lua"))()
local messages = {}
local engine = {
  C = { OWE_SPAWNS_MAX=1, OWE_ROGUE_CHAIN=true },
  V = { roamerCount=0 },
  Follower = { ANIMS={}, animFrame=function() return 0 end },
  Data = { ATLAS={} },
  actors = { [2]={} },
  popup = function(species,count)
    messages[#messages+1] = {species=species,count=count}
  end,
}
Owe.init(engine)
-- Feraligatr (160) was assigned from an authored Rattata (19) slot.
for _=1,3 do Owe._chain.onBattleEnd("win", 160, 19) end
local visible,count,authored = Owe.chainState()
assert(visible==160 and count==3 and authored==19)
assert(#messages==1 and messages[1].species==160 and
    messages[1].count==3, "popups must show Feraligatr, not Rattata")
local nativeSlot = {species=19, minLevel=5,maxLevel=7}
assert(Owe._chain.sourceSlot({{species=21},nativeSlot})==nativeSlot,
    "forced spawn must resolve authored slot, not randomised species")
Owe._chain.onBattleEnd("win",160,19)
assert(Owe.chainState()==160 and Owe._chain.source()==19)
assert(messages[#messages].species==160 and messages[#messages].count==4)
Owe._chain.onBattleEnd("win",161,20)
assert(messages[#messages-1].species==160 and
    messages[#messages-1].count==nil,
    "a different visible species breaks the displayed chain")
assert(Owe.chainState()==161 and Owe._chain.source()==20)
Owe._chain.onBattleEnd("caught",161,20)
assert(Owe.chainState()==nil and Owe._chain.source()==nil,
    "capturing ends the visible species chain")
Owe._chain.onBattleEnd("win",19)
assert(Owe.chainState()==19 and Owe._chain.source()==19,
    "without randomisation native chains work unchanged")
print("Untamed randomized visible chain display and source-slot lookup: PASS")
