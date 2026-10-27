-- Optional mod hook for generated overworld wild Pokemon.
-- Intentionally kept independent of the engine renderer / actor lifecycle so
-- extensions can be smoke tested and unsupported replacements fail open.
local M = {}
function M.apply(E, species, level, kind, x, y)
  local hooks = type(E) == "table" and E.ModHooks
  if type(hooks) ~= "table" or type(hooks.wantsHook) ~= "function"
      or type(hooks.call) ~= "function"
      or not hooks.wantsHook("untamed.owe.species") then return species end
  local source = { species = species, level = level }
  local ctx = { source = "untamed_advanced", mapId = E.mapId(),
    terrain = kind, x = x, y = y }
  local value = hooks.call("untamed.owe.species",
    function(original) return original end, source, ctx)
  local id = type(value) == "table" and tonumber(value.species) or nil
  if not id or id % 1 ~= 0 or id <= 0 or id == species then
    return species
  end
  -- Preserve native sprites and battles if a randomiser returns invalid IDs
  -- or visual assets are absent. Followers and scripted OWEs never come here.
  local ok, dex = pcall(E.Pokemon.national, id)
  local nat = ok and tonumber(dex)
  if not nat or nat < 1 or nat > 386 then return species end
  local gfx = E.expansionSpecies(id, 0)
  if not gfx or not E.Gfx.sheetFor(gfx, false, false) then return species end
  return id
end
return M
