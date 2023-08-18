local render = {
    title_font = draw.CreateFont("Calibri", 19, 200, 0),
    items_font = draw.CreateFont("Calibri", 16, 200, 0),

    window_items = {},

    window_height = nil,

    window = function(self, x1, y1, x2, y2, text) --y2 is useless lol
        if text == nil then
            text = ""
        end

        self.window_height = (y1 + 40) + 20 * #self.window_items

        --Header

        draw.Color(gui.GetValue("theme.header.bg"))
        draw.FilledRect(x1, y1, x2, y1 + 30)

        draw.Color(gui.GetValue("theme.header.line"))
        draw.FilledRect(x1, y1 + 28, x2, y1 + 30)

        draw.Color(gui.GetValue("theme.header.text"))
        draw.SetFont(self.title_font)
        draw.Text(x1 + 5, y1 + 10, text)

        --Main area

        draw.Color(20, 23, 23, 255)
        draw.FilledRect(x1, y1 + 30, x2, self.window_height)

        --Items

        for i, v in ipairs(self.window_items) do 
            draw.Color(unpack(v[2]))
            draw.SetFont(self.items_font)
            draw.Text(x1 + 5, self.window_height - 20 * i, v[1])

            if i ~= #self.window_items then
                draw.Color(39, 44, 46, 255)
                draw.Line(x1 + 4, self.window_height - 20 * i - 5, x2 - 4, self.window_height - 20 * i - 5)
            end
        end

        --Border
        draw.Color(gui.GetValue("theme.ui2.border"))
        draw.OutlinedRect(x1, y1, x2, self.window_height)
    end,

    add_text = function(self, text, color)
        table.insert(self.window_items, {text, color})
    end,

    destroy_items = function(self)
        for i = 1, #self.window_items do 
            self.window_items[i] = nil
        end
    end
}

local function get_spectators()
    local localplayer = entities.GetLocalPlayer()

    if localplayer == nil or not localplayer:IsAlive() then return end
    local players = entities.FindByClass("CCSPlayer");

    for i = 1, #players do 
        if players[i]:GetTeamNumber() ~= localplayer:GetTeamNumber() or players[i]:IsAlive() or players[i]:GetIndex() == nil or localplayer:GetIndex() == nil then goto continue end

        local color = {255, 255, 255, 255}

        if players[i]:GetPropEntity("m_hObserverTarget"):GetIndex() == localplayer:GetIndex() then
            color = {240, 0, 10, 255}
        else 
            color = {255, 255, 255, 255}
        end

        if players[i]:GetPropEntity("m_hObserverTarget"):GetName() ~= nil then
            render:add_text(string.format("%s  ➤  %s", players[i]:GetName(), players[i]:GetPropEntity("m_hObserverTarget"):GetName()), color)
        end

        ::continue::
    end
end

local screen_x, screen_y = draw.GetScreenSize()

local toggle = gui.Checkbox(gui.Reference("Misc", "General", "Extra"), "ClassicSpecList", "Show Spectators (Classic)", false)

local debug_window = gui.Window("ClassicSpecDBUGwnd", "cock and balls", 100, 300, 300, 700) --l33t 
local x_slider = gui.Slider(debug_window, "ClassicSpecX", "X(D)", 200, 0, screen_x - 225)
local y_slider = gui.Slider(debug_window, "ClassicSpecY", "Y(MCA)", 200, 0, screen_y - 30)

debug_window:SetInvisible(true)

--render:add_text("cum  ➤  dick", {255, 255, 255, 255}) b1g ui test
--render:destroy_items()

local last_mX, last_mY = nil, nil
local bIsDragging = false

callbacks.Register("Draw", function()
    screen_x, screen_y = draw.GetScreenSize() --sdfgjhklerfujhk

    if not input.IsButtonDown(1) and bIsDragging then
        bIsDragging = false
    end

    if toggle:GetValue() and entities.GetLocalPlayer() ~= nil then
        get_spectators()

        local mouse_x, mouse_y = input.GetMousePos();

        render:window(x_slider:GetValue(), y_slider:GetValue(), x_slider:GetValue() + 225, "who cares lol", "Spectators")

        if render.window_height ~= nil and input.IsButtonDown(1) and not bIsDragging and 
           mouse_x >= x_slider:GetValue() and mouse_x <= x_slider:GetValue() + 225 and
           mouse_y >= y_slider:GetValue() and mouse_y <= render.window_height then

            last_mX, last_mY = input.GetMousePos();
            bIsDragging = true
        elseif input.IsButtonDown(1) and bIsDragging then
            local xdelta = last_mX - mouse_x
            local ydelta = last_mY - mouse_y

            x_slider:SetValue(x_slider:GetValue() - xdelta)
            y_slider:SetValue(y_slider:GetValue() - ydelta)

            last_mX = mouse_x
            last_mY = mouse_y
        end

        render:destroy_items()
    end
end)