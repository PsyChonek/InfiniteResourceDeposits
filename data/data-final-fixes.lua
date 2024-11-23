-- Add the infinite resource to the game data
local function addResource(resource, planet, control)
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

end

-- Create the common resource settings
local function createCommon (resource)
  resource.name = resource.name.."-infinite"
  resource.order = "a"
  resource.stages =
  {
    sheet =
    {
      filename = "__InfiniteResourceDeposits__/sprites/copper-ore-cookie.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 1,
      variation_count = 1
    }
  }
  resource.stage_counts = {1}
  resource.infinite = true
  resource.minimum = 100
  resource.normal = 100
  resource.infinite_depletion_amount = 0
  resource.map_color = {r=0, g=0, b=1}

  return resource
end

-- Create the resource
local function createResource(resource, planet)
  createCommon(resource)

  local smaller_patch = ""..resource.autoplace.probability_expression.." *" ..settings.startup["infinite-resource-deposits-frequency"].value
  resource.autoplace.richness_expression = settings.startup["infinite-resource-deposits-richness"].value
  resource.autoplace.probability_expression = smaller_patch
  resource.autoplace.order = "a"  

  resource.stages_effect = nil

  return resource
end

-- Create a fluid resource
local function createFluidResource(resource, planet)
  createCommon(resource)

  local smaller_patch = ""..resource.autoplace.probability_expression.." *" ..settings.startup["infinite-resource-fluids-frequency"].value
  resource.autoplace.richness_expression = settings.startup["infinite-resource-fluids-richness"].value
  resource.autoplace.probability_expression = smaller_patch
  resource.autoplace.order = "a"

  resource.stages_effect = nil

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

  log("Expression:"..serpent.block(planet.map_gen_settings.property_expression_names))

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
        -- Create a copy of the resource
        resource_infinite = createFluidResource(resource, planet)
      else
        -- Create a copy of the resource
        resource_infinite = createResource(resource, planet)
      end

      log("Adding infinite resource: "..resource_infinite.name)

      -- Add the resource to the planet
      addResource(resource_infinite, planet, nil)
    end
  end
end

