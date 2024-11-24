data:extend({
    {
      type = "bool-setting",
      name = "infinite-resource-deposits",
      setting_type = "startup",
      default_value = true,
      order = "a-a"
    },
    {
      type = "double-setting",
      name = "infinite-resource-deposits-frequency",
      setting_type = "startup",
      default_value = 0.10,
      minimum_value = 0.0,
      maximum_value = 1.0,
      order = "a-b"
    },
    {
      type = "int-setting",
      name = "infinite-resource-deposits-richness",
      setting_type = "startup",
      default_value = 100,
      minimum_value = 100,
      order = "a-c"
    },
    {
      type = "int-setting",
      name = "infinite-resource-deposits-minimal-amount",
      setting_type = "startup",
      default_value = 5000,
      minimum_value = 0,
      order = "a-d"
    },
    {
      type = "bool-setting",
      name = "infinite-resource-fluids",
      setting_type = "startup",
      default_value = true,
      order = "b-a"
    },
    {
      type = "double-setting",
      name = "infinite-resource-fluids-frequency",
      setting_type = "startup",
      default_value = 0.25,
      minimum_value = 0.0,
      maximum_value = 1.0,
      order = "b-b"
    },
    {
      type = "int-setting",
      name = "infinite-resource-fluids-richness",
      setting_type = "startup",
      default_value = 100,
      minimum_value = 0,
      order = "b-c"
    },
    {
      type = "bool-setting",
      name = "cookie",
      setting_type = "startup",
      default_value = false,
      order = "c"
    }
  })