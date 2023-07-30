local textplates = require("__textplates__/textplates")
textplates.build()

local arrow_direction = {
    ["arrow_n"] = 0,
    ["arrow_ne"] = 1,
    ["arrow_e"] = 2,
    ["arrow_se"] = 3,
    ["arrow_s"] = 4,
    ["arrow_sw"] = 5,
    ["arrow_w"] = 6,
    ["arrow_nw"] = 7,
}
local arrow_symbols = {}
for symbol, dir in pairs(arrow_direction) do
    arrow_symbols[dir] = symbol
end

local arrow_indices = {}
local arrow_variants = {}
for i, symbol in ipairs(textplates.symbols) do
  if string.find(symbol, "arrow_") then
    arrow_variants[symbol] = i
    arrow_indices[i] = symbol
  end
end

local function rotate_arrow (event)
    entity = event.entity

    -- TODO: identify all textplates.
    if entity.prototype.name ~= "textplate-small-concrete" then
        return
    end

    -- Rotate based on the old variation, not the old direction. Base
    -- textplates arrows do not rotate, so they might have any random
    -- direction.
    local old_arrow_symbol = arrow_indices[entity.graphics_variation]
    local direction_delta = entity.direction - event.previous_direction
    local old_arrow_direction = arrow_direction[old_arrow_symbol]
    local new_arrow_direction = (old_arrow_direction + direction_delta) % 8
    local new_arrow_symbol = arrow_symbols[new_arrow_direction]
    local new_arrow_variant = arrow_variants[new_arrow_symbol]

    -- Normalize the direction to support future blueprint rotation.
    -- The entity supports four-way rotation, so assigning to direction maps
    -- northeast to north.
    -- TODO: direction and variation express the same thing. Is this supposed
    -- to be direction = 0?
    -- All of this seems silly. What about not changing direction, and always
    -- trusting the symbol? That works fine if we put something different
    -- in the blueprint.
    entity.direction = arrow_direction[new_arrow_symbol]
    entity.graphics_variation = new_arrow_variant
end

script.on_event(defines.events.on_player_rotated_entity, rotate_arrow)

-- TODO: Ok, we can rotate a placed arrow now.
-- Then we need to handle copy/rotate/paste, or blueprinting.
-- I can intercept the creation of the ghost to put down the right arrow, but
-- it's going to look absurd in rotated blueprints.
-- There are hidden items for each symbol; that doesn't help, there are no
-- entities.
-- If we create our own entities, we have to do it in data-updates, so we
-- can not use remote.call.
-- But we can look at items based on their name. So the blueprinting can
-- replace the item copied into the blueprint and out of the blueprint with
-- a custom entity, and then map that back to the generic item.

-- There are many other options. Once we assume that we can create entities,
-- we could replace the placed entity from textplates and not have to
-- intercept rotate or mess with blueprints.
-- We can even do this without messing with items or recipes by mining
-- the custom entity back into a textplate.

-- Is "blueprints work without this mod" a feature we want? not really

-- We could robustly identify textplates in control stage and log a warning
-- if we did not register the right entities.

-- I really need local source control.
