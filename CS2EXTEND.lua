local xml = gui.XML([[
<Window var="xmlmenu" name="" width="400" height="500">
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
    </Tab>
</Window>
]])

local ui = {
    ["menu"] = xml:Children()(),

    ["vis_watermark"] = xml:Reference("vis_watermark"),
    ["watermark_color"] = xml:Reference("vis_watermark"):Children()(),

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

local watermark_text = string.format("Aimware | User: %s", cheat.GetUserName())
local watermark_text_size_x, watermark_text_size_y = draw.GetTextSize(watermark_text)
local function Visuals()
    local screen_x, screen_y = draw.GetScreenSize()

    if ui.vis_watermark:GetValue() then
        draw.Color(0, 0, 0, 100)
        draw.FilledRect(screen_x - 12 - watermark_text_size_x, 8, screen_x - 8, 28)

        draw.Color(ui.watermark_color:GetValue())
        draw.FilledRect(screen_x - 12 - watermark_text_size_x, 8, screen_x - 8, 9)

        draw.Color(255, 255, 255, 200)
        draw.Text(screen_x - 10 - watermark_text_size_x, 14, watermark_text)
    end
end

callbacks.Register("Draw", function() 
    HandleUI()
    AntiAim()
    Visuals()
end)