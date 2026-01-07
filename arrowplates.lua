-- Load directly from textplates. This does not support mods that add additional plates because
-- the remote interface isn't available in during the data phase.
local textplates = require("__textplates__/textplates")
if not mods then textplates.build() end

local arrowplates = {}

arrowplates.symbol_to_direction = {
    ["arrow_n"] = { diagonal = false, direction = defines.direction.north},
    ["arrow_ne"] = { diagonal = true, direction = defines.direction.north},
    ["arrow_e"] = { diagonal = false, direction = defines.direction.east},
    ["arrow_se"] = { diagonal = true, direction = defines.direction.east},
    ["arrow_s"] = { diagonal = false, direction = defines.direction.south},
    ["arrow_sw"] = { diagonal = true, direction = defines.direction.south},
    ["arrow_w"] = { diagonal = false, direction = defines.direction.west},
    ["arrow_nw"] = { diagonal = true, direction = defines.direction.west},
}

arrowplates.symbol_to_variation = {}
arrowplates.variation_to_symbol = {}
for i, symbol in ipairs(textplates.symbols) do
  if string.find(symbol, "arrow_") then
    arrowplates.symbol_to_variation[symbol] = i
    arrowplates.variation_to_symbol[i] = symbol
  end
end

arrowplates.types = table.deepcopy(textplates.types)

return arrowplates
