local tech = data.raw["technology"]["textplates-plastic"]
local arrow_n = table.deepcopy(data.raw["recipe"]["textplate-small-plastic"])
arrow_n.name = "arrowplates-small-plastic-arrow_n"
table.insert(tech.effects, { type = "unlock-recipe", recipe = arrow_n.name })
data:extend({arrow_n})
