-- script.on_event(defines.events.on_chunk_generated, function(event)
--     local surface = event.surface
--     local area = event.area

--     local ores = {
--         "iron-ore",
--         "copper-ore",
--         "coal",
--         "stone",
--         "uranium-ore",
--         "calcite",
--         "scrap",
--         "tungsten-ore"
--     }

--     -- Find all resource entities in the generated chunk
--     local resources = surface.find_entities_filtered{
--         area = area,
--         type = "resource",
--         name = ores
--     }

--     for _, resource in pairs(resources) do
--         -- Check if the resource amount exceeds 15,000
--         if resource.amount > 15000 then
--             -- Retrieve necessary properties before destroying the entity
--             local position = resource.position
--             local resource_name = resource.name
            
--             -- Destroy the existing resource
--             resource.destroy()

--             -- Create the infinite version of the resource at the same position with the same amount
--             surface.create_entity{
--                 name = "infinite-" .. resource_name,
--                 position = position,
--                 amount = 100
--             }
--         end
--     end
-- end)
