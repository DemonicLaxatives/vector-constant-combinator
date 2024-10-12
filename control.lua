local math2d = require("__core__.lualib.math2d")

function round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function math2d.position.round(vector)
    vector = math2d.position.ensure_xy(vector)
    return {x = round(vector.x), y = round(vector.y)}
end

function math2d.position.is_zero(vector)
    vector = math2d.position.ensure_xy(vector)
    return vector.x == 0 and vector.y == 0
end


script.on_init(
    function()
        if not global.constant_vector_combinators then
            --- @type table<integer, LuaEntity>
            global.opened_entity = {}
            --- @type table<integer, integer[]>
            global.entity_sprites = {}
        end
    end)

local function illustrate_vector(entity, vector)
    if global.entity_sprites[entity.unit_number] then
        for _, id in pairs(global.entity_sprites[entity.unit_number]) do
            rendering.destroy(id)
        end
    end
    global.entity_sprites[entity.unit_number] = {}

    local player = game.get_player(entity.last_user.index)
    if not player then return end
    --- @type integer?
    local time_to_live = tonumber(settings.get_player_settings(player.index)["vector-time-to-live"].value)
    if time_to_live == 0 then
        return
    elseif time_to_live == -1 then
        time_to_live = nil
    else
        time_to_live = time_to_live * 60
    end
    
    local arrow_head =  math2d.position.add(entity.position, vector)
    
    local new_ids = {}
    if math2d.position.is_zero(vector) then return end
    local id = rendering.draw_line{
        color = {r = 0.5, g = 0, b = 1},
        width = 2,
        gap_length = 0,
        dash_length = 0,
        from = entity.position,
        to = arrow_head,
        surface = entity.surface,
        players = {player},
        time_to_live = time_to_live
    }
    table.insert(new_ids, id)
    --- Draw arrow head
    local normalized_vector = math2d.position.get_normalised(vector)
    -- local scaled_vector = math2d.position.multiply_scalar(normalized_vector, 1)
    local arrow_head_1 = math2d.position.rotate_vector(normalized_vector, 135)
    local arrow_head_2 = math2d.position.rotate_vector(normalized_vector, -135)
    
    id = rendering.draw_line{
        color = {r = 0.5, g = 0, b = 1},
        width = 2,
        gap_length = 0,
        dash_length = 0,
        from = arrow_head,
        to = math2d.position.add(arrow_head, arrow_head_1),
        surface = entity.surface,
        players = {player},
        time_to_live = time_to_live
    }
    table.insert(new_ids, id)
    id = rendering.draw_line{
        color = {r = 0.5, g = 0, b = 1},
        width = 2,
        gap_length = 0,
        dash_length = 0,
        from = arrow_head,
        to = math2d.position.add(arrow_head, arrow_head_2),
        surface = entity.surface,
        players = {player},
        time_to_live = time_to_live
    }
    table.insert(new_ids, id)

    global.entity_sprites[entity.unit_number] = new_ids
end

local function on_built_entity(e)
    local entity = e.created_entity
    if not entity then return end
    if not (entity.name == "vector-constant-combinator") then return end
    --- @type LuaConstantCombinatorControlBehavior
    local control_behavior = entity.get_or_create_control_behavior()
    if not control_behavior then return end
    local vector = {x = 0, y = 0}
    if not control_behavior.get_signal(1).signal then
        control_behavior.set_signal(1, {signal = {type = "virtual", name = "signal-X"}, count = 0})
    else
        vector.x = control_behavior.get_signal(1).count
    end
    if not control_behavior.get_signal(2).signal then
        control_behavior.set_signal(2, {signal = {type = "virtual", name = "signal-Y"}, count = 0})
    else
        vector.y = control_behavior.get_signal(2).count
    end
    illustrate_vector(entity, vector)
end

script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)

local function on_entity_destroyed(e)
    local entity = e.entity
    if not entity then return end
    if not (entity.name == "vector-constant-combinator") then return end
    if global.entity_sprites[entity.unit_number] then
        for _, id in pairs(global.entity_sprites[entity.unit_number]) do
            rendering.destroy(id)
        end
    end
    global.entity_sprites[entity.unit_number] = nil
end

script.on_event(defines.events.on_entity_died, on_entity_destroyed)
script.on_event(defines.events.on_player_mined_item, on_entity_destroyed)
script.on_event(defines.events.on_robot_mined_entity, on_entity_destroyed)

script.on_event(defines.events.on_gui_opened,
    function (e)
        local entity = e.entity
        if not entity then return end
        if not (entity.name == "vector-constant-combinator") then return end
        local player = game.get_player(e.player_index)
        if not player then return end
        global.opened_entity[e.player_index] = entity
    end)

script.on_event(defines.events.on_gui_closed,
    function (e)
        local entity = e.entity
        if not entity then return end
        if not (entity.name == "vector-constant-combinator") then return end
        local player = game.get_player(e.player_index)
        if not player then return end
        global.opened_entity[e.player_index] = nil
    end)

script.on_event(defines.events.on_console_chat,
    function (e)
        local player = game.get_player(e.player_index)
        if not player then return end
        if not global.opened_entity[e.player_index] then return end
        local entity = global.opened_entity[e.player_index]
        local position_0 = entity.position

        local message = e.message
        local x, y = string.match(message, "%[gps=(%-?%d+%.?%d*),(%-?%d+%.?%d*)%]")
        if (not x) or (not y) then return end
        x = tonumber(x)
        y = tonumber(y)
        local position_1 = {x = x, y = y}
        local vector = math2d.position.subtract(position_1, position_0)
        vector = math2d.position.round(vector)
        position_1 = math2d.position.add(position_0, vector)
        illustrate_vector(entity, vector)
        --- @type LuaConstantCombinatorControlBehavior
        local controlBehavior = entity.get_or_create_control_behavior()
        if not controlBehavior then return end
        local signal_1 = controlBehavior.get_signal(1)
        if not signal_1 then
            signal_1 = {signal = {type = "virtual", name = "signal-X"}, count = vector.x}
        else 
            signal_1.count = vector.x
        end
        local signal_2 = controlBehavior.get_signal(2)
        if not signal_2 then
            signal_2 = {signal = {type = "virtual", name = "signal-Y"}, count = vector.y}
        else
            signal_2.count = vector.y
        end
        controlBehavior.set_signal(1, signal_1)
        controlBehavior.set_signal(2, signal_2)
    end)