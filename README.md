# Untamed Advanced

A line-by-line port of pokeemerald-expansion's **Follower Pokémon** and **Overworld Wild Encounters**, plus Emerald Rogue's **encounter chaining**, for FireRed, LeafGreen, Ruby, Sapphire and Emerald on [gen1recomp](https://github.com/bryanthaboi/gen1recomp).

Same logic, same timings, same messages. If you've played a romhack with these features, this should feel exactly the same.

## What you get

- **A buddy.** Your lead Pokémon walks behind you. Talk to it and it'll tell you how it's feeling.
- **Visible wild Pokémon.** They pop up in grass and water. Some wander, some chase you, some run away. Bump into one to battle it.
- **Chaining.** Beat the same species a few times in a row to make it show up more and boost your shiny odds.
- **A matching world.** Mewtwo, Snorlax, the legendary birds and every other Pokémon already standing on the maps (Kecleon, Latias, the Regis and friends in Emerald) get the same sprites and idle animation as your buddy.

Pretty much everything can be toggled in the mod's options.

## Nuzlocke Randomiser compatibility

**Untamed Advanced works with [Nuzlocke v3.0.0-BETA](https://github.com/Deluxe0111/nuzlocke)**, including its Generation 3 **Random Wild** option.

With both compatible mods installed, turning **Random Wild ON** in Nuzlocke also randomises the Pokémon visibly wandering around the world. The Pokémon you see is the one you battle and can catch. It uses Nuzlocke's existing randomiser seed, species pool and balance settings — there is nothing extra to enable here.

- **Followers stay yours.** Your lead Pokémon and scripted/special overworld encounters are not randomised.
- **Chaining shows the actual Pokémon.** If Feraligatr appears in a native Rattata slot, defeating it counts towards a **Feraligatr** chain, not a Rattata chain. The original slot is kept internally for chain-based spawn odds.
- **Shiny Rate matches visible Pokémon.** Nuzlocke's **CLAUSES → SHINY RATE** also changes the odds of ordinary wandering Pokémon, even with Random Wild OFF. A boosted shiny is already shiny in the overworld and stays shiny in battle/capture — no surprise battle reroll. Untamed's native chain bonuses remain active.
- **No Nuzlocke required.** Untamed's usual wandering encounters and chaining still work when Nuzlocke isn't installed or Random Wild is OFF.

Compatibility integration by **[Deluxe0111](https://github.com/Deluxe0111)**. For the technical hook contract, see [Overworld Randomiser Hook](docs/OWE_RANDOMIZER_HOOK.md).

## Credits

See [CREDITS.md](CREDITS.md).
