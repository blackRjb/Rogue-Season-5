local my_utility = require("my_utility/my_utility")

local menu_elements_barrage_base =
{
    tree_tab            = tree_node:new(1),
    main_boolean        = checkbox:new(true, get_hash(my_utility.plugin_label .. "barrage_base_main_bool")),
    cast_delay_slider   = slider_float:new(0.1, 1.0, 0.1, get_hash(my_utility.plugin_label .. "barrage_cast_delay")),
}

local function menu()
    if menu_elements_barrage_base.tree_tab:push("Barrage") then
        menu_elements_barrage_base.main_boolean:render("Enable Spell", "")
        menu_elements_barrage_base.cast_delay_slider:render("Cast Delay", "Adjust the delay between casts (seconds)", 2)
        menu_elements_barrage_base.tree_tab:pop()
    end
end

local spell_id_barrage = 439762;

local spell_data_barrage = spell_data:new(
    3.0,                        -- radius
    9.0,                        -- range
    1.5,                        -- cast_delay
    3.0,                        -- projectile_speed
    true,                       -- has_collision
    spell_id_barrage,           -- spell_id
    spell_geometry.rectangular, -- geometry_type
    targeting_type.skillshot    -- targeting_type
)

local next_time_allowed_cast = 0.1;

local function logics(target)
    local menu_boolean = menu_elements_barrage_base.main_boolean:get();
    local cast_delay = menu_elements_barrage_base.cast_delay_slider:get();
    
    local is_logic_allowed = my_utility.is_spell_allowed(
                menu_boolean, 
                next_time_allowed_cast, 
                spell_id_barrage);

    if not is_logic_allowed then
        return false;
    end;

    local player_local = get_local_player();
    local player_position = get_player_position();
    local target_position = target:get_position();

    local distance_to_target = player_position:dist_to(target_position)
    if distance_to_target > spell_data_barrage.range then
        return false;
    end

    if cast_spell.target(target, spell_data_barrage, false) then
        local current_time = get_time_since_inject();
        next_time_allowed_cast = current_time + cast_delay;

        console.print("Rouge, Casted Barrage with " .. string.format("%.2f", cast_delay) .. "s delay");
        return true;
    end;
            
    return false;
end

return 
{
    menu = menu,
    logics = logics,   
}