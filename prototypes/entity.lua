local arrowplates = require("arrowplates")

for _, type in pairs(arrowplates.types) do
  local entity = table.deepcopy(data.raw["simple-entity-with-force"][type.name])
  entity.placeable_by = {item = entity.name, count = 1}
  entity.name = entity.name .. "-arrowplates-straight"
  entity.icon = entity.pictures[arrowplates.symbol_to_variation.arrow_n].layers[1].filename
  entity.picture = {
    north = entity.pictures[arrowplates.symbol_to_variation.arrow_n],
    east = entity.pictures[arrowplates.symbol_to_variation.arrow_e],
    south = entity.pictures[arrowplates.symbol_to_variation.arrow_s],
    west = entity.pictures[arrowplates.symbol_to_variation.arrow_w]
  }
  entity.pictures = nil
  data:extend({entity})

  entity = table.deepcopy(data.raw["simple-entity-with-force"][type.name])
  entity.placeable_by = {item = entity.name, count = 1}
  entity.name = entity.name .. "-arrowplates-diagonal"
  entity.icon = entity.pictures[arrowplates.symbol_to_variation.arrow_ne].layers[1].filename
  entity.picture = {
    north = entity.pictures[arrowplates.symbol_to_variation.arrow_ne],
    east = entity.pictures[arrowplates.symbol_to_variation.arrow_se],
    south = entity.pictures[arrowplates.symbol_to_variation.arrow_sw],
    west = entity.pictures[arrowplates.symbol_to_variation.arrow_nw]
  }
  entity.pictures = nil
  data:extend({entity})
end
