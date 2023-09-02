local xml = gui.XML([[
<Window var="xmlmenu" name="" width="400" height="500">
    <Tab name="Ragebot">
        <Groupbox name="Main">
            <Checkbox var="rbot_rapidfire_toggle" name="Rapid Fire Toggle" value="off"/>
        </Groupbox>

        <Groupbox name="Minimum Damage">
            <Checkbox var="rbot_dmg_override" name="Override Minimum Damage" value="off"/>
            <Slider var="dmg_shared" name="Shared" min="1" max="130"/>
            <Slider var="dmg_zeus" name="Zeus" min="1" max="130"/>
            <Slider var="dmg_pistol" name="Pistol" min="1" max="130"/>
            <Slider var="dmg_hpistol" name="Heavy Pistol" min="1" max="130"/>
            <Slider var="dmg_smg" name="Submachine Gun" min="1" max="130"/>
            <Slider var="dmg_rifle" name="Rifle" min="1" max="130"/>
            <Slider var="dmg_shotgun" name="Shotgun" min="1" max="130"/>
            <Slider var="dmg_scout" name="Scout" min="1" max="130"/>
            <Slider var="dmg_asniper" name="Auto Sniper" min="1" max="130"/>
            <Slider var="dmg_sniper" name="Sniper" min="1" max="130"/>
            <Slider var="dmg_lmg" name="Light Machine Gun" min="1" max="130"/>
        </Groupbox>
    </Tab>

    <Tab name="Anti-Aim">
        <Groupbox name="Base">
            <Slider var="base_yaw" name="Yaw" min="-180" max="180"/>
            <Combobox var="base_mode" name="Mode" options=["Static", "Jitter", "flick"]/>
            <Slider var="base_mode_range" name="Jitter Range" min="1" max="90"/>
        </Groupbox>

        <Groupbox name="Left Edge">
            <Slider var="left_yaw" name="Yaw" min="-180" max="180"/>
            <Combobox var="left_mode" name="Mode" options=["Static", "Jitter", "flick"]/>
            <Slider var="left_mode_range" name="Jitter Range" min="1" max="90"/>
        </Groupbox>

        <Groupbox name="Right Edge">
            <Slider var="right_yaw" name="Yaw" min="-180" max="180"/>
            <Combobox var="right_mode" name="Mode" options=["Static", "Jitter", "flick"]/>
            <Slider var="right_mode_range" name="Jitter Range" min="1" max="90"/>
        </Groupbox>
    </Tab>
    
    <Tab name="Visuals">
        <Checkbox var="vis_watermark" name="Watermark" value="on">
            <ColorPicker var="watermark_color" value="200 40 40 255"/>
        </Checkbox>

        <Checkbox var="vis_keybinds" name="Keybinds" value="off">
    </Tab>
</Window>
]])

local ui = {
    ["menu"] = xml:Children()(),

    ["rbot_rapidfire_toggle"] = xml:Reference("rbot_rapidfire_toggle"),
    ["rbot_dmg_override"] = xml:Reference("rbot_dmg_override"),
    ["dmg_shared"] = xml:Reference("dmg_shared"),
    ["dmg_zeus"] = xml:Reference("dmg_zeus"),
    ["dmg_pistol"] = xml:Reference("dmg_pistol"),
    ["dmg_hpistol"] = xml:Reference("dmg_hpistol"),
    ["dmg_smg"] = xml:Reference("dmg_smg"),
    ["dmg_rifle"] = xml:Reference("dmg_rifle"),
    ["dmg_shotgun"] = xml:Reference("dmg_shotgun"),
    ["dmg_scout"] = xml:Reference("dmg_scout"),
    ["dmg_asniper"] = xml:Reference("dmg_asniper"),
    ["dmg_sniper"] = xml:Reference("dmg_sniper"),
    ["dmg_lmg"] = xml:Reference("dmg_lmg"),


    ["vis_watermark"] = xml:Reference("vis_watermark"),
    ["watermark_color"] = xml:Reference("vis_watermark"):Children()(),
    ["vis_keybinds"] = xml:Reference("vis_keybinds"),

    ["base_yaw"] = xml:Reference("base_yaw"),
    ["base_mode"] = xml:Reference("base_mode"),
    ["base_mode_range"] = xml:Reference("base_mode_range"),

    ["left_yaw"] = xml:Reference("left_yaw"),
    ["left_mode"] = xml:Reference("left_mode"),
    ["left_mode_range"] = xml:Reference("left_mode_range"),

    ["right_yaw"] = xml:Reference("right_yaw"),
    ["right_mode"] = xml:Reference("right_mode"),
    ["right_mode_range"] = xml:Reference("right_mode_range"),
}

local weapon_categories = {
    [1] = "shared",
    [2] = "zeus",
    [3] = "pistol",
    [4] = "hpistol",
    [5] = "smg",
    [6] = "rifle",
    [7] = "shotgun",
    [8] = "scout",
    [9] = "asniper",
    [10] = "sniper",
    [11] = "lmg",
    [12] = "knife"
}

local font = draw.CreateFont("Verdana", 15, 500)
local font2 = draw.CreateFont("Verdana", 13)

local icons = {
    ["AA"] = draw.CreateTexture(common.DecodePNG(http.Get("https://github.com/olexon/Absinthe/blob/main/svg/bg_f8f8f8-flat_750x_075_f-pad_750x1000_f8f8f8-4031151753-removebg-preview.png?raw=true"))),
}

ui.menu:SetIcon(icons.AA, 0.7)

local function strsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t = {}

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end

    return t
end

local function SetYaw(value, edge)
    if value > 180 then
        value = value - 360
    elseif value < -180 then
        value = value + 360
    end

    if edge == nil then
        edge = "base"
    end

    gui.SetValue("rbot.antiaim." .. edge, tostring(value) .. "Backward")
end

local function GetYaw(edge)
    if edge == nil then
        edge = "base"
    end

    local yaw = strsplit(gui.GetValue("rbot.antiaim." .. edge))[1]:gsub("\"", "")
    return yaw
end

local function HandleUI()
    if not gui.Reference("menu"):IsActive() and ui.menu:IsActive() then
        ui.menu:SetActive(false)
    elseif gui.Reference("menu"):IsActive() and not ui.menu:IsActive() then
        ui.menu:SetActive(true)
    end
end

local aa_stamps = {
    ["base"] = 0,
    ["left"] = 0,
    ["right"] = 0,
}

local function AntiAim()
    --BASE
    if ui.base_mode:GetValue() == 1 then
        if common.Time() >= aa_stamps.base then
            SetYaw(ui.base_yaw:GetValue() - ui.base_mode_range:GetValue())
            aa_stamps.base = common.Time() + 0.007
        elseif common.Time() < aa_stamps.base then
            SetYaw(ui.base_yaw:GetValue() + ui.base_mode_range:GetValue())
        end
    elseif ui.base_mode:GetValue() == 2 then
        if common.Time() >= aa_stamps.base then
            SetYaw(-ui.base_yaw:GetValue())
            aa_stamps.base = common.Time() + 0.1
        else
            SetYaw(ui.base_yaw:GetValue())
        end
    else 
        SetYaw(ui.base_yaw:GetValue())
    end

    --LEFT
    if ui.left_mode:GetValue() == 1 then
        if common.Time() >= aa_stamps.left then
            SetYaw(ui.left_yaw:GetValue() - ui.left_mode_range:GetValue(), "left")
            aa_stamps.left = common.Time() + 0.007
        elseif common.Time() < aa_stamps.left then
            SetYaw(ui.left_yaw:GetValue() + ui.left_mode_range:GetValue(), "left")
        end
    elseif ui.left_mode:GetValue() == 2 then
        if common.Time() >= aa_stamps.left then
            SetYaw(-ui.left_yaw:GetValue(), "left")
            aa_stamps.left = common.Time() + 0.1
        else
            SetYaw(ui.left_yaw:GetValue(), "left")
        end
    else 
        SetYaw(ui.left_yaw:GetValue(), "left")
    end

    --RIGHT
    if ui.right_mode:GetValue() == 1 then
        if common.Time() >= aa_stamps.right then
            SetYaw(ui.right_yaw:GetValue() - ui.right_mode_range:GetValue(), "right")
            aa_stamps.right = common.Time() + 0.007
        elseif common.Time() < aa_stamps.right then
            SetYaw(ui.right_yaw:GetValue() + ui.right_mode_range:GetValue(), "right")
        end
    elseif ui.right_mode:GetValue() == 2 then
        if common.Time() >= aa_stamps.right then
            SetYaw(-ui.right_yaw:GetValue(), "right")
            aa_stamps.right = common.Time() + 0.1
        else
            SetYaw(ui.right_yaw:GetValue(), "right")
        end
    else 
        SetYaw(ui.right_yaw:GetValue(), "right")
    end
end

local screen_x, screen_y = draw.GetScreenSize()

local settings_wnd = gui.Window("settings_wnd", "cock", 200, 200, 200, 200); settings_wnd:SetActive(false)
local keybinds_x = gui.Slider(settings_wnd, "keybinds_x", "keybinds_x", 200, 0, screen_x)
local keybinds_y = gui.Slider(settings_wnd, "keybinds_y", "keybinds_y", 200, 0, screen_y)

local watermark_text = string.format("Aimware | User: %s", cheat.GetUserName())
local watermark_text_size_x, watermark_text_size_y = draw.GetTextSize(watermark_text)

local last_mouse_x, last_mouse_y = nil, nil
local is_dragging = false
local function Visuals()
    screen_x, screen_y = draw.GetScreenSize() 

    if ui.vis_watermark:GetValue() then
        draw.Color(0, 0, 0, 100)
        draw.FilledRect(screen_x - 12 - watermark_text_size_x, 8, screen_x - 8, 28)

        draw.Color(ui.watermark_color:GetValue())
        draw.FilledRect(screen_x - 12 - watermark_text_size_x, 8, screen_x - 8, 9)

        draw.Color(255, 255, 255, 190)
        draw.SetFont(font)
        draw.Text(screen_x - 10 - watermark_text_size_x, 14, watermark_text)
    end

    if ui.vis_keybinds:GetValue() then
        if not input.IsButtonDown(1) and is_dragging then
            is_dragging = false
        end

        local mouse_x, mouse_y = input.GetMousePos();

        if input.IsButtonDown(1) and not is_dragging and 
            mouse_x >= keybinds_x:GetValue() and mouse_x <= keybinds_x:GetValue() + 175 and
            mouse_y >= keybinds_y:GetValue() and mouse_y <= keybinds_y:GetValue() + 20 then

            last_mouse_x, last_mouse_y = input.GetMousePos()
            is_dragging = true
        elseif input.IsButtonDown(1) and is_dragging then
            local xdelta = last_mouse_x - mouse_x
            local ydelta = last_mouse_y - mouse_y

            keybinds_x:SetValue(keybinds_x:GetValue() - xdelta)
            keybinds_y:SetValue(keybinds_y:GetValue() - ydelta)

            last_mouse_x = mouse_x
            last_mouse_y = mouse_y
        end

        local items = 0.5

        draw.Color(0, 0, 0, 100)
        draw.FilledRect(keybinds_x:GetValue(), keybinds_y:GetValue(), keybinds_x:GetValue() + 175, keybinds_y:GetValue() + 20)

        draw.Color(ui.watermark_color:GetValue())
        draw.FilledRect(keybinds_x:GetValue(), keybinds_y:GetValue(), keybinds_x:GetValue() + 175, keybinds_y:GetValue() + 1)

        draw.Color(255, 255, 255, 190)
        draw.SetFont(font)
        draw.Text(keybinds_x:GetValue() + draw.GetTextSize("keybinds") + 4, keybinds_y:GetValue() + 5, "keybinds")

        --items

        if ui.rbot_dmg_override:GetValue() then
            items = items + 1

            draw.Color(255, 255, 255, 220)
            draw.SetFont(font2)
            draw.Text(keybinds_x:GetValue(), keybinds_y:GetValue() + (15 * items), "Minimum Damage Override")
        end

        if gui.GetValue("rbot.accuracy.attack.shared.magic") ~= nil and gui.GetValue("rbot.accuracy.attack.shared.magic") ~= 0 and input.IsButtonDown(gui.GetValue("rbot.accuracy.attack.shared.magic")) then
            items = items + 1

            draw.Color(255, 255, 255, 220)
            draw.SetFont(font2)
            draw.Text(keybinds_x:GetValue(), keybinds_y:GetValue() + (15 * items), "Magic Bullet")
        end

        if ui.rbot_rapidfire_toggle:GetValue() or string.find(gui.GetValue("rbot.accuracy.attack.shared.fire"), "\"Rapid Fire\"") then
            items = items + 1

            draw.Color(255, 255, 255, 220)
            draw.SetFont(font2)
            draw.Text(keybinds_x:GetValue(), keybinds_y:GetValue() + (15 * items), "Rapid Fire")
        end
    end
end

local dmg_list = {
    ["shared"] = 0,
    ["zeus"] = 0,
    ["pistol"] = 0,
    ["hpistol"] = 0,
    ["smg"] = 0,
    ["rifle"] = 0,
    ["shotgun"] = 0,
    ["scout"] = 0,
    ["asniper"] = 0,
    ["sniper"] = 0,
    ["lmg"] = 0
}

local was_set_dmg = false
local function MinDmgOverride()
    if ui.rbot_dmg_override:GetValue() then
        if not was_set_dmg then
            for k, v in pairs(dmg_list) do
                dmg_list[k] = gui.GetValue(string.format("rbot.hitscan.accuracy.%s.mindamage", k))
            end

            was_set_dmg = true
        end

        for k, v in pairs(dmg_list) do
            if gui.GetValue(string.format("rbot.hitscan.accuracy.%s.mindamage", k)) ~= ui["dmg_" .. k]:GetValue() then
                gui.SetValue(string.format("rbot.hitscan.accuracy.%s.mindamage", k), ui["dmg_" .. k]:GetValue())
            end
        end
    else
        if was_set_dmg then
            for k, v in pairs(dmg_list) do
                gui.SetValue(string.format("rbot.hitscan.accuracy.%s.mindamage", k), v)
            end

            was_set_dmg = false
        end
    end
end

local prev_set = {
    ["rapidfire"] = false
}

local function Binds()
    if ui.rbot_rapidfire_toggle:GetValue() then
        if not prev_set.rapidfire then
            for i, v in ipairs(weapon_categories) do
                if not string.find(gui.GetValue("rbot.accuracy.attack." .. v .. ".fire"), "\"Rapid Fire\"") then
                    gui.SetValue("rbot.accuracy.attack." .. v .. ".fire", "Rapid Fire")
                end
            end

            prev_set.rapidfire = true
        end
    else
        if prev_set.rapidfire then
            for i, v in ipairs(weapon_categories) do
                if string.find(gui.GetValue("rbot.accuracy.attack." .. v .. ".fire"), "\"Rapid Fire\"") then
                    gui.SetValue("rbot.accuracy.attack." .. v .. ".fire", "Off")
                end
            end

            prev_set.rapidfire = false
        end
    end
end

callbacks.Register("Draw", function() 
    HandleUI()
    AntiAim()
    Visuals()
    MinDmgOverride()
    Binds()
end)