--[[ USEFUL-STUFF ]]-- 
local screen = {
    ["x"] = 0,
    ["y"] = 0,
};

local function float_to_percent(float)
    return math.floor(float * 100)
end

--[[ SEPARATORS ]]--
gui.Text( gui.Reference( "MISC", "part 3" ), "   --------------- TF2-Essentials ---------------   " );
gui.Text( gui.Reference( "VISUALS", "Filter" ), "   --------------- TF2-Essentials ---------------   " );

--[[ ESP-STUFF ]]
local esp_class_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_class_checkbox", "Show Class", false );
local esp_reveal_medic_charge_checkbox = gui.Checkbox( gui.Reference( "VISUALS", "Filter" ), "esp_reveal_medic_charge_checkbox", "Show Medic Charge", false );

--[[ SPECTATORS-STUFF ]]--
local spectators_checkbox = gui.Checkbox( gui.Reference( "MISC", "part 3" ), "spectators_checkbox", "Spectator List (required for aim disabler)", false );
local spectators_aim_disable_checkbox = gui.Checkbox( gui.Reference( "MISC", "part 3" ), "spectators_aim_disable_checkbox", "Disable Aim When Spectated", false );

local aim_disable_modes_multi = gui.Multibox( gui.Reference( "MISC", "part 3" ), "Disable Conditions" );
local aim_disable_in_first_checkbox = gui.Checkbox( aim_disable_modes_multi, "aim_disable_in_first_checkbox", "Spectated in firstperson", false );
local aim_disable_in_third_checkbox = gui.Checkbox( aim_disable_modes_multi, "aim_disable_in_first_checkbox", "Spectated in thirdperson", false );

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

        --[[
            for some reason i need to check if players[i] and localplayer isnt nil otherwise script crashes sometimes
        ]]

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
    [1] = "scout",
    [3] = "soldier",
    [7] = "pyro",
    [4] = "demoman",
    [6] = "heavy",
    [9] = "engineer",
    [5] = "medic",
    [2] = "sniper",
    [8] = "spy",
}

local function esp_flags(esp)
    local localplayer = entities.GetLocalPlayer()
    local entity = esp:GetEntity()
    local entity_name = entity:GetName()

    if entity:GetClass() == "CTFPlayer" then
        local active_weapon = entity:GetPropEntity('m_hActiveWeapon')

        if esp_class_checkbox:GetValue() then
            esp:Color(gui.GetValue("clr_esp_box_other_invis"))
            esp:AddTextTop("Class: " .. class_str[entity:GetPropInt("m_PlayerClass", "m_iClass")])
        end

        if esp_reveal_medic_charge_checkbox:GetValue() and active_weapon:GetClass() == "CWeaponMedigun" then
            local charge_level = float_to_percent(active_weapon:GetPropFloat("NonLocalTFWeaponMedigunData", "m_flChargeLevel"))

            esp:Color(charge_level * 2.55, 255 - charge_level * 2.55, 0, 255)
            esp:AddTextBottom("Charge: " .. charge_level .. "%")
        end
    end
end

callbacks.Register("DrawESP", function(esp) 
    esp_flags(esp)
end)

callbacks.Register("Draw", function()
    --[[ DRAW-STUFF ]]--
    screen["x"], screen["y"] = draw.GetScreenSize();
    local spec_font = draw.CreateFont( "Consolas", 15, 400 );
    local spec_font_items = draw.CreateFont( "Consolas", 13, 400 );

    if spectators_checkbox:GetValue() then
        spectators(spec_font, spec_font_items);

        if spectators_aim_disable_checkbox:GetValue() then
            disable_aim_when_spectated(spec_font)
        end
    end
end)