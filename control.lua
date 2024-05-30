script.on_event(defines.events.on_pre_build, function(data)
    local player = game.get_player(data.player_index)
    if player == nil then return end

    local item = player.cursor_stack
    if item == nil then return elseif item.name ~= "companion" and item.name ~= "companion-mk2" then return end

    local surface = player.surface

    local existing_companions = surface.find_entities_filtered { name = "companion" }
    local existing_companions_mk2 = surface.find_entities_filtered { name = "companion-mk2" }
    local count = 0
    local max_count = settings.global["cdl-limit"].value
    for _, entity in ipairs(existing_companions) do
        count = count + 1
        if count > max_count then entity.die() end
    end
    for _, entity in ipairs(existing_companions_mk2) do
        count = count + 1
        if count > max_count then entity.die() end
    end

    if count >= max_count then
        item.clear()
        player.print("Only 4 companions are allowed at a time!")
    end
end)

script.on_event(defines.events.on_robot_built_entity, function(data)
    local item = data.created_entity
    if item.name ~= "companion" and item.name ~= "companion-mk2" then return end

    local surface = data.robot.surface
    local existing_companions = surface.find_entities_filtered { name = "companion" }
    local existing_companions_mk2 = surface.find_entities_filtered { name = "companion-mk2" }
    local count = 0
    local max_count = settings.global["cdl-limit"].value
    for _, _ in ipairs(existing_companions) do
        count = count + 1
    end
    for _, _ in ipairs(existing_companions_mk2) do
        count = count + 1
    end

    if count > max_count then
        data.created_entity.die()
        local last_user = data.robot.last_user
        if last_user == nil then return end
        last_user.print("A robot just placed a companion while the limit of 4 was already reached!")
    end
end)
