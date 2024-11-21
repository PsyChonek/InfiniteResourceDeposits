log("InfiniteResourcesDeposits: Begin")

local copper_ore = data.raw.resource["copper-ore"]

-- AutoplaceControl
data:extend({
  {
      type = "autoplace-control",
      name = "infinite-copper-ore",
      richness = true,
      order = "a",
      category = "resource"
  }
})


local infinite_resource = table.deepcopy(copper_ore)
infinite_resource.name = "infinite-" .. copper_ore.name
-- infinite_resource.autoplace.control = "infinite-copper-ore"
infinite_resource.map_color = {r = 0.0, g = 1, b = 0.0}
-- infinite_resource.localised_name = {"entity-name.infinite-resource", {"entity-name." .. copper_ore.name}}
-- infinite_resource.infinite = true
-- infinite_resource.minimum = copper_ore.minimum or 100
-- infinite_resource.normal = copper_ore.normal or 100
-- infinite_resource.infinite_depletion_amount = 0
-- infinite_resource.minable.results = {
--     {
--         type = "item",
--         name = copper_ore.minable.result,
--         amount = 1
--     }
-- }

infinite_resource.autoplace.richness_expression = "1"
infinite_resource.autoplace.probability_expression = "1"

-- copper_ore.autoplace.richness_expression = "1"
-- copper_ore.autoplace.probability_expression = "1"

infinite_resource.autoplace.order = "a"
copper_ore.autoplace.order = "c" 

data:extend({infinite_resource})
log("InfiniteResourcesDeposits: End")

log("Copper ore: " .. serpent.block(copper_ore))
log("Infinite copper ore: " .. serpent.block(infinite_resource))
