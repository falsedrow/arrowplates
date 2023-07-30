-- Load directly from textplates. This does not support mods that add additional plates because
-- the remote interface isn't available in during the data phase.
local textplates = require("__textplates__/textplates")
if not mods then textplates.build() end

local arrowplates = {}

arrowplates.symbol_to_direction = {
    ["arrow_n"] = 0,
    ["arrow_ne"] = 1,
    ["arrow_e"] = 2,
    ["arrow_se"] = 3,
    ["arrow_s"] = 4,
    ["arrow_sw"] = 5,
    ["arrow_w"] = 6,
    ["arrow_nw"] = 7,
}
arrowplates.direction_to_symbol = {}
for symbol, dir in pairs(arrowplates.symbol_to_direction) do
    arrowplates.direction_to_symbol[dir] = symbol
end

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
