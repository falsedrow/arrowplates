local textplates = require("__textplates__/textplates")

local arrows = {}
for i, symbol in ipairs(textplates.types[1].symbols) do
  if string.find(symbol, "arrow_") then
    arrows[symbol] = i
  end
end

local arrow_n = table.deepcopy(data.raw["simple-entity-with-force"]["textplate-small-plastic"])
arrow_n.name = "arrowplates-small-plastic-arrow_n"
arrow_n.icon = "__textplates__/graphics/entity/plastic/arrow_n.png"
-- TODO localised_name
arrow_n.minable.result = arrow_n.name
arrow_n.picture = {
  north = arrow_n.pictures[arrows.arrow_n],
  east = arrow_n.pictures[arrows.arrow_e],
  south = arrow_n.pictures[arrows.arrow_s],
  west = arrow_n.pictures[arrows.arrow_w]
}
arrow_n.pictures = nil
data:extend({arrow_n})
