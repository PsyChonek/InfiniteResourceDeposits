-- Generate settings for each Processing planet -> fluids / ores -> isEnabled, frequency, richness

local function planetSetting(planet)
  data:extend(
    {
      type = "bool-setting",
      name = "infinite-" .. planet.name .. "-resources-enabled",
      setting_type = "startup",
      default_value = true,
      order = "a"
    }
  )
end

local function createOresSetting(planet)
  data:extend(
    {
      {
        type = "double-setting",
        name = "infinite-" .. planet.name .. "-resource-deposits-frequency",
        setting_type = "startup",
        default_value = 0.25,
        minimum_value = 0.0,
        maximum_value = 1.0,
        order = "a-a"
      },
      {
        type = "int-setting",
        name = "infinite-" .. planet.name .. "-resource-deposits-richness",
        setting_type = "startup",
        default_value = 100,
        minimum_value = 100,
        order = "a-a-b"
      }
    }
  )
end

local function createFluidsSetting(planet)
  data:extend(
    {
      {
        type = "double-setting",
        name = "infinite-" .. planet.name .. "-resource-fluids-frequency",
        setting_type = "startup",
        default_value = 0.25,
        minimum_value = 0.0,
        maximum_value = 1.0,
        order = "a-b"
      },
      {
        type = "int-setting",
        name = "infinite-" .. planet.name .. "-resource-fluids-richness",
        setting_type = "startup",
        default_value = 100,
        minimum_value = 0,
        order = "a-b-b"
      }
    }
  )
end

log("raw" .. serpent.block(data.raw))


-- for _, planet in pairs(data.raw.planet) do
--   log("Processing planet: " .. planet.name)

--   -- planetSetting(planet)
--   -- createOresSetting(planet)
--   -- createFluidsSetting(planet)
-- end
