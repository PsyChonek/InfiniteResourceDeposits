log("InfiniteResourcesDeposits: Begin")


local iron_ore = data.raw.resource["iron-ore"]
local copper_ore = data.raw.resource["copper-ore"]

local infinite_resource = table.deepcopy(iron_ore)
infinite_resource.name = "infinite-" .. iron_ore.name
infinite_resource.infinite = true
infinite_resource.minimum = iron_ore.minimum or 100
infinite_resource.normal = iron_ore.normal or 100
infinite_resource.infinite_depletion_amount = 0
infinite_resource.minable.results = {
    {
        type = "item",
        name = iron_ore.minable.result,
        amount = 1
    }
}
-- data:extend({infinite_resource})

-- copper_ore.autoplace.richness_expression: "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1))"
-- copper_ore.autoplace.probability_expression : "(var('control:copper-ore:size') > 0) * (clamp(var('default-copper-ore-patches'), 0, 1))"

-- (var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1))
-- (var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1)) * (distance > 50)

-- resource_autoplace_all_patches{base_density = 8,base_spots_per_km2 = 2.5,candidate_spot_count = 22,frequency_multiplier = var('control:copper-ore:frequency'),has_starting_area_placement = 1,random_spot_size_minimum = 0.25,random_spot_size_maximum = 2,regular_blob_amplitude_multiplier = 0.125,regular_patch_set_count = default_regular_resource_patch_set_count,regular_patch_set_index = 1,regular_rq_factor = 0.11,seed1 = 100,size_multiplier = var('control:copper-ore:size'),starting_blob_amplitude_multiplier = 0.125,starting_patch_set_count = default_starting_resource_patch_set_count,starting_patch_set_index = 1,starting_rq_factor = 0.17142857142857}

log("InfiniteResourcesDeposits: copper_ore.autoplace.richness_expression: " ..
  serpent.block(iron_ore.autoplace.richness_expression))
log("InfiniteResourcesDeposits: copper_ore.autoplace.probability_expression : " ..
  serpent.block(iron_ore.autoplace.probability_expression))
log("InfiniteResourcesDeposits: copper_ore.autoplace.local_expressions : " ..
  serpent.block(iron_ore.autoplace.local_expressions))

data:extend({
  {
    expression =
    "resource_autoplace_all_patches{ base_density = 8, base_spots_per_km2 = 2.5, candidate_spot_count = 22, frequency_multiplier = var('control:copper-ore:frequency'), has_starting_area_placement = 1, random_spot_size_minimum = 0.025, random_spot_size_maximum = 0.2, regular_blob_amplitude_multiplier = 0.0125, regular_patch_set_count = default_regular_resource_patch_set_count, regular_patch_set_index = 1, regular_rq_factor = 0.011, seed1 = 100, size_multiplier = var('control:copper-ore:size') * 0.1, starting_blob_amplitude_multiplier = 0.0125, starting_patch_set_count = default_starting_resource_patch_set_count, starting_patch_set_index = 1, starting_rq_factor = 0.017142857142857}",
    name = "hole-copper-ore-patches",
    type = "noise-expression",
  }
})

-- iron_ore_infinite.autoplace.richness_expression =
-- "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('hole-copper-ore-patches'))*max((1000+distance)/2600,1))"
-- iron_ore_infinite.autoplace.probability_expression =
-- "(var('control:copper-ore:size') > 0) * (clamp(var('hole-copper-ore-patches'), 0, 1))"
-- iron_ore_infinite.autoplace.order = "a"

-- copper_ore.autoplace.richness_expression = 0
-- -- "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('copper-ore-patches'))*max((1000+distance)/2600,1))"
-- copper_ore.autoplace.probability_expression = 0
-- -- "(var('control:copper-ore:size') > 0) * (clamp(var('copper-ore-patches'), 0, 1))"
-- copper_ore.autoplace.order = "b"

-- iron_ore.autoplace.richness_expression = 0
-- -- "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('copper-ore-patches'))*max((1000+distance)/2600,1))"
-- iron_ore.autoplace.probability_expression = 0
-- -- "(var('control:copper-ore:size') > 0) * (clamp(var('copper-ore-patches'), 0, 1))"
-- iron_ore.autoplace.order = "b"

-- iron_ore.name = iron_ore.name
-- iron_ore.infinite = true
-- iron_ore.minimum = iron_ore.minimum or 100
-- iron_ore.normal = iron_ore.normal or 100
-- iron_ore.infinite_depletion_amount = 0
-- iron_ore.minable.results = {
--     {
--         type = "item",
--         name = iron_ore.minable.result,
--         amount = 1
--     }
-- }

iron_ore.autoplace.order = iron_ore.autoplace.order .. "-b" 



log("InfiniteResourcesDeposits: End")
