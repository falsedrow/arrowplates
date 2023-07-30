local arrow_n = table.deepcopy(data.raw["item"]["textplate-small-plastic-arrow_n"])
arrow_n.name = "arrowplates-small-plastic-arrow_n"
arrow_n.flags = {}
arrow_n.place_result = arrow_n.name
data:extend({arrow_n})
