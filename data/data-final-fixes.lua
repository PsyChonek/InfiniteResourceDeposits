-- Add the infinite resource to the game data
local function addResource(resource, planet, control, name)
  -- Add the resource to game data
  data:extend{resource}

  -- If control create autoplace_controls
  if control then
    -- Create the control if it doesn't exist
    if not data.raw["autoplace-control"][resource.name] then
      data:extend{
        control
      }
    end

    -- Add the control to the planet
    if not planet.map_gen_settings.autoplace_controls[resource.name] then
      planet.map_gen_settings.autoplace_controls[resource.name] = {}
    end
  end

  -- Auto place settings
  planet.map_gen_settings.autoplace_settings["entity"].settings[resource.name] = {}

  local expression_richness_original
  local expression_probability_smaller

  -- Create expressions for planet overrides
  if planet.map_gen_settings.property_expression_names["entity:"..name..":richness"] then
    local expression_richness = table.deepcopy(data.raw["noise-expression"][planet.name.."_"..string.gsub(name, "-", "_").."_richness"])

    expression_richness.name = planet.name.."_"..string.gsub(resource.name, "-", "_").."_richness"

    expression_richness_original = expression_richness.expression
    expression_richness.expression = settings.startup["infinite-resource-deposits-richness"].value

    data:extend{expression_richness}
    planet.map_gen_settings.property_expression_names["entity:"..resource.name..":richness"] = expression_richness.name
  end

  if planet.map_gen_settings.property_expression_names["entity:"..name..":probability"] then
    local expression_probability = table.deepcopy(data.raw["noise-expression"][planet.name.."_"..string.gsub(name, "-", "_").."_probability"])
    expression_probability.name = planet.name.."_"..string.gsub(resource.name, "-", "_").."_probability"
    expression_probability_smaller = "clamp("..expression_probability.expression..",0,1)".." * " ..settings.startup["infinite-resource-deposits-frequency"].value

    if expression_richness_original.expression
    then

      expression_probability.expression = "min("..expression_probability_smaller..", "..expression_richness_original.."-"..settings.startup["infinite-resource-deposits-minimal-amount"].value..")"
      
      -- expression_richness.local_expressions add to expression_probability.local_expressions
      if expression_richness_original.local_expressions then
        for name, local_expression in pairs(expression_richness_original.local_expressions) do
          if not expression_probability.local_expressions then
            expression_probability.local_expressions = {}
          end
          if local_expression then
            expression_probability.local_expressions[name] = local_expression
          end
        end
      end
    else
      expression_probability.expression = expression_probability_smaller
    end

    -- log("Adding expression: "..serpent.block(expression_probability))

    data:extend{expression_probability}
    planet.map_gen_settings.property_expression_names["entity:"..resource.name..":probability"] = expression_probability.name
  end
end

-- Create the common resource settings
local function createCommon (resource)
  resource.localised_name = {"entity-name."..resource.name}
  resource.name = resource.name.."-infinite"
  resource.order = "a"
  resource.infinite = true
  resource.minimum = 100
  resource.normal = 100
  resource.infinite_depletion_amount = 0

  -- Cookie
  if settings.startup["cookie"].value then
    resource.stages =
    {
      sheet =
      {
        filename = "__InfiniteResourceDeposits__/sprites/copper-ore-cookie.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 1,
        variation_count = 1,
        scale = 0.5
      }
    }
    resource.map_color = {r=0, g=0, b=1}
    resource.stages_effect = nil
  end

  resource.stage_counts = {1}

  return resource
end

-- Create the resource
local function createResource(resource)
  createCommon(resource)

  local original_richness = resource.autoplace.richness_expression

  if original_richness then
    local smaller_patch = ""..resource.autoplace.probability_expression.." * " ..settings.startup["infinite-resource-deposits-frequency"].value
    resource.autoplace.richness_expression = settings.startup["infinite-resource-deposits-richness"].value
    resource.autoplace.probability_expression = "min("..smaller_patch..", ("..original_richness..")-"..settings.startup["infinite-resource-deposits-minimal-amount"].value..")"
  end
  resource.autoplace.order = "a"

  return resource
end

-- Create a fluid resource
local function createFluidResource(resource)
  createCommon(resource)

  local smaller_patch = ""..resource.autoplace.probability_expression.." * " ..settings.startup["infinite-resource-fluids-frequency"].value
  resource.autoplace.richness_expression = settings.startup["infinite-resource-fluids-richness"].value
  resource.autoplace.probability_expression = smaller_patch
  resource.autoplace.order = "a"

  return resource
end

-- Create the autoplace control
local function createControl(resource)
  return {
    type = "autoplace-control",
    name = resource.name.."infinite",
    richness = false,
    order = "a",
    category = "resource"
  }
end

log("Adding infinite resources to planets")

for _, planet in pairs(data.raw.planet) do

  log("Processing planet: "..planet.name)

  local planetAutoplaceSettings = table.deepcopy(planet.map_gen_settings.autoplace_settings["entity"])

  -- Loop through all planets
  for name, _ in pairs(planetAutoplaceSettings.settings) do

    log("Processing resource: "..name)

    local resource = table.deepcopy(data.raw.resource[name])

    if not resource then
      log("Resource not found: "..name)
    else
      local resource_infinite

      log("Creating infinite resource: "..resource.name)
      if resource.infinite then
        if settings.startup["infinite-resource-fluids"].value then
        resource_infinite = createFluidResource(resource)
        else
          resource_infinite = resource
        end
      else      
        if settings.startup["infinite-resource-deposits"].value then
          resource_infinite = createResource(resource)
        else
          resource_infinite = resource
        end
      end

      log("Adding infinite resource: "..resource_infinite.name)

      -- Add the resource to the planet
      addResource(resource_infinite, planet, nil, name)
    end
  end

  -- log("Expression:"..serpent.block(planet.map_gen_settings.property_expression_names))

end

-- log("Data expressions:"..serpent.block(data.raw["noise-expression"]))