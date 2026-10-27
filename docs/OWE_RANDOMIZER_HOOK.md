# Optional wandering Pokémon randomiser interface

Untamed-Advanced's Overworld Wild Encounters (OWE) do **not** use
`encounter.species`; they generate their own species, sprite, and battle foe.

When generating an **ordinary wild land/water OWE**, Untamed calls the shared
Gen1Recomp mod hook `untamed.owe.species` before choosing its sprite or
constructing the battle Pokémon. Other mods may use it without modifying
Untamed's actor tables.

Hook contract (Lua):

```lua
mod.hooks:wrap("untamed.owe.species", function(next, encounter, context)
    local original = next(encounter, context)
    -- original.species = native internal numeric species ID
    -- original.level   = selected native level
    -- context.source   = "untamed_advanced"
    -- context.mapId / terrain ("land" or "water") / x / y
    -- Return a fresh table with numeric species, retain the level.
    return original
end)
```

Untamed validates the returned replacement: integer internal species ID,
National Dex number 1–386, supported sprite. Invalid results revert to the
authored species without cancelling the spawn. The visible sprite, cry,
gender/shiny assessment, and eventual battle all use the **same final
internal species ID**.

Roamers, Feebas special spawns, outbreaks, and manually placed actors bypass
this hook. Native encounter chaining retains the original authored species
internally even when its visible appearance is randomised. Followers are
unaffected.

The hook is optional. Untamed behaves as before when nobody subscribes.
The corresponding Nuzlocke hook connects this to **Random Wild** using the
normal Nuzlocke Randomiser seed, Gen 3 species pool, and balance settings.
Both mod branches must be installed to enable the feature.

## In-game tests

- With both updated mods and Random Wild ON, ordinary wandering species
  should change. Their battle species must match the sprite.
- Repeat with fixed seed, reload, and different spawn locations to confirm
  mappings are stable for the same original species/map/land-water type.
- With Random Wild OFF, only native wandering Pokémon should spawn.
- Verify normal wild land/water encounters, fishing, trainer fights and
  player followers remain on their existing independent paths.
- Test a roamer, Feebas tile/outbreak where available: special species
  must remain native.
- Defeat repeated randomised wandering Pokémon and confirm encounter
  chaining still progresses without wrong-species or crash reports.
- Repeat on FireRed, LeafGreen, Ruby, Sapphire, and Emerald with a
  disposable save.

These checks require a running ROM; the repo's headless Lua tests cover
the hook fallback/sprite-eligibility contract, not the renderer.
