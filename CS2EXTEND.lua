gui.Command("clear")
print("CS2XTEND LUA by olexon")

local main_wnd = gui.Window("main_wnd", "CS2XTEND", 200, 200, 400, 570);
local active_tab = 0 -- 0 - AA | 1 - MISC

local aa_groupboxes = {
    [0] = gui.Groupbox( main_wnd, "Base Direction", 25, 320, 350, 100),
    [1] = gui.Groupbox( main_wnd, "Left Direction", 25, 320, 350, 100),
    [2] = gui.Groupbox( main_wnd, "Right Direction", 25, 320, 350, 100),
    ["main"] = gui.Groupbox( main_wnd, "Main", 25, 60, 350, 100),
}

local aa_tab = {
    pitch_jitter = gui.Checkbox(aa_groupboxes["main"], "pitch_jitter", "Pitch Jitter", 0),
    pitch_0_on_manual = gui.Checkbox(aa_groupboxes["main"], "pitch_0_on_manual", "Pitch 0 on Manual / Freestand", 0),
    manual_left = gui.Keybox(aa_groupboxes["main"], "manual_left", "Manual Left", 0),
    manual_right = gui.Keybox(aa_groupboxes["main"], "manual_right", "Manual Right", 0),
    freestanding = gui.Keybox(aa_groupboxes["main"], "freestanding", "Freestanding", 0),
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
    --enhanced_anti_ut = gui.Checkbox(misc_groupboxes["main"], "enhanced_anti_ut", "Enhanced Anti Untrusted", 0),
    watermark = gui.Checkbox(misc_groupboxes["main"], "watermark", "Watermark", 1),

    ui_color = gui.ColorPicker(misc_groupboxes["main"], "ui_color", "UI Color", 200, 40, 40, 255),
}

--misc_tab.enhanced_anti_ut:SetDescription("Extra restrictions for playing on Valve MM servers")

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

    gui.SetValue("rbot.antiaim." .. edge,  tostring(value) .. " Backward")
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

--NOTE TO MYSELF: Optimise this pile of garbage
local function AntiAim() --im retarded avoid looking at this
    if entities.GetLocalPawn():IsPlayer() == nil or not entities.GetLocalPawn():IsPlayer() then return end

    if aa_tab.freestanding:GetValue() ~= nil and aa_tab.freestanding:GetValue() ~= 0 and input.IsButtonDown( aa_tab.freestanding:GetValue() ) then
        if not cached_aa.at_edges[2] and cached_aa.current_edge == 0 then
            cached_aa.at_edges[1] = gui.GetValue("rbot.antiaim.condition.autodir.edges")
            cached_aa.at_edges[2] = not cached_aa.at_edges[2]
        end

        if aa_tab.pitch_0_on_manual:GetValue() then
            if not cached_aa.pitch[2] then
                cached_aa.pitch[1] = gui.GetValue("rbot.antiaim.advanced.pitch")
                cached_aa.pitch[2] = not cached_aa.pitch[2]
            end

            gui.SetValue("rbot.antiaim.advanced.pitch", 2)
        else
            if cached_aa.pitch[2] then
                gui.SetValue("rbot.antiaim.advanced.pitch", cached_aa.pitch[1])
                cached_aa.pitch[1] = nil
                cached_aa.pitch[2] = not cached_aa.pitch[2]
            end
        end

        SetYaw(90, "left")
        SetYaw(-90, "right")

        if not gui.GetValue("rbot.antiaim.condition.autodir.edges") then
            gui.SetValue("rbot.antiaim.condition.autodir.edges", true)
        end
    else
        if cached_aa.at_edges[2] and cached_aa.current_edge == 0 then
            gui.SetValue("rbot.antiaim.condition.autodir.edges", cached_aa.at_edges[1])

            cached_aa.at_edges[1] = nil
            cached_aa.at_edges[2] = not cached_aa.at_edges[2]
        elseif cached_aa.at_edges[2] and cached_aa.current_edge ~= 0 then
            gui.SetValue("rbot.antiaim.condition.autodir.edges", false)
        end
    end

    if aa_tab.freestanding:GetValue() == nil or aa_tab.freestanding:GetValue() == 0 or not input.IsButtonDown( aa_tab.freestanding:GetValue() ) then
        if aa_tab.pitch_jitter:GetValue() and cached_aa.current_edge == 0 then
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

            if aa_tab.freestanding:GetValue() == nil or aa_tab.freestanding:GetValue() == 0 or not input.IsButtonDown( aa_tab.freestanding:GetValue() ) then
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
            end
        else
            if aa_tab.pitch_0_on_manual:GetValue() then
                if not cached_aa.pitch[2] then
                    cached_aa.pitch[1] = gui.GetValue("rbot.antiaim.advanced.pitch")
                    cached_aa.pitch[2] = not cached_aa.pitch[2]
                end

                gui.SetValue("rbot.antiaim.advanced.pitch", 2)
            else
                if cached_aa.pitch[2] then
                    gui.SetValue("rbot.antiaim.advanced.pitch", cached_aa.pitch[1])
                    cached_aa.pitch[1] = nil
                    cached_aa.pitch[2] = not cached_aa.pitch[2]
                end
            end

            if cached_aa.current_edge == 1 then
                SetYaw(90)
            elseif cached_aa.current_edge == 2 then
                SetYaw(-90)
            end
        end
    end
end

--####################

local function Misc()
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
end

local screen_x, screen_y = draw.GetScreenSize()

local ind_font = draw.CreateFont("Lucida Console", 14, 400)
draw.SetFont(ind_font)

local watermark_text = "AIM"
local watermark_text_size_x, watermark_text_size_y = draw.GetTextSize(watermark_text)

local watermark_text2 = "WARE"
local watermark_text_size_x2, watermark_text_size_y2 = draw.GetTextSize(watermark_text2)

local user_text =  "[" .. string.lower(cheat.GetUserName()) .. "]"
local user_text_size_x, user_text_size_y = draw.GetTextSize(user_text)

local function Visuals()
    if misc_tab.watermark:GetValue() then
        draw.Color(255, 255, 255, 255)
        draw.SetFont(ind_font)
        draw.Text(screen_x - 6 - watermark_text_size_x - watermark_text_size_x2 - user_text_size_x, 8, watermark_text)

        local ui_clr_r, ui_clr_g, ui_clr_b, ui_clr_a = misc_tab.ui_color:GetValue()

        draw.Color(ui_clr_r, ui_clr_g, ui_clr_b, 255)
        draw.SetFont(ind_font)
        draw.Text(screen_x - 6 - watermark_text_size_x2 - user_text_size_x, 8, watermark_text2)

        draw.Color(255, 255, 255, 255)
        draw.SetFont(ind_font)
        draw.Text(screen_x - 6 - user_text_size_x, 8, user_text)
    end
end

--####################

callbacks.Register("Draw", function() 
    screen_x, screen_y = draw.GetScreenSize()

    HandleUI()
    Visuals()
    Misc()
end)

callbacks.Register("CreateMove", function() 
    AntiAim()
end)
