require("util")
local arrowplates = require("arrowplates")

local function get_updated_entity(type, variation)
    local symbol = arrowplates.variation_to_symbol[variation]
    if not symbol then return end
    local direction = arrowplates.symbol_to_direction[symbol]
    local new_name
    if direction % 2 == 1 then
        new_name = type .. '-arrowplates-diagonal'
        direction = direction - 1
    else
        new_name = type .. '-arrowplates-straight'
    end
    return { name = new_name, direction = direction }
end

local function replace_entity(entity, player_index, use_current_direction)
    if not entity.valid then return end

    local surface = entity.surface
    local position = entity.position
    local force = entity.force
    local name = entity.name
    local ghost_name
    if entity.name == 'entity-ghost' then
        ghost_name = entity.ghost_name
    end
    local player
    if player_index then
        player = game.players[player_index]
    end

    local update = get_updated_entity(ghost_name or name, entity.graphics_variation)
    if not update then return end
    -- When building entities, use the symbol that textplates displays. When
    -- explicitly migrating a map, adjust by the entity's rotation to fix up
    -- blueprints that were rotated before placement. This is just a heuristic,
    -- sometimes you'll get funny arrows.
    if use_current_direction then
        update.direction = (update.direction + entity.direction) % 8
    end

    local new_entity = {
        position = position,
        force = force,
        player = player,
        raise_built = true,
        direction = update.direction,
    }
    entity.destroy()
    if ghost_name then
        new_entity.name = 'entity-ghost'
        new_entity.ghost_name = update.name
    else
        new_entity.name = update.name
    end
    surface.create_entity(new_entity)
end

local function on_built_entity(event)
    replace_entity(event.created_entity, event.player_index, false)
end

local built_entity_filter = {}
for _, type in pairs(arrowplates.types) do
    table.insert(built_entity_filter, { filter = 'name', name = type.name })
    table.insert(built_entity_filter, { filter = 'ghost_name', name = type.name })
end
script.on_event(defines.events.on_built_entity, on_built_entity,
    built_entity_filter)

-- Normally on_built_entity is enough, but textplates replaces ghosts without
-- raise_built. The ghost will be a basic textplate entity and we
-- turn it into an arrow when the ghost is built.
script.on_event(defines.events.on_robot_built_entity, on_built_entity,
    built_entity_filter)

-- Similarly, update textplates arrows in blueprints. They could come
-- from pre-existing arrows on the map, or from placing a ghost (as with
-- on_robot_built_entity above).
--
-- For copy and paste, there's a temporary blueprint in hand attack on_player_setup_blueprint.
-- For a blueprint selection tool, the blueprint doesn't exist until on_player_configured_blueprint.
local function on_blueprint(event)
    local player = game.players[event.player_index]
    local blueprint = player.cursor_stack
    if not blueprint or not blueprint.valid_for_read then return end
    if blueprint.is_blueprint_book then
        local inventory = blueprint.get_inventory(defines.inventory.item_main)
        if not inventory then return end
        blueprint = inventory[blueprint.active_index]
    end
    if not blueprint.is_blueprint then return end

    local textplates_set = {}
    for _, type in pairs(arrowplates.types) do
        textplates_set[type.name] = true
    end

    local entities = blueprint.get_blueprint_entities()
    if not entities then return end
    local any_updated = false
    for _, entity in pairs(entities) do
        if textplates_set[entity.name] then
            local update = get_updated_entity(entity.name, entity.variation)
            if update then
                entity.name = update.name
                entity.direction = update.direction
                any_updated = true
            end
        end
    end
    if any_updated then
        blueprint.set_blueprint_entities(entities)
    end
end
script.on_event(defines.events.on_player_setup_blueprint, on_blueprint)
script.on_event(defines.events.on_player_configured_blueprint, on_blueprint)

-- If you've been using blueprints with arrows in them, then you've probably got
-- a lot of arrows on your map that aren't facing north, and they are visually
-- not pointing at what they're supposed to. Run /migrate_arrows to fix them
-- up. This assumes the arrow would be correct if the blueprint rotation left
-- the arrow facing north - if your blueprints have a different direction, then
-- see /rotate_arrows.
local function migrate_arrows(command)
    local all_types = {}
    for _, type in pairs(arrowplates.types) do
        table.insert(all_types, type.name)
    end

    local surface = game.players[command.player_index].surface
    local entities = surface.find_entities_filtered { name = all_types }
    for _, entity in pairs(entities) do
        replace_entity(entity, command.player_index, true)
    end
    entities = surface.find_entities_filtered { name = 'entity-ghost', ghost_name = all_types }
    for _, entity in pairs(entities) do
        replace_entity(entity, command.player_index, true)
    end
end
commands.add_command("migrate_arrows", "Make all arrows on this surface rotatable.", migrate_arrows)

-- Rotate all arrowplates entities on the map.
local function rotate_arrows(command)
    local all_types = {}
    for _, type in pairs(arrowplates.types) do
        table.insert(all_types, type.name .. '-arrowplates-diagonal')
        table.insert(all_types, type.name .. '-arrowplates-straight')
    end

    local surface = game.players[command.player_index].surface
    local entities = surface.find_entities_filtered { name = all_types }
    for _, entity in pairs(entities) do
        entity.direction = (entity.direction + 2) % 8
    end
    entities = surface.find_entities_filtered { name = 'entity-ghost', ghost_name = all_types }
    for _, entity in pairs(entities) do
        entity.direction = (entity.direction + 2) % 8
    end
end
commands.add_command("rotate_arrows", "Rotate all arrowplates arrows clockwise.", rotate_arrows)
