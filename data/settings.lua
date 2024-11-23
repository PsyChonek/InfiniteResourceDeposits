data:extend({
    {
      type = "double-setting",
      name = "infinite-resource-deposits-frequency",
      setting_type = "startup",
      default_value = 0.25,
      minimum_value = 0.0,
      maximum_value = 1.0,
      order = "a"
    },
    {
      type = "int-setting",
      name = "infinite-resource-deposits-richness",
      setting_type = "startup",
      default_value = 100,
      minimum_value = 100,
      order = "a"
    },
    {
      type = "double-setting",
      name = "infinite-resource-fluids-frequency",
      setting_type = "startup",
      default_value = 0.25,
      minimum_value = 0.0,
      maximum_value = 1.0,
      order = "b"
    },
    {
      type = "int-setting",
      name = "infinite-resource-fluids-richness",
      setting_type = "startup",
      default_value = 100,
      minimum_value = 0,
      order = "b"
    }
  })