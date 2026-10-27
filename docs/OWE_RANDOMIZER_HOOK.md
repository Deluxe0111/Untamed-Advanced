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
this hook. Encounter-chain popups and counts follow the **actual visible/battled species** (for example, Feraligatr rather than the native Rattata slot it replaces). The original authored slot is stored separately, only to preserve the increased chance to spawn that source in later encounters. Followers are
unaffected.

The hook is optional. Untamed behaves as before when nobody subscribes.
The corresponding [Nuzlocke v3.0.0-BETA](https://github.com/Deluxe0111/nuzlocke) hook connects this to **Random Wild** using the normal Nuzlocke Randomiser seed, Gen 3 species pool, and balance settings. Integration by **Deluxe0111**.
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
- Defeat repeated randomised wandering Pokémon (e.g. Feraligatr from a Rattata slot) and confirm the chain popup names **Feraligatr**, the repeat-spawn bonus works, and there are no wrong-species or crash reports.
- Repeat on FireRed, LeafGreen, Ruby, Sapphire, and Emerald with a
  disposable save.

These checks require a running ROM; the repo's headless Lua tests cover
the hook fallback/sprite-eligibility contract, not the renderer.
