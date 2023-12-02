--####################
gui.Command("clear")

--version check
--local script_name = GetScriptName()
local local_version = "1.2"
--local current_version = tostring(http.Get("https://raw.githubusercontent.com/olexon/aimware/main/lua_versions/cs2xtend.txt")):sub(1, -2)

local function console_log(buffer)
    print(string.format("[CS2XTEND %s] %s", local_version, tostring(buffer)))
end

--[[console_log("checking for updates...")
if local_version ~= current_version then
    console_log("update found! downloading...")
    local new_script = http.Get("https://raw.githubusercontent.com/olexon/aimware/main/CS2EXTEND.lua")

    console_log("updating...")
    file.Delete(script_name)
    file.Write(script_name, new_script)

    console_log("successfully updated!")
    UnloadScript(script_name)
else
    console_log("script is up to date!")
end]]

--assets check
local assets_found = false

console_log("checking assets...")
file.Enumerate(function(f)
    if f == "cs2xtend/icon.png" then
        console_log("assets found!")
        assets_found = true
    end
end)

if not assets_found then
    console_log("assets not found! downloading...")
    file.Write("cs2xtend/icon.png", http.Get("https://github.com/olexon/Absinthe/blob/main/svg/bg_f8f8f8-flat_750x_075_f-pad_750x1000_f8f8f8-4031151753-removebg-preview.png?raw=true"))

    assets_found = true
end

console_log("CS2XTEND by olexon loaded successfully!")

--####################

local icons = {
    ["AA"] = draw.CreateTexture(common.DecodePNG(file.Read("cs2xtend/icon.png"))),
}

local main_wnd = gui.Window("main_wnd", "CS2XTEND", 200, 200, 400, 520); main_wnd:SetIcon(icons.AA, 0.9)
local active_tab = 0 -- 0 - AA | 1 - MISC

local aa_groupboxes = {
    [0] = gui.Groupbox( main_wnd, "Base Direction", 25, 265, 350, 100),
    [1] = gui.Groupbox( main_wnd, "Left Direction", 25, 265, 350, 100),
    [2] = gui.Groupbox( main_wnd, "Right Direction", 25, 265, 350, 100),
    ["main"] = gui.Groupbox( main_wnd, "Main", 25, 60, 350, 100),
}

local aa_tab = {
    pitch_jitter = gui.Checkbox(aa_groupboxes["main"], "pitch_jitter", "Pitch Jitter", 0),
    manual_left = gui.Keybox(aa_groupboxes["main"], "manual_left", "Manual Left", 0),
    manual_right = gui.Keybox(aa_groupboxes["main"], "manual_right", "Manual Right", 0),
    dir_selector = gui.Combobox(aa_groupboxes["main"], "dir_selector", "Select Direction", "Base", "Left", "Right"),

    base_yaw = gui.Slider(aa_groupboxes[0], "base_yaw", "Yaw", 0, -180, 180),
    base_mode = gui.Combobox(aa_groupboxes[0], "base_mode", "Mode", "Static", "Switch"),
    base_mode_range = gui.Slider(aa_groupboxes[0], "base_mode_range", "Range", 30, 30, 90),

    left_yaw = gui.Slider(aa_groupboxes[1], "left_yaw", "Yaw", 0, -180, 180),
    left_mode = gui.Combobox(aa_groupboxes[1], "left_mode", "Mode", "Static", "Switch"),
    left_mode_range = gui.Slider(aa_groupboxes[1], "left_mode_range", "Range", 30, 30, 90),

    right_yaw = gui.Slider(aa_groupboxes[2], "right_yaw", "Yaw", 0, -180, 180),
    right_mode = gui.Combobox(aa_groupboxes[2], "right_mode", "Mode", "Static", "Switch"),
    right_mode_range = gui.Slider(aa_groupboxes[2], "right_mode_range", "Range", 30, 30, 90),
}

local misc_groupboxes = {
    ["main"] = gui.Groupbox( main_wnd, "Main", 25, 60, 350, 100),
}

local misc_tab = {
    ui_color = gui.ColorPicker(misc_groupboxes["main"], "ui_color", "UI Color", 200, 40, 40, 255),
    watermark = gui.Checkbox(misc_groupboxes["main"], "watermark", "Watermark", 1),
}

local aa_btn = gui.Button(main_wnd, "Anti-Aim", function() 
    active_tab = 0 
end); aa_btn:SetPosX(10); aa_btn:SetPosY(10); aa_btn:SetWidth(180)

local misc_btn = gui.Button(main_wnd, "Misc", function() 
    active_tab = 1 
end); misc_btn:SetPosX(210); misc_btn:SetPosY(10); misc_btn:SetWidth(180)


local function HandleUI()
    if not gui.Reference("menu"):IsActive() and main_wnd:IsActive() then
        main_wnd:SetActive(false)
    elseif gui.Reference("menu"):IsActive() and not main_wnd:IsActive() then
        main_wnd:SetActive(true)
    end

    if active_tab == 0 then
        for k, v in pairs(aa_groupboxes) do
            if k == aa_tab.dir_selector:GetValue() or k == "main" then
                v:SetInvisible(false)
            else
                v:SetInvisible(true)
            end
        end

        for k, v in pairs(misc_groupboxes) do
            v:SetInvisible(true)
        end
    elseif active_tab == 1 then
        for k, v in pairs(aa_groupboxes) do
            v:SetInvisible(true)
        end

        for k, v in pairs(misc_groupboxes) do
            v:SetInvisible(false)
        end
    end
end

--####################

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

local cached_aa = {
    current_edge = 0, -- 0 - off | 1 - left | 2 - right
    pitch = {nil, false},
    at_edges = {nil, false},
}

local function AntiAim()
    if not entities.GetLocalPawn():IsPlayer() then return end

    --main
    if aa_tab.pitch_jitter:GetValue() then
        if not cached_aa.pitch[2] then
            cached_aa.pitch[1] = gui.GetValue("rbot.antiaim.advanced.pitch")
            cached_aa.pitch[2] = not cached_aa.pitch[2]
        end

        if globals.TickCount()%2 == 0 then
            gui.SetValue("rbot.antiaim.advanced.pitch", 1)
        else
            gui.SetValue("rbot.antiaim.advanced.pitch", 2)
        end
    else
        if cached_aa.pitch[2] then
            gui.SetValue("rbot.antiaim.advanced.pitch", cached_aa.pitch[1])
            cached_aa.pitch[1] = nil
            cached_aa.pitch[2] = not cached_aa.pitch[2]
        end
    end

    if aa_tab.manual_left:GetValue() ~= 0 and aa_tab.manual_left:GetValue() ~= nil and input.IsButtonPressed(aa_tab.manual_left:GetValue()) then
        if cached_aa.current_edge == 1 then
            if cached_aa.at_edges[2] then
                gui.SetValue("rbot.antiaim.condition.autodir.edges", cached_aa.at_edges[1])

                cached_aa.at_edges[1] = nil
                cached_aa.at_edges[2] = not cached_aa.at_edges[2]
            end

            cached_aa.current_edge = 0
        else
            if not cached_aa.at_edges[2] then
                cached_aa.at_edges[1] = gui.GetValue("rbot.antiaim.condition.autodir.edges")
                cached_aa.at_edges[2] = not cached_aa.at_edges[2]
            end

            if gui.GetValue("rbot.antiaim.condition.autodir.edges") then
                gui.SetValue("rbot.antiaim.condition.autodir.edges", 0)
            end

            cached_aa.current_edge = 1
        end
    end

    if aa_tab.manual_right:GetValue() ~= 0 and aa_tab.manual_right:GetValue() ~= nil and input.IsButtonPressed(aa_tab.manual_right:GetValue()) then
        if cached_aa.current_edge == 2 then
            if cached_aa.at_edges[2] then
                gui.SetValue("rbot.antiaim.condition.autodir.edges", cached_aa.at_edges[1])

                cached_aa.at_edges[1] = nil
                cached_aa.at_edges[2] = not cached_aa.at_edges[2]
            end

            cached_aa.current_edge = 0
        else
            if not cached_aa.at_edges[2] then
                cached_aa.at_edges[1] = gui.GetValue("rbot.antiaim.condition.autodir.edges")
                cached_aa.at_edges[2] = not cached_aa.at_edges[2]
            end

            if gui.GetValue("rbot.antiaim.condition.autodir.edges") then
                gui.SetValue("rbot.antiaim.condition.autodir.edges", 0)
            end

            cached_aa.current_edge = 2
        end
    end

    if cached_aa.current_edge == 0 then
        --BASE
        if aa_tab.base_mode:GetValue() == 1 then
            if globals.TickCount()%2 == 0 then
                SetYaw(aa_tab.base_yaw:GetValue() - aa_tab.base_mode_range:GetValue())
            else
                SetYaw(aa_tab.base_yaw:GetValue() + aa_tab.base_mode_range:GetValue())
            end
        else 
            SetYaw(aa_tab.base_yaw:GetValue())
        end

        --LEFT
        if aa_tab.left_mode:GetValue() == 1 then
            if globals.TickCount()%2 == 0 then
                SetYaw(aa_tab.left_yaw:GetValue() - aa_tab.left_mode_range:GetValue(), "left")
            else
                SetYaw(aa_tab.left_yaw:GetValue() + aa_tab.left_mode_range:GetValue(), "left")
            end
        else 
            SetYaw(aa_tab.left_yaw:GetValue(), "left")
        end

        --RIGHT
        if aa_tab.right_mode:GetValue() == 1 then
            if globals.TickCount()%2 == 0 then
                SetYaw(aa_tab.right_yaw:GetValue() - aa_tab.right_mode_range:GetValue(), "right")
            else
                SetYaw(aa_tab.right_yaw:GetValue() + aa_tab.right_mode_range:GetValue(), "right")
            end
        else 
            SetYaw(aa_tab.right_yaw:GetValue(), "right")
        end
    elseif cached_aa.current_edge == 1 then
        SetYaw(90)
    elseif cached_aa.current_edge == 2 then
        SetYaw(-90)
    end
end

--####################

local screen_x, screen_y = draw.GetScreenSize()

local settings_wnd = gui.Window("settings_wnd", "cock", 200, 200, 200, 200); settings_wnd:SetActive(false)
local keybinds_x = gui.Slider(settings_wnd, "keybinds_x", "keybinds_x", 200, 0, screen_x)
local keybinds_y = gui.Slider(settings_wnd, "keybinds_y", "keybinds_y", 200, 0, screen_y)

local last_mouse_x, last_mouse_y = nil, nil
local is_dragging = false

local font_watermark = draw.CreateFont("Segoe UI Semibold", 24, 500)
local font_keybinds = draw.CreateFont("Segoe UI Semibold", 18, 500)

draw.SetFont(font_watermark)
local watermark_text = "aimware"
local watermark_text_size_x, watermark_text_size_y = draw.GetTextSize(watermark_text)

local user_text = string.lower(cheat.GetUserName())
local user_text_size_x, user_text_size_y = draw.GetTextSize(user_text)

local function Visuals()
    screen_x, screen_y = draw.GetScreenSize() 

    if misc_tab.watermark:GetValue() then
        draw.Color(0, 0, 0, 125)
        draw.RoundedRectFill(screen_x - 29 - watermark_text_size_x, 12, screen_x - 22, 37, 4, 1, 1, 1, 1)
        draw.RoundedRectFill(screen_x - 29 - user_text_size_x, 40, screen_x - 22, 65, 4, 1, 1, 1, 1)

        draw.Color(255, 255, 255, 190)
        draw.SetFont(font_watermark)
        draw.Text(screen_x - 25 - watermark_text_size_x, 18, "aim")
        draw.Text(screen_x - 25 - user_text_size_x, 46, user_text)

        draw.Color(misc_tab.ui_color:GetValue())
        draw.Text(screen_x - 25 - watermark_text_size_x/1.75, 18, "ware")
    end

    --[[if ui.vis_keybinds:GetValue() then
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
        draw.RoundedRectFill(keybinds_x:GetValue(), keybinds_y:GetValue(), keybinds_x:GetValue() + 175, keybinds_y:GetValue() + 22, 4, 1, 1, 1, 1)

        --draw.Color(ui.watermark_color:GetValue())
        --draw.FilledRect(keybinds_x:GetValue(), keybinds_y:GetValue(), keybinds_x:GetValue() + 175, keybinds_y:GetValue() + 1)

        draw.Color(255, 255, 255, 190)
        draw.SetFont(font_keybinds)
        draw.Text(keybinds_x:GetValue() + 4, keybinds_y:GetValue() + 5, "keybinds")

        --items


    end]]
end

--####################

callbacks.Register("Draw", function() 
    HandleUI()
    AntiAim()
    Visuals()
end)
