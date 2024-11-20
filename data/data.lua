local copper_ore = data.raw.resource["copper-ore"]

-- Infinite copper ore
local copper_ore_infinite = table.deepcopy(copper_ore)
copper_ore_infinite.name = "infinite-" .. copper_ore.name
copper_ore_infinite.infinite = true
copper_ore_infinite.minimum = 100
copper_ore_infinite.normal = 100
copper_ore_infinite.infinite_depletion_amount = 0
copper_ore_infinite.minable.results = {
  {
    type = "item",
    name = copper_ore.minable.result,
    amount = 1
  }
}

log("InfiniteResourcesDeposits: Begin")

-- copper_ore.autoplace.richness_expression: "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1))"
-- copper_ore.autoplace.probability_expression : "(var('control:copper-ore:size') > 0) * (clamp(var('default-copper-ore-patches'), 0, 1))"

-- (var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1))
-- (var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('default-copper-ore-patches'))*max((1000+distance)/2600,1)) * (distance > 50)

-- resource_autoplace_all_patches{base_density = 8,base_spots_per_km2 = 2.5,candidate_spot_count = 22,frequency_multiplier = var('control:copper-ore:frequency'),has_starting_area_placement = 1,random_spot_size_minimum = 0.25,random_spot_size_maximum = 2,regular_blob_amplitude_multiplier = 0.125,regular_patch_set_count = default_regular_resource_patch_set_count,regular_patch_set_index = 1,regular_rq_factor = 0.11,seed1 = 100,size_multiplier = var('control:copper-ore:size'),starting_blob_amplitude_multiplier = 0.125,starting_patch_set_count = default_starting_resource_patch_set_count,starting_patch_set_index = 1,starting_rq_factor = 0.17142857142857}

log("InfiniteResourcesDeposits: copper_ore.autoplace.richness_expression: " ..
  serpent.block(copper_ore.autoplace.richness_expression))
log("InfiniteResourcesDeposits: copper_ore.autoplace.probability_expression : " ..
  serpent.block(copper_ore.autoplace.probability_expression))
log("InfiniteResourcesDeposits: copper_ore.autoplace.local_expressions : " ..
  serpent.block(copper_ore.autoplace.local_expressions))


data:extend({
  {
    type = "noise-function",
    name = "resource_autoplace_all_patches_hole",
    expression = "if(has_starting_area_placement == 1, max(starting_patches, regular_patches), regular_patches)",
    local_expressions = {
      basement_value =
      "-6 * max(regular_blob_amplitude_at(regular_blob_amplitude_maximum_distance), starting_blob_amplitude)",
      blobs0 =
      "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = seed1, input_scale = 1/8, output_scale = 1} + basis_noise{x = x, y = y, seed0 = map_seed, seed1 = seed1, input_scale = 1/24, output_scale = 1}",
      double_density_distance = 1300,
      regular_blob_amplitude_maximum_distance =
      "if(has_starting_area_placement == -1,double_density_distance,double_density_distance + regular_patch_fade_in_distance)",
      regular_patch_fade_in_distance = 300,
      regular_spot_quantity_expression =
      "random_penalty_between(random_spot_size_minimum, random_spot_size_maximum, 1) * regular_spot_quantity_base_at(distance)",
      starting_amount = "20000 * base_density * (frequency_multiplier + 1) * size_multiplier",
      starting_area_spot_quantity = "starting_amount / starting_patches_split / frequency_multiplier",
      starting_blob_amplitude =
      "starting_blob_amplitude_multiplier / (pi/3 * starting_rq_factor ^ 2) * starting_area_spot_quantity ^ (1/3)",
      starting_modulation = "starting_resource_placement_radius > distance",
      regular_patches = "spot_noise_hole{distance = distance, spot_noise = spot_noise{x = x, y = y, density_expression = regular_density_at(distance), spot_quantity_expression = regular_spot_quantity_expression, spot_radius_expression = min(32, regular_rq_factor * regular_spot_quantity_expression ^ (1/3)), spot_favorability_expression = 1, seed0 = map_seed, seed1 = seed1, region_size = 1024, candidate_spot_count = candidate_spot_count, suggested_minimum_candidate_point_spacing = 45.254833995939045, skip_span = regular_patch_set_count, skip_offset = regular_patch_set_index, hard_region_target_quantity = 0, basement_value = basement_value, maximum_spot_basement_radius = 128}, region_size = 1024, exclusion_percentage = 20}",
      starting_patches = "spot_noise_hole{distance = distance, spot_noise = spot_noise{x = x, y = y, density_expression = starting_amount / (pi * starting_resource_placement_radius * starting_resource_placement_radius) * starting_modulation, spot_quantity_expression = starting_area_spot_quantity, spot_radius_expression = starting_rq_factor * starting_area_spot_quantity ^ (1/3), spot_favorability_expression = clamp((elevation_lakes - 1) / 10, 0, 1) * starting_modulation * 2 - distance / starting_resource_placement_radius + random_penalty_at(0.5, 1), seed0 = map_seed, seed1 = seed1 + 1, skip_span = starting_patch_set_count, skip_offset = starting_patch_set_index, region_size = starting_resource_placement_radius * 2, candidate_spot_count = 32, suggested_minimum_candidate_point_spacing = 32, hard_region_target_quantity = 1, basement_value = basement_value, maximum_spot_basement_radius = 128}, region_size = starting_resource_placement_radius * 2, exclusion_percentage = 30}",
      starting_patches_split = 0.5,
      starting_resource_placement_radius = 120
    },
    local_functions = {
      spot_noise_hole = {
          expression = "spot_noise * if(distance > (region_size * exclusion_percentage / 100), 1, 0)",
          parameters = {
              "distance",              -- Distance from the center
              "spot_noise",            -- Original spot noise value
              "region_size",           -- Region size (e.g., 1024)
              "exclusion_percentage"   -- Percentage of the region radius to exclude
          }
      },
      regular_blob_amplitude_at = {
        expression =
        "regular_blob_amplitude_multiplier * min(regular_spot_height_typical_at(regular_blob_amplitude_maximum_distance),regular_spot_height_typical_at(distance))",
        parameters = {
          "distance"
        }
      },
      regular_density_at = {
        expression =
        "base_density * frequency_multiplier * size_multiplier * if(has_starting_area_placement == -1, 1, clamp((distance - starting_resource_placement_radius) / regular_patch_fade_in_distance, 0, 1)) * (1 + clamp(size_effective_distance_at(distance) / double_density_distance, 0, 1))",
        parameters = {
          "distance"
        }
      },
      regular_spot_height_typical_at = {
        expression =
        "((random_spot_size_minimum + random_spot_size_maximum) / 2 * regular_spot_quantity_base_at(distance)) ^ (1/3) / (pi/3 * regular_rq_factor ^ 2)",
        parameters = {
          "distance"
        }
      },
      regular_spot_quantity_base_at = {
        expression = "1000000 / base_spots_per_km2 / frequency_multiplier * regular_density_at(distance)",
        parameters = {
          "distance"
        }
      },
      size_effective_distance_at = {
        expression = "if(has_starting_area_placement == -1, distance, distance - regular_patch_fade_in_distance)",
        parameters = {
          "distance"
        }
      }
    },
    parameters = {
      "base_density",
      "base_spots_per_km2",
      "candidate_spot_count",
      "frequency_multiplier",
      "has_starting_area_placement",
      "random_spot_size_minimum",
      "random_spot_size_maximum",
      "regular_blob_amplitude_multiplier",
      "regular_patch_set_count",
      "regular_patch_set_index",
      "regular_rq_factor",
      "seed1",
      "size_multiplier",
      "starting_blob_amplitude_multiplier",
      "starting_patch_set_count",
      "starting_patch_set_index",
      "starting_rq_factor",
      "hole_percentage",
      "max_richness_factor"
    }
  }
})

data:extend({
  {
    expression =
    "resource_autoplace_all_patches_hole{base_density = 8, base_spots_per_km2 = 2.5, candidate_spot_count = 22, frequency_multiplier = var('control:copper-ore:frequency'), has_starting_area_placement = 1, random_spot_size_minimum = 0.25, random_spot_size_maximum = 2, regular_blob_amplitude_multiplier = 0.125, regular_patch_set_count = default_regular_resource_patch_set_count, regular_patch_set_index = 1, regular_rq_factor = 0.11, seed1 = 100, size_multiplier = var('control:copper-ore:size'), starting_blob_amplitude_multiplier = 0.125, starting_patch_set_count = default_starting_resource_patch_set_count, starting_patch_set_index = 1, starting_rq_factor = 0.17142857142857, hole_percentage = 0.2, max_richness_factor = 0.9}",
    name = "hole-copper-ore-patches",
    type = "noise-expression"
  }
})



if copper_ore and copper_ore.autoplace and copper_ore.autoplace.richness_expression then
  -- Modify the richness_expression to include blending

  -- copper_ore.autoplace.richness_expression = "var('hole-copper-ore-patches')"
  -- copper_ore.autoplace.probability_expression = "1"

  copper_ore.autoplace.richness_expression =
  "(var('control:copper-ore:size') > 0) * (1*var('control:copper-ore:richness')*(var('hole-copper-ore-patches'))*max((1000+distance)/2600,1))"
  copper_ore.autoplace.probability_expression =
  "(var('control:copper-ore:size') > 0) * (clamp(var('hole-copper-ore-patches'), 0, 1))"
end

log("InfiniteResourcesDeposits: End")
