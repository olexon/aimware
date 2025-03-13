--credits: https://github.com/alex-free/open95keygen
--reject modernity

local function gen_oem()
    local key = {}

    --part1 generate day in range from 001 to 366
    table.insert(key, math.random(1, 366))

    --part2 generate a valid year (95 - 02)
    while (true) do
        local year = ""

        for i = 1, 2 do
            year = year .. tostring(math.random(0, 9))
        end

        if year:sub(1, 1) == "9" and tonumber(year:sub(2, 2)) >= 5 or year:sub(1, 1) == "0" and tonumber(year:sub(2, 2)) <= 2 then
            table.insert(key, year)
            break
        end
    end

    --part3 generate 5 random digits dividable by 7 and not ending with 0, 8 or 9
    while (true) do
        local digits = ""
        local sum = 0

        for i = 1, 5 do
            local rand = math.random(0, 9)

            digits = digits .. tostring(rand)
            sum = sum + rand
        end

        if sum % 7 == 0 then
            if digits:sub(5, 5) ~= "0" and digits:sub(5, 5) ~= "8" and digits:sub(5, 5) ~= "9" then
                table.insert(key, digits)
                break
            end
        end
    end

    --part4 generate 5 random numbers
    while (true) do
        local digits = ""

        for i = 1, 5 do
            digits = digits .. tostring(math.random(0, 9))
        end

        table.insert(key, digits)
        break
    end

    --format the key
    return string.format("%03d%s-OEM-00%s-%s", key[1], key[2], key[3], key[4])
end

local function gen_retail()
    local key = {}

    --for part1
    local function isBlacklisted(str)
        local blacklist = {"333", "444", "555", "666", "777", "888", "999"}

        for k, v in ipairs(blacklist) do
            if str == v then
                return true
            end
        end

        return false
    end

    --part1 generate 3 random digits that are not blacklisted
    while (true) do
        local digits = ""

        for i = 1, 3 do
            digits = digits .. tostring(math.random(0, 9))
        end

        if not isBlacklisted(digits) then
            table.insert(key, digits)
            break
        end
    end

    --part2 generate 7 random digits dividable by 7
    while (true) do
        local digits = ""
        local sum = 0

        for i = 1, 7 do
            local rand = math.random(0, 9)

            digits = digits .. tostring(rand)
            sum = sum + rand
        end

        if sum % 7 == 0 then
            table.insert(key, digits)
            break
        end
    end

    return string.format("%s-%s", key[1], key[2])
end

local wnd = gui.Window("aw95_window", "AW95 - WIN95 KEYGEN", 100, 100, 400, 185)

local box_elems = {}

local lic_type = gui.Combobox(wnd, "aw95_lic", "License Type", "Retail", "OEM")
local the_box = gui.Groupbox(wnd, "Your Key:", 12, 70, 375, 200)

local gen = gui.Button(wnd, "Generate", function()
    for _, elem in pairs(box_elems) do
        elem:Remove()
    end

    if lic_type:GetValue() == 0 then
        table.insert(box_elems, gui.Text(the_box, gen_retail()))
    elseif lic_type:GetValue() == 1 then
        table.insert(box_elems, gui.Text(the_box, gen_oem()))
    end
end)

table.insert(box_elems, gui.Text(the_box, "Your key will be displayed here"))
lic_type:SetWidth(200)
gen:SetPosY(25)
gen:SetPosX(230)
gen:SetWidth(155)

callbacks.Register("Draw", function()
    local isMenuOpen = gui.Reference("MENU"):IsActive()

    if isMenuOpen and not wnd:IsActive() then
        wnd:SetActive(true)
    elseif not isMenuOpen and wnd:IsActive() then
        wnd:SetActive(false)
    end
end)
