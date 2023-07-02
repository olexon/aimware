--[[ USEFUL-STUFF ]]-- 
local screen = {
    ["x"] = 0,
    ["y"] = 0,
};

local function float_to_percent(float)
    return math.floor(float * 100)
end

local function val_to_percent(val, val_max)
    return math.floor((val / val_max) * 100 + 0.5)
end

local function team_to_string(int)
    if int == 2 then
        return "RED"
    elseif int == 3 then
        return "BLU"
    end
end

local function team_to_color(int)
    if int == 2 then
        return 255, 32, 0, 255 
    elseif int == 3 then
        return 0, 190, 255, 255
    end
end

--[[ COLORS ]]--
local clr_custom_esp_box_enemy = gui.ColorEntry( "clr_custom_esp_box_enemy", "Enemy box color", 255, 32, 0, 255 )
local clr_custom_esp_box_friendly = gui.ColorEntry( "clr_custom_esp_box_friendly", "Friendly box color", 0, 190, 255, 255 )
local clr_custom_esp_items = gui.ColorEntry( "clr_custom_esp_items", "Items box color", 255, 255, 255, 255 )
local clr_custom_esp_weapons = gui.ColorEntry( "clr_custom_esp_weapons", "Weapons box color", 255, 255, 255, 255 )

--[[ SEPARATORS ]]--
gui.Text( gui.Reference( "MISC", "part 3" ), "   --------------- TF2-Essentials ---------------   " );
gui.Text( gui.Reference( "VISUALS", "Filter" ), "   --------------- TF2-Essentials ---------------   " );
gui.Text( gui.Reference( "AIMBOT", "EXTRA", "Extra" ), "   --------------- TF2-Essentials ---------------   " );

--[[ ESP-STUFF ]]
local esp_class_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_class_checkbox", "Show Class (For normal ESP!)", false );
local esp_reveal_medic_charge_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_reveal_medic_charge_checkbox", "Show Medic Charge (For normal ESP!)", false );
local esp_headsize_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_headsize_checkbox", "Head size override", false );
local esp_headsize_slider = gui.Slider( gui.Reference( "VISUALS", "Filter" ), "esp_headsize_slider", "Head size", 1.0, 0.1, 10.0 );

gui.Text( gui.Reference( "VISUALS", "Filter" ), "" );

local custom_esp_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "custom_esp_checkbox", "Custom ESP", false );
local custom_esp_enemyonly_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "custom_esp_enemyonly_checkbox", "Enemy only ESP fix", false );

gui.Text( gui.Reference( "VISUALS", "Filter" ), "^ this will fix enemy only esp showing" );
gui.Text( gui.Reference( "VISUALS", "Filter" ), "friendly buildings (only in custom esp)" );
gui.Text( gui.Reference( "VISUALS", "Filter" ), "" );

local esp_players_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_players_checkbox", "Custom players ESP", false );
local esp_players_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "Players ESP items" );
local esp_players_name_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_name_checkbox", "Name", false );
local esp_players_team_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_team_checkbox", "Team", false );
local esp_players_class_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_class_checkbox", "Class", false );
local esp_players_mediccharge_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_mediccharge_checkbox", "Medic charge", false );
local esp_players_box_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_box_checkbox", "Box", false );
local esp_players_health_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_health_checkbox", "Health", false );
local esp_players_weapon_checkbox = gui.Checkbox( esp_players_filter_multi, "esp_players_weapon_checkbox", "Weapon", false );

local esp_dispenser_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_dispenser_checkbox", "Custom dispenser ESP", false );
local esp_dispenser_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "dispenser ESP items" );
local esp_dispenser_name_checkbox = gui.Checkbox( esp_dispenser_filter_multi, "esp_dispenser_name_checkbox", "Name", false );
local esp_dispenser_team_checkbox = gui.Checkbox( esp_dispenser_filter_multi, "esp_dispenser_team_checkbox", "Team", false );
local esp_dispenser_box_checkbox = gui.Checkbox( esp_dispenser_filter_multi, "esp_dispenser_box_checkbox", "Box", false );
local esp_dispenser_health_checkbox = gui.Checkbox( esp_dispenser_filter_multi, "esp_dispenser_health_checkbox", "Health", false );
local esp_dispenser_ammo_checkbox = gui.Checkbox( esp_dispenser_filter_multi, "esp_dispenser_ammo_checkbox", "Ammo", false );

local esp_sentry_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_sentry_checkbox", "Custom sentry ESP", false );
local esp_sentry_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "sentry ESP items" );
local esp_sentry_name_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_name_checkbox", "Name", false );
local esp_sentry_team_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_team_checkbox", "Team", false );
local esp_sentry_box_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_box_checkbox", "Box", false );
local esp_sentry_health_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_health_checkbox", "Health", false );
local esp_sentry_ammo_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_ammo_checkbox", "Ammo", false );
local esp_sentry_rockets_checkbox = gui.Checkbox( esp_sentry_filter_multi, "esp_sentry_rockets_checkbox", "Rockets", false );

local esp_teleport_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_teleport_checkbox", "Custom teleport ESP", false );
local esp_teleport_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "teleport ESP items" );
local esp_teleport_name_checkbox = gui.Checkbox( esp_teleport_filter_multi, "esp_teleport_name_checkbox", "Name", false );
local esp_teleport_team_checkbox = gui.Checkbox( esp_teleport_filter_multi, "esp_teleport_team_checkbox", "Team", false );
local esp_teleport_box_checkbox = gui.Checkbox( esp_teleport_filter_multi, "esp_teleport_box_checkbox", "Box", false );
local esp_teleport_health_checkbox = gui.Checkbox( esp_teleport_filter_multi, "esp_teleport_health_checkbox", "Health", false );

local esp_projectiles_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_projectiles_checkbox", "Custom projectiles ESP", false );
local esp_projectiles_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "projectiles ESP items" );
local esp_projectiles_name_checkbox = gui.Checkbox( esp_projectiles_filter_multi, "esp_projectiles_name_checkbox", "Name", false );
local esp_projectiles_team_checkbox = gui.Checkbox( esp_projectiles_filter_multi, "esp_projectiles_team_checkbox", "Team", false );
local esp_projectiles_box_checkbox = gui.Checkbox( esp_projectiles_filter_multi, "esp_projectiles_box_checkbox", "Box", false );

local esp_weapons_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_projectiles_checkbox", "Custom weapons ESP", false );
local esp_weapons_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "weapons ESP items" );
local esp_weapons_name_checkbox = gui.Checkbox( esp_weapons_filter_multi, "esp_weapons_name_checkbox", "Name", false );
local esp_weapons_box_checkbox = gui.Checkbox( esp_weapons_filter_multi, "esp_weapons_box_checkbox", "Box", false );

local esp_items_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_items_checkbox", "Custom items ESP", false );
local esp_items_filter_multi = gui.Multibox( gui.Reference( "VISUALS", "Filter" ), "items ESP items" );
local esp_items_name_checkbox = gui.Checkbox( esp_items_filter_multi, "esp_items_name_checkbox", "Name", false );
local esp_items_box_checkbox = gui.Checkbox( esp_items_filter_multi, "esp_items_box_checkbox", "Box", false );

--[[ SPECTATORS-STUFF ]]--
local spectators_checkbox = gui.Checkbox( gui.Reference( "MISC", "part 3" ), "spectators_checkbox", "Spectator List (required for aim disabler)", false );
local spectators_aim_disable_checkbox = gui.Checkbox( gui.Reference( "MISC", "part 3" ), "spectators_aim_disable_checkbox", "Disable Aim When Spectated", false );

local aim_disable_modes_multi = gui.Multibox( gui.Reference( "MISC", "part 3" ), "Disable Conditions" );
local aim_disable_in_first_checkbox = gui.Checkbox( aim_disable_modes_multi, "aim_disable_in_first_checkbox", "Spectated in firstperson", false );
local aim_disable_in_third_checkbox = gui.Checkbox( aim_disable_modes_multi, "aim_disable_in_first_checkbox", "Spectated in thirdperson", false );

--[[ OTHER ]]--
local autobackstab_checkbox = gui.Checkbox( gui.Reference( "AIMBOT", "EXTRA", "Extra" ), "autobackstab_checkbox", "Auto backstab", false );
local autobackstab_key = gui.Keybox( gui.Reference( "AIMBOT", "EXTRA", "Extra" ), "autobackstab_key", "Auto backstab key", 0 );
local autobackstab_fov_slider = gui.Slider( gui.Reference( "AIMBOT", "EXTRA", "Extra" ), "autobackstab_fov_slider", "Auto backstab fov", 1, 1, 90 );
local autobackstab_mode_combo = gui.Combobox( gui.Reference( "AIMBOT", "EXTRA", "Extra" ), "autobackstab_mode_combo", "Auto backstab mode", "Normal", "Silent" )

local obs_modes = {
    [4] = "(1st person)",
    [5] = "(3rd person)",
}

local is_spectated_in_mode = {
    firstperson = false,
    thirdperson = false,
}

local function spectators(spec_font, spec_font_items)
    local spectators_count = 0;

    local localplayer = entities.GetLocalPlayer();
    if localplayer == nil or not localplayer:IsAlive() then return end

    draw.SetFont( spec_font ); draw.Color( 255, 255, 255, 255 );
    draw.TextShadow( (screen["x"] / 2) - (draw.GetTextSize( "----- SPECTATORS -----" ) / 2), screen["y"] / 8, "----- SPECTATORS -----" );

    local players = entities.FindByClass("CTFPlayer");

    --reset before check
    is_spectated_in_mode.firstperson = false;
    is_spectated_in_mode.thirdperson = false;

    for i = 1, #players do 
        if players[i]:GetIndex() == localplayer:GetIndex() or players[i]:IsAlive() or players[i]:GetTeamNumber() ~= localplayer:GetTeamNumber() or players[i]:GetIndex() == nil or localplayer:GetIndex() == nil then goto continue end

        if players[i]:GetPropEntity("m_hObserverTarget"):GetIndex() == localplayer:GetIndex() then
            spectators_count = spectators_count + 1;

            draw.SetFont( spec_font_items );

            if players[i]:GetProp("m_iObserverMode") == 4 then
                draw.Color( 255, 50, 45, 255 );
                is_spectated_in_mode.firstperson = true;
            elseif players[i]:GetProp("m_iObserverMode") == 5 then
                draw.Color( 240, 240, 45, 255 );
                is_spectated_in_mode.thirdperson = true;
            else
                draw.Color( 255, 255, 255, 255 );
            end

            local obs = "";
            if players[i]:GetProp("m_iObserverMode") > 0 then
                obs = obs_modes[players[i]:GetProp("m_iObserverMode")] or "";
            end

            draw.TextShadow( (screen["x"] / 2) - (draw.GetTextSize( players[i]:GetName() .. " " .. obs ) / 2),
            (screen["y"] / 8) + (15 * spectators_count),
            players[i]:GetName() .. " " .. obs );
        end

        ::continue::
    end
end

local function disable_aim_when_spectated(spec_font)
    if aim_disable_in_first_checkbox:GetValue() and is_spectated_in_mode.firstperson or aim_disable_in_third_checkbox:GetValue() and is_spectated_in_mode.thirdperson then
        draw.Color( 255, 0, 0, 255 );
        draw.TextShadow( (screen["x"] / 2) - (draw.GetTextSize( "AIMBOT DISABLED" ) / 2), (screen["y"] / 8) - 15, "AIMBOT DISABLED" );

        gui.SetValue( "aim_enable", false );
    else
        gui.SetValue( "aim_enable", true );
    end
end 

local class_str = {
    [1] = "Scout",
    [3] = "Soldier",
    [7] = "Pyro",
    [4] = "Demoman",
    [6] = "Heavy",
    [9] = "Engineer",
    [5] = "Medic",
    [2] = "Sniper",
    [8] = "Spy",
}

local aim_backstab_backup = false
local aim_backstab_values = { -- index 1 = backup index 2 = backstab's settings
    ["aim_enable"] = {0, 1},
    ["aim_key"] = {0, 0},
    ["aim_togglekey"] = {0, 0},
    ["aim_fov"] = {0, nil}, --i will manually set fov based on slider's value
    ["aim_silentaim"] = {0, nil}, -- same here
    ["aim_lock"] = {0, 0},
    ["aim_smooth"] = {0, 0},
    ["aim_curve"] = {0, 0},
    ["aim_randomize"] = {0, 0},
    ["aim_backstab_only"] = {0, 1},
    ["aim_hitboxes_head"] = {0, 1},
    ["aim_hitboxes_chest"] = {0, 1},
    ["aim_hitboxes_stomach"] = {0, 1},
    ["aim_hitboxes_arms"] = {0, 1},
    ["aim_hitboxes_legs"] = {0, 1},
}

local function autobackstab()
    local localplayer = entities.GetLocalPlayer();
    if localplayer == nil or not localplayer:IsAlive() then return end

    if localplayer:GetPropInt("m_PlayerClass", "m_iClass") == 8 and autobackstab_checkbox:GetValue() then
        local active_weapon = localplayer:GetPropEntity('m_hActiveWeapon')
        if active_weapon:GetClass() == "CTFKnife" then
            if active_weapon:GetPropInt("m_bReadyToBackstab") == 257 then
                if autobackstab_key:GetValue() > 0 and not input.IsButtonDown( autobackstab_key:GetValue() ) then
                    return
                end

                for var, values in pairs(aim_backstab_values) do
                    if not aim_backstab_backup then
                        values[1] = gui.GetValue( var )
                    end
                    
                    if var == "aim_fov" then
                        gui.SetValue( var, autobackstab_fov_slider:GetValue() )
                    elseif var == "aim_silentaim" then
                        gui.SetValue( var, autobackstab_mode_combo:GetValue() )
                    else
                        gui.SetValue( var, values[2] )
                    end
                end

                aim_backstab_backup = true
            else
                if aim_backstab_backup then
                    for var, values in pairs(aim_backstab_values) do
                        gui.SetValue( var, values[1] )
                    end

                    aim_backstab_backup = false
                end
            end
        end
    end
end

local function esp_flags(esp)
    local localplayer = entities.GetLocalPlayer()
    local entity = esp:GetEntity()

    if custom_esp_checkbox:GetValue() then return end

    if entity:GetClass() == "CTFPlayer" then
        local active_weapon = entity:GetPropEntity('m_hActiveWeapon')

        if esp_class_checkbox:GetValue() then
            esp:Color(team_to_color(entity:GetTeamNumber()))
            esp:AddTextTop("Class: " .. class_str[entity:GetPropInt("m_PlayerClass", "m_iClass")])
        end

        if esp_reveal_medic_charge_checkbox:GetValue() and active_weapon:GetClass() == "CWeaponMedigun" then
            local charge_level = float_to_percent(active_weapon:GetPropFloat("NonLocalTFWeaponMedigunData", "m_flChargeLevel"))

            esp:Color(charge_level * 2.55, 255 - charge_level * 2.55, 0, 255)
            esp:AddTextBottom("Charge: " .. charge_level .. "%")
        end
    end

    ::continue_esp_flags::
end

local function headsize_override(esp)
    local entity = esp:GetEntity()

    if entity:GetClass() == "CTFPlayer" then
        if esp_headsize_checkbox:GetValue() then
            entity:SetProp("m_flHeadScale", esp_headsize_slider:GetValue())
        else
            if entity:GetPropFloat("m_flHeadScale") ~= 1.0 then
                entity:SetProp("m_flHeadScale", 1.0)
            end
        end
    end
end


local function custom_esp(esp)
    local localplayer = entities.GetLocalPlayer()
    local entity = esp:GetEntity()
    local entity_name = entity:GetName()
    local entity_health_percentage = val_to_percent(entity:GetHealth(), entity:GetMaxHealth())
    local x1, y1, x2, y2 = esp:GetRect()

    if custom_esp_enemyonly_checkbox:GetValue() and entity:GetTeamNumber() == localplayer:GetTeamNumber() then
        goto continue_custom_esp
    end

    --print(entity:GetClass())

    if esp_players_checkbox:GetValue() then
        if entity:GetClass() == "CTFPlayer" then
            local entity_active_weapon = entity:GetPropEntity('m_hActiveWeapon')
            local right_text_count = 0

            local entity_active_weapon_name = nil
            if entity_active_weapon == nil then
                entity_active_weapon_name = "Unknown"
            else
                entity_active_weapon_name = entity_active_weapon:GetName()
            end

            --[[ DRAW ]]--
            if esp_players_health_checkbox:GetValue() then
                draw.Color(255 - (2.55 * entity_health_percentage), 2.55 * entity_health_percentage, 0, 255)
                esp:AddBarLeft(entity:GetHealth() / entity:GetMaxHealth())
            end

            if esp_players_box_checkbox:GetValue() then
                if entity:GetTeamNumber() == localplayer:GetTeamNumber() then
                    draw.Color(clr_custom_esp_box_friendly:GetValue())
                else
                    draw.Color(clr_custom_esp_box_enemy:GetValue())
                end

                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            --[[ TEXT ]]--
            if esp_players_name_checkbox:GetValue() then
                draw.Color( 255, 255, 255, 255 )
                esp:AddTextTop(entity_name)
            end

            if esp_players_weapon_checkbox:GetValue() then
                draw.Color( 255, 255, 255, 255 )
                esp:AddTextBottom(entity_active_weapon_name)
            end

            if esp_players_class_checkbox:GetValue() then
                draw.Color( 255, 255, 255, 255 )
                draw.TextShadow(x2 + 3, y1 + 11 * right_text_count, class_str[entity:GetPropInt("m_PlayerClass", "m_iClass")])
                right_text_count = right_text_count + 1
            end

            if esp_players_team_checkbox:GetValue() then
                draw.Color(team_to_color(entity:GetTeamNumber()))
                draw.TextShadow(x2 + 3, y1 + 11 * right_text_count, team_to_string(entity:GetTeamNumber()))
                right_text_count = right_text_count + 1
            end

            if esp_players_mediccharge_checkbox:GetValue() and entity_active_weapon ~= nil then
                if entity_active_weapon:GetClass() == "CWeaponMedigun" then
                    local charge_level = float_to_percent(entity_active_weapon:GetPropFloat("NonLocalTFWeaponMedigunData", "m_flChargeLevel"))

                    esp:Color(charge_level * 2.55, 255 - charge_level * 2.55, 0, 255)
                    esp:AddTextTop("Charge: " .. charge_level .. "%")
                end
            end
        end
    end

    if esp_dispenser_checkbox:GetValue() then
        if entity_name == "Dispenser" then
            --[[ DRAW ]]--
            if esp_dispenser_health_checkbox:GetValue() then
                draw.Color(255 - (2.55 * entity_health_percentage), 2.55 * entity_health_percentage, 0, 255)
                esp:AddBarLeft(entity:GetHealth() / entity:GetMaxHealth())
            end

            if esp_dispenser_ammo_checkbox:GetValue() then
                draw.Color(217, 149, 67, 255)
                esp:AddBarBottom(entity:GetPropInt("m_iAmmoMetal") / 400)
            end

            if esp_dispenser_box_checkbox:GetValue() then
                if entity:GetTeamNumber() == localplayer:GetTeamNumber() then
                    draw.Color(clr_custom_esp_box_friendly:GetValue())
                else
                    draw.Color(clr_custom_esp_box_enemy:GetValue())
                end

                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            --[[ TEXT ]]--
            if esp_dispenser_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop("Dispenser")
            end

            if esp_dispenser_team_checkbox:GetValue() then
                draw.Color(team_to_color(entity:GetTeamNumber()))
                draw.TextShadow(x2 + 3, y1, team_to_string(entity:GetTeamNumber()))
            end

        end
    end

    if esp_sentry_checkbox:GetValue() then
        if entity_name == "Sentrygun" then
            --[[ DRAW ]]--
            if esp_sentry_health_checkbox:GetValue() then
                draw.Color(255 - (2.55 * entity_health_percentage), 2.55 * entity_health_percentage, 0, 255)
                esp:AddBarLeft(entity:GetHealth() / entity:GetMaxHealth())
            end

            if esp_sentry_box_checkbox:GetValue() then
                if entity:GetTeamNumber() == localplayer:GetTeamNumber() then
                    draw.Color(clr_custom_esp_box_friendly:GetValue())
                else
                    draw.Color(clr_custom_esp_box_enemy:GetValue())
                end

                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            --[[ TEXT ]]--
            if esp_sentry_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop("Sentry Gun")
            end

            if esp_sentry_team_checkbox:GetValue() then
                draw.Color(team_to_color(entity:GetTeamNumber()))
                draw.TextShadow(x2 + 3, y1, team_to_string(entity:GetTeamNumber()))
            end

            if esp_sentry_ammo_checkbox:GetValue() then
                draw.Color( 255, 255, 255, 255 )
                esp:AddTextBottom("Ammo: " .. entity:GetPropInt("m_iAmmoShells"))
            end

            if esp_sentry_rockets_checkbox:GetValue() then
                draw.Color( 255, 255, 255, 255 )
                esp:AddTextBottom("Rockets: " .. entity:GetPropInt("m_iAmmoRockets"))
            end
        end
    end

    if esp_teleport_checkbox:GetValue() then
        if entity_name == "Teleporter" then
            --[[ DRAW ]]--
            if esp_teleport_box_checkbox:GetValue() then
                if entity:GetTeamNumber() == localplayer:GetTeamNumber() then
                    draw.Color(clr_custom_esp_box_friendly:GetValue())
                else
                    draw.Color(clr_custom_esp_box_enemy:GetValue())
                end

                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            if esp_teleport_health_checkbox:GetValue() then
                draw.Color(255 - (2.55 * entity_health_percentage), 2.55 * entity_health_percentage, 0, 255)
                esp:AddBarBottom(entity:GetHealth() / entity:GetMaxHealth())
            end


            --[[ TEXT ]]--
            if esp_teleport_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop("Teleport")
            end

            if esp_teleport_team_checkbox:GetValue() then
                draw.Color(team_to_color(entity:GetTeamNumber()))
                draw.TextShadow(x2 + 3, y1, team_to_string(entity:GetTeamNumber()))
            end
        end
    end

    if esp_projectiles_checkbox:GetValue() then
        if entity_name == "Rocket" or entity_name == "Pipebomb" or entity_name == "Sticky" then
            --[[ DRAW ]]--
            if esp_projectiles_box_checkbox:GetValue() then
                if entity:GetTeamNumber() == localplayer:GetTeamNumber() then
                    draw.Color(clr_custom_esp_box_friendly:GetValue())
                else
                    draw.Color(clr_custom_esp_box_enemy:GetValue())
                end

                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            --[[ TEXT ]]--
            if esp_projectiles_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop(entity_name)
            end

            if esp_projectiles_team_checkbox:GetValue() then
                draw.Color(team_to_color(entity:GetTeamNumber()))
                esp:AddTextBottom(team_to_string(entity:GetTeamNumber()))
            end
        end
    end

    if esp_weapons_box_checkbox:GetValue() then
        if entity:GetClass() == "CTFDroppedWeapon" then
            if esp_weapons_box_checkbox:GetValue() then
                draw.Color(clr_custom_esp_weapons:GetValue())
                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            if esp_weapons_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop(entity_name)
            end
        end
    end

    if esp_items_box_checkbox:GetValue() then
        if entity_name:find("Ammopack") or entity_name:find("Medkit") then
            --[[ DRAW ]]--
            if esp_items_box_checkbox:GetValue() then
                draw.Color(clr_custom_esp_items:GetValue())
                draw.OutlinedRect( x1, y1, x2, y2 )
            end

            --[[ TEXT ]]--
            if esp_items_name_checkbox:GetValue() then
                draw.Color(255, 255, 255, 255)
                esp:AddTextTop(entity_name)
            end
        end
    end

    ::continue_custom_esp::
end

callbacks.Register("DrawESP", function(esp) 
    esp_flags(esp)
    custom_esp(esp)
    headsize_override(esp)
end)

callbacks.Register("Draw", function()
    --[[ Spec list stuff ]]--
    screen["x"], screen["y"] = draw.GetScreenSize();
    local spec_font = draw.CreateFont( "Consolas", 15, 400 );
    local spec_font_items = draw.CreateFont( "Consolas", 13, 400 );

    if spectators_checkbox:GetValue() then
        spectators(spec_font, spec_font_items);

        if spectators_aim_disable_checkbox:GetValue() then
            disable_aim_when_spectated(spec_font)
        end
    end

    --[[ Custom esp check ]]--
    if custom_esp_checkbox:GetValue() then
        local esp_items_toggles = {
            ["esp_box"] = 0,
            ["esp_health"] = 0,
            ["esp_weapon"] = 0,
            ["esp_name"] = 0,
            ["esp_players"] = 1,
            ["esp_weapons"] = 1,
            ["esp_buildings"] = 1,
            ["esp_projectiles"] = 1,
            ["esp_stickies"] = 1,
            ["esp_items"] = 1,
        }

        for var, value in pairs(esp_items_toggles) do
            gui.SetValue( var, value )
        end
    end
end)

callbacks.Register( "CreateMove", function() 
    autobackstab()
end)