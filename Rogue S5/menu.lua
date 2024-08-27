local my_utility = require("my_utility/my_utility")

local menu_elements_bone = {
    main_boolean = checkbox:new(true, get_hash(my_utility.plugin_label .. "main_boolean")),
    mode = combo_box:new(0, get_hash(my_utility.plugin_label .. "mode_melee_range")),
    dash_cooldown = slider_int:new(0, 6, 6, get_hash(my_utility.plugin_label .. "dash_cooldown")),
    main_tree = tree_node:new(0),
    andariels_builds = checkbox:new(false, get_hash(my_utility.plugin_label .. "andariels_builds")),
    rapide_builds = checkbox:new(false, get_hash(my_utility.plugin_label .. "rapide_builds")),
    others_builds = checkbox:new(false, get_hash(my_utility.plugin_label .. "others_builds")),
}

function menu_elements_bone:separator()
    if self.main_tree.separator then
        self.main_tree:separator()
    end
end

function menu_elements_bone:create_spell_submenu(submenu_name, spell_list)
    if self.main_tree:push(submenu_name) then
        for _, spell in ipairs(spell_list) do
            if spells[spell] then
                spells[spell]:render()
            else
                print("Warning: Spell '" .. spell .. "' not found in spells table")
            end
        end
        self.main_tree:pop()
    end
end

return menu_elements_bone