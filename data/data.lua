local ores = {
    "iron-ore",
    "copper-ore",
    "coal",
    "stone",
    "uranium-ore",
    "calcite",
    "scrap",
    "tungsten-ore"
}

for name, resource in pairs(data.raw.resource) do
    -- Skip resources that are already infinite

    -- Check if the resource is in the ores table
    for _, ore in pairs(ores) do
        if name == ore then
            -- Check if the resource amount exceeds 15,000
            if not resource.infinite then
                local infinite_resource = table.deepcopy(resource)
                infinite_resource.name = "infinite-" .. name
                infinite_resource.infinite = true
                infinite_resource.minimum = resource.minimum or 100
                infinite_resource.normal = resource.normal or 100
                infinite_resource.infinite_depletion_amount = 0
                infinite_resource.minable.results = {
                    {
                        type = "item",
                        name = resource.minable.result,
                        amount = 1
                    }
                }
                data:extend({infinite_resource})
            end
        end
    end
end
