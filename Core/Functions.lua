local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

local _G = _G
local C_Covenants_GetActiveCovenantID = _G.C_Covenants.GetActiveCovenantID
local C_Covenants_GetCovenantData = _G.C_Covenants.GetCovenantData
local ceil = math.ceil
local COVENANT_COLORS = _G.COVENANT_COLORS
local CreateFromMixins = CreateFromMixins
local floor = math.floor
local format = string.format
local GetAddOnEnableState = GetAddOnEnableState
local gmatch = string.gmatch
local gsub = string.gsub
local ipairs = ipairs
local IsAddOnLoaded = IsAddOnLoaded
local IsSpellKnownOrOverridesKnown = IsSpellKnownOrOverridesKnown
local ItemMixin = ItemMixin
local max = math.max
local min = math.min
local pairs = pairs
local PlayerHasToy = PlayerHasToy
local ReloadUI = ReloadUI
local select = select
local SpellMixin = SpellMixin
local strmatch = string.match
local tconcat = table.concat
local tinsert = table.insert
local tostring = tostring
local type = type
local utf8sub, utf8upper, utf8lower, utf8len = string.utf8sub, string.utf8upper, string.utf8lower, string.utf8len

function F.IsTXUIProfile()
    return not (not E.db.TXUI or not E.db.TXUI.changelog or not E.db.TXUI.changelog.releaseVersion or
               E.db.TXUI.changelog.releaseVersion == 0)
end

function F.ResetTXUIProfile()
    if not F.IsTXUIProfile() then return F.DebugPrint(TXUI, "ResetTXUIProfile > No TXUI Profile found") end
    E:CopyTable(E.db.TXUI, P)
    E:CopyTable(E.private.TXUI, V)
    ReloadUI()
end

function F.ResetModuleProfile(profile)
    if not F.IsTXUIProfile() then return F.DebugPrint(TXUI, "ResetModuleProfile > No TXUI Profile found") end
    if (P[profile] == nil) then return F.DebugPrint(TXUI, "ResetModuleProfile > Invalid config:", profile) end

    E:CopyTable(E.db.TXUI[profile], P[profile])
    ReloadUI()
end

function F.ResetMiscProfile(profile)
    if not F.IsTXUIProfile() then return F.DebugPrint(TXUI, "ResetMiscProfile > No TXUI Profile found") end
    if (P[profile] == nil) then return F.DebugPrint(TXUI, "ResetMiscProfile > Invalid config:", profile) end

    E:CopyTable(E.db.TXUI[profile], P[profile])
    ReloadUI()
end

function F.IsAddOnEnabled(addon)
    return GetAddOnEnableState(E.myname, addon) == 2 and IsAddOnLoaded(addon)
end

function F.Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end

function F.ClampTo01(value)
    return min(max(value, 0), 1)
end

function F.ClampToHSL(h, s, l)
    return h % 360, F.ClampTo01(s), F.ClampTo01(l)
end

function F.ConvertFromHue(m1, m2, h)
    if h < 0 then h = h + 1 end
    if h > 1 then h = h - 1 end

    if h * 6 < 1 then
        return m1 + (m2 - m1) * h * 6
    elseif h * 2 < 1 then
        return m2
    elseif h * 3 < 2 then
        return m1 + (m2 - m1) * (2 / 3 - h) * 6
    else
        return m1
    end
end

function F.ConvertToRGB(h, s, l)
    h = h / 360

    local m2 = l <= .5 and l * (s + 1) or l + s - l * s
    local m1 = l * 2 - m2

    return F.ConvertFromHue(m1, m2, h + 1 / 3), F.ConvertFromHue(m1, m2, h), F.ConvertFromHue(m1, m2, h - 1 / 3)
end

function F.ConvertToHSL(r, g, b)
    local minColor = min(r, g, b)
    local maxColor = max(r, g, b)
    local colorDelta = maxColor - minColor

    local h, s, l = 0, 0, (minColor + maxColor) / 2

    if l > 0 and l < 0.5 then s = colorDelta / (maxColor + minColor) end
    if l >= 0.5 and l < 1 then s = colorDelta / (2 - maxColor - minColor) end

    if colorDelta > 0 then
        if maxColor == r and maxColor ~= g then h = h + (g - b) / colorDelta end
        if maxColor == g and maxColor ~= b then h = h + 2 + (b - r) / colorDelta end
        if maxColor == b and maxColor ~= r then h = h + 4 + (r - g) / colorDelta end
        h = h / 6
    end

    if h < 0 then h = h + 1 end
    if h > 1 then h = h - 1 end

    return h * 360, s, l
end

function F.CalculateMultiplierColor(multi, r, g, b)
    local h, s, l = F.ConvertToHSL(r, g, b)
    return F.ConvertToRGB(F.ClampToHSL(h, s, l * multi))
end

function F.CalculateMultiplierColorArray(multi, colors)
    local r, g, b

    if (colors.r) then
        r, g, b = colors.r, colors.g, colors.b
    else
        r, g, b = colors[1], colors[2], colors[3]
    end

    return F.CalculateMultiplierColor(multi, r, g, b)
end

function F.FastTextGradient(text, r1, g1, b1, r2, g2, b2)
    local msg, len, idx = "", utf8len(text), 0

    for i = 1, len do
        local x = utf8sub(text, i, i)
        if strmatch(x, "%s") then
            msg = msg .. x
            idx = idx + 1
        else
            local relperc = (idx / len)

            if not r2 then
                msg = msg .. E:RGBToHex(r1, g1, b1, nil, x .. "|r")
            else
                local r, g, b = F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
                msg = msg .. E:RGBToHex(r, g, b, nil, x .. "|r")
                idx = idx + 1
            end
        end
    end

    return msg
end

function F.SlowColorGradient(perc, ...)
    if perc >= 1 then
        return select(select("#", ...) - 2, ...)
    elseif perc <= 0 then
        return ...
    end

    local num = select("#", ...) / 3
    local segment, relperc = math.modf(perc * (num - 1))
    local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

    return F.FastColorGradient(relperc, r1, g1, b1, r2, g2, b2)
end

function F.FastColorGradient(perc, r1, g1, b1, r2, g2, b2)
    if perc >= 1 then
        return r2, g2, b2
    elseif perc <= 0 then
        return r1, g1, b1
    end

    return math.sqrt(math.pow(r1, 2) * (1 - perc) + math.pow(r2, 2) * perc),
           math.sqrt(math.pow(g1, 2) * (1 - perc) + math.pow(g2, 2) * perc),
           math.sqrt(math.pow(b1, 2) * (1 - perc) + math.pow(b2, 2) * perc)
end

function F.StringColor(msg, color)
    if type(color) == "string" then
        return "|cff" .. color .. msg .. "|r"
    else
        return "|cff" .. I.Strings.Colors[color] .. msg .. "|r"
    end
end

function F.StringRGB(msg, colors)
    if (colors.r) then
        return F.StringColor(msg, E:RGBToHex(colors.r, colors.g, colors.b, ""))
    else
        return F.StringColor(msg, E:RGBToHex(colors[1], colors[2], colors[3], ""))

    end
end

function F.StringToxiUI(msg)
    return F.StringColor(msg, I.Enum.Colors.TXUI)
end

function F.StringElvUI(msg)
    return F.StringColor(msg, I.Enum.Colors.ELVUI)
end

function F.StringElvUIValue(msg)
    return F.StringColor(msg,
                         E:RGBToHex(E.media.rgbvaluecolor[1], E.media.rgbvaluecolor[2], E.media.rgbvaluecolor[3], ""))
end

function F.StringClass(msg, class)
    local color = E:ClassColor(class or E.myclass, true)
    return F.StringColor(msg, E:RGBToHex(color.r, color.g, color.b, ""))
end

function F.StringLuxthos(msg)
    return F.StringColor(msg, I.Enum.Colors.LUXTHOS)
end

function F.StringError(msg)
    return F.StringColor(msg, I.Enum.Colors.ERROR)
end

function F.StringGood(msg)
    return F.StringColor(msg, I.Enum.Colors.GOOD)
end

function F.StringInstallerWarning(msg)
    return F.StringColor(msg, I.Enum.Colors.INSTALLER_WARNING)
end

function F.StringCovenant(msg)
    local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or TXUI.AddOnColorRGBA
    return F.StringColor(msg, E:RGBToHex(covenantColor.r, covenantColor.g, covenantColor.b, ""))
end

do
    local myCovenant
    function F.GetCachedCovenant()
        if (not myCovenant) then
            local covenantData = C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID())
            if (covenantData) then myCovenant = covenantData.textureKit end
        end

        return myCovenant
    end
end

function F.RemoveFontTemplate(fs)
    E.texts[fs] = nil
end

function F.GetFontColorFromDB(db, prefix)
    -- Vars
    if prefix == nil then prefix = "" end
    local fontColor
    local useDB = (db and prefix) and true or false
    local colorSwitch = (useDB and db[prefix .. "FontColor"]) or I.General.DefaultFontColor

    -- Switch
    if colorSwitch == "CUSTOM" then
        fontColor = (useDB and db[prefix .. "FontCustomColor"]) or I.General.DefaultFontCustomColor
    elseif colorSwitch == "TXUI" then
        fontColor = TXUI.AddOnColorRGBA
    elseif colorSwitch == "CLASS" then
        local classColor = E:ClassColor(E.myclass, true)
        fontColor = { r = classColor.r, g = classColor.g, b = classColor.b, a = 1 }
    elseif colorSwitch == "VALUE" then
        fontColor = { r = E.media.rgbvaluecolor[1], g = E.media.rgbvaluecolor[2], b = E.media.rgbvaluecolor[3], a = 1 }
    elseif colorSwitch == "COVENANT" then
        local covenantColor = COVENANT_COLORS[F.GetCachedCovenant()] or TXUI.AddOnColorRGBA
        fontColor = { r = covenantColor.r, g = covenantColor.g, b = covenantColor.b, a = 1 }
    else
        fontColor = { r = 1, g = 1, b = 1, a = 1 }
    end

    return fontColor
end

function F.SetFontColorFromDB(db, prefix, fs)
    local fontColor = F.GetFontColorFromDB(db, prefix)
    F.RemoveFontTemplate(fs)
    fs:SetTextColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
end

function F.SetFontFromDB(db, prefix, fs, color --[[ = true ]] , fontOverwrite)
    local useDB = (db and prefix) and true or false
    local font = (useDB and db[prefix .. "Font"]) or I.General.DefaultFont
    local size = (useDB and db[prefix .. "FontSize"]) or I.General.DefaultFontSize
    local outline = (useDB and db[prefix .. "FontOutline"]) or I.General.DefaultFontOutline
    local shadow = (useDB and db[prefix .. "FontShadow"] ~= nil) and db[prefix .. "FontShadow"]
    if (shadow == nil) then shadow = I.General.DefaultFontShadow end

    if (fontOverwrite) then font = fontOverwrite end

    local lsmFont = LSM:Fetch("font", font)
    if (not lsmFont) then lsmFont = LSM:Fetch("font", I.General.DefaultFont) end -- backup to normal font if not found
    if (not lsmFont) then lsmFont = E.media.normFont end -- backup to elvui font if not found

    F.RemoveFontTemplate(fs)
    fs:SetFontObject(nil)
    fs:SetFont(lsmFont, size, shadow and "NONE" or outline)

    if shadow then
        fs:SetShadowOffset(1, -0.5)
        fs:SetShadowColor(0, 0, 0, 1)
    else
        fs:SetShadowOffset(0, 0)
        fs:SetShadowColor(0, 0, 0, 0)
    end

    if (color == nil) or (color == true) then F.SetFontColorFromDB(db, prefix, fs) end
end

function F.Abbreviate(text)
    if type(text) ~= "string" then return text end

    local letters, lastWord = "", strmatch(text, ".+%s(.+)$")
    if (lastWord) then
        for word in gmatch(text, ".-%s") do
            local firstLetter = gsub(word, "^[%s%p]*", "")

            if (not strmatch(firstLetter, "%d+")) then
                firstLetter = utf8sub(firstLetter, 1, 1)

                if (firstLetter ~= utf8lower(firstLetter)) then
                    letters = format("%s%s. ", letters, firstLetter)
                end
            else
                firstLetter = gsub(firstLetter, "%D+", "")
                letters = format("%s%s ", letters, firstLetter)
            end
        end

        return format("%s%s", letters, lastWord)
    end

    return text
end

function F.Uppercase(text)
    if type(text) ~= "string" then return text end
    return utf8upper(text)
end

function F.Lowercase(text)
    if type(text) ~= "string" then return text end
    return utf8lower(text)
end

function F.UppercaseFirstLetter(text)
    if type(text) ~= "string" then return text end
    return utf8upper(utf8sub(text, 1, 1)) .. utf8sub(text, 2)
end

function F.UppercaseFirstLetterOnly(text)
    if type(text) ~= "string" then return text end
    return utf8upper(utf8sub(text, 1, 1)) .. utf8lower(utf8sub(text, 2))
end

function F.LowercaseEnum(text)
    if type(text) ~= "string" then return text end
    return strtrim(text):gsub("_", " "):gsub("(%a)([%w_']*)", function(a, b)
        return F.Uppercase(a) .. F.Lowercase(b)
    end)
end

function F.ColorFirstLetter(text)
    if type(text) ~= "string" then return text end
    return F.StringToxiUI(utf8upper(utf8sub(text, 1, 1))) .. "|cfff5feff" .. utf8sub(text, 2) .. "|r"
end

function F.StripStringTexture(text)
    if type(text) ~= "string" then return text end
    return gsub(text, "(%s?)(|?)|[TA].-|[ta](%s?)", function(w, x, y)
        if x == "" then return (w ~= "" and w) or (y ~= "" and y) or "" end
    end)
end

function F.StripStringColor(text)
    if type(text) ~= "string" then return text end
    return gsub(text, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
end

function F.StripString(text)
    if type(text) ~= "string" then return text end
    return F.StripStringColor(F.StripStringTexture(text))
end

do
    local messages = {}
    function F.PrintDelayedDebugMessages()
        for _, msg in ipairs(messages) do F.PrintWithArgumments(unpack(msg)) end
        messages = {}
    end

    local stringHolder
    function F.PrintWithArgumments(parent, color, ...)
        -- Add title if string holder is empty
        if not stringHolder then stringHolder = { TXUI.Title } end

        -- arg count, 1 for title, 1 for parent
        local argsCount = 2

        -- detects the parent
        if parent == TXUI then
            stringHolder[argsCount] = F.StringGood("(TXUI)")
        elseif parent.GetName then
            stringHolder[argsCount] = F.StringGood("(" .. parent:GetName() .. ")")
        else
            stringHolder[argsCount] = F.StringGood("(" .. tostring(parent) .. ")")
        end

        -- iterate over all arguments, convert them to strings and add them
        for i = 1, select("#", ...) do
            argsCount = argsCount + 1
            stringHolder[argsCount] = F.StringColor(tostring(select(i, ...)), color)
        end

        -- print to elvui output frame or default chatframe
        (E.db and _G[E.db.general.messageRedirect] or _G.DEFAULT_CHAT_FRAME):AddMessage(
            tconcat(stringHolder, " ", 1, argsCount))
    end

    function F.Print(parent, ...)
        F.PrintWithArgumments(parent, I.Enum.Colors.WHITE, ...)
    end

    function F.Printf(parent, ...)
        F.PrintWithArgumments(parent, I.Enum.Colors.WHITE, format(...))
    end

    function F.DebugPrint(parent, ...)
        if not TXUI.DevRelease then return end
        if not TXUI.DelayedWorldEntered then
            tinsert(messages, { parent, I.Enum.Colors.WARNING, ... })
            return
        end

        F.PrintWithArgumments(parent, I.Enum.Colors.WARNING, ...)
    end

    function F.DebugPrintf(parent, ...)
        if not TXUI.DevRelease then return end
        if not TXUI.DelayedWorldEntered then
            tinsert(messages, { parent, I.Enum.Colors.WARNING, format(...) })
            return
        end

        F.PrintWithArgumments(parent, I.Enum.Colors.WARNING, format(...))
    end
end

do
    local myName
    function F.IsDeveloper(devs)
        if (E.db.TXUI.general.overrideDevMode) then return false end
        if (not myName) then myName = E.myname .. "-" .. E:ShortenRealm(E.myrealm) end

        if (devs) then
            for _, dev in ipairs(devs) do
                if (I.ChatIconNames[I.Enum.ChatIconType.DEV][dev][myName]) then return true end
            end
        else
            for _, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.DEV]) do
                if (names[myName]) then return true end
            end
        end

        return false
    end

    function F.GetChatIconEntryName()
        if (not myName) then myName = E.myname .. "-" .. E:ShortenRealm(E.myrealm) end

        -- Lookup if developer
        for entry, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.DEV]) do
            if (names[myName]) then return F.UppercaseFirstLetterOnly(I.Enum.Developers[entry]) end
        end

        -- Lookup if beta tester
        for entry, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.BETA]) do
            if (names[myName]) then return entry end
        end

        -- Lookup if vip
        for entry, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.VIP]) do
            if (names[myName]) then return entry end
        end

        return false
    end
end

function F.GetMedia(mediaPath, mediaName)
    local mediaFile = mediaPath[mediaName] or mediaName
    return mediaFile
end

function F.AddMedia(mediaType, mediaFile, lsmName, lsmType, lsmMask)
    local path = I.MediaPaths[mediaType]
    if (path) then
        local key = mediaFile:gsub("%.%w-$", "")
        local file = path .. mediaFile

        local pathKey = I.MediaKeys[mediaType]
        if (pathKey) then
            I.Media[pathKey][key] = file
        else
            TXUI:DebugPrint("Could not find path key for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
        end

        if (lsmName) then
            local nameKey = (lsmName == true and key) or lsmName
            local mediaKey = lsmType or mediaType
            LSM:Register(mediaKey, nameKey, file, lsmMask)
        end
    else
        TXUI:DebugPrint("Could not find media path for", mediaType, mediaFile, lsmName, lsmType, lsmMask)
    end
end

function F.CreateSoftShadow(frame, shadowSize, shadowAlpha)
    local edgeSize = E.twoPixelsPlease and 2 or 1
    shadowSize = shadowSize or 3
    shadowAlpha = shadowAlpha or 0.45

    local softShadow = frame.txSoftShadow or CreateFrame("Frame", nil, frame, "BackdropTemplate")
    softShadow:SetFrameLevel(frame:GetFrameLevel())
    softShadow:SetFrameStrata(frame:GetFrameStrata())
    softShadow:SetOutside(frame, (shadowSize - edgeSize) or edgeSize, (shadowSize - edgeSize) or edgeSize)
    softShadow:SetBackdrop({ edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(shadowSize) })
    softShadow:SetBackdropColor(0, 0, 0, 0)
    softShadow:SetBackdropBorderColor(0, 0, 0, shadowAlpha)
    softShadow:Show()

    frame.txSoftShadow = softShadow
end

function F.CreateInnerNoise(frame)
    local edgeSize = E.twoPixelsPlease and 2 or 1

    local innerNoise = frame.txInnerNoise or frame:CreateTexture(nil, "BACKGROUND", frame, 2)
    innerNoise:SetInside(frame, edgeSize, edgeSize)
    innerNoise:SetTexture(I.Media.Themes.NoiseInner, "REPEAT", "REPEAT")
    innerNoise:SetHorizTile(true)
    innerNoise:SetVertTile(true)
    innerNoise:SetBlendMode("ADD")
    innerNoise:SetVertexColor(1, 1, 1, 1)
    innerNoise:Show()

    frame.txInnerNoise = innerNoise
end

function F.CreateInnerShadow(frame, smallVersion)
    local edgeSize = E.twoPixelsPlease and 2 or 1

    local innerShadow = frame.txInnerShadow or frame:CreateTexture(nil, "BACKGROUND", frame, 1)
    innerShadow:SetInside(frame, edgeSize, edgeSize)
    innerShadow:SetTexture(smallVersion and I.Media.Themes.ShadowInnerSmall or I.Media.Themes.ShadowInner)
    innerShadow:SetVertexColor(1, 1, 1, 0.5)
    innerShadow:SetBlendMode("BLEND")
    innerShadow:Show()

    frame.txInnerShadow = innerShadow
end

function F.PerfectScale(n)
    local m = E.mult
    return (m == 1 or n == 0) and n or (n * m)
end

function F.GetDBFromPath(path)
    local paths = { strsplit(".", path) }
    local length = #paths
    local count = 0
    local dbRef = E.db

    for _, key in pairs(paths) do
        if (dbRef == nil) or (not type(dbRef) == "table") then break end

        if (tonumber(key)) then
            key = tonumber(key)
            dbRef = dbRef[key]
            count = count + 1
        else
            local idx

            if (key:find("%b[]")) then
                idx = {}

                for i in key:gmatch("(%b[])") do
                    i = i:match("%[(.+)%]")
                    table.insert(idx, i)
                end

                length = length + #idx
            end

            key = strsplit("[", key)

            if (#key > 0) then
                dbRef = dbRef[key]
                count = count + 1
            end

            if idx and (type(dbRef) == "table") then
                for _, idxKey in ipairs(idx) do
                    idxKey = tonumber(idxKey) or idxKey
                    dbRef = dbRef[idxKey]
                    count = count + 1

                    if (dbRef == nil) or (not type(dbRef) == "table") then break end
                end
            end
        end
    end

    if (count == length) then return dbRef end
    return nil
end

function F.CalculatedAnchoredPositions(frame, data)
    -- Set vars
    local centerX, centerY = E.UIParent:GetCenter()
    local physicalWidth = E.UIParent:GetRight()
    local anchorPoint = "TOP" .. data["direction"]
    local padding = E.db["unitframe"]["units"][data["unitFrame"]]["width"] + data["padding"]

    -- Flip calculated padding if direction is LEFT
    if data["direction"] == "LEFT" then padding = -padding end

    -- Set mover to anchor temporarily
    _G[frame]:ClearAllPoints()
    _G[frame]:SetPoint(anchorPoint, _G[data["anchor"]], anchorPoint, padding, 0)

    -- Get center position of the frame
    local posX, posY = _G[frame]:GetCenter()

    -- Calculate ElvUI anchor point for Y axis
    local finalPoint = "BOTTOM"
    if posY >= centerY then
        finalPoint = "TOP"
        posY = -(E.UIParent:GetTop() - _G[frame]:GetTop())
    else
        posY = _G[frame]:GetBottom()
    end

    -- Calculate ElvUI anchor point for X axis
    if posX >= (physicalWidth * 2 / 3) then
        finalPoint = finalPoint .. "RIGHT"
        posX = _G[frame]:GetRight() - physicalWidth
    elseif posX <= (physicalWidth / 3) then
        finalPoint = finalPoint .. "LEFT"
        posX = _G[frame]:GetLeft()
    else
        posX = posX - centerX
    end

    posX = posX >= 0 and floor(posX + 0.5) or ceil(posX - 0.5)
    posY = posY >= 0 and floor(posY + 0.5) or ceil(posY - 0.5)

    -- Set new mover data with calculated point
    E.db["movers"][frame] = format("%s,ElvUIParent,%s,%s,%s", finalPoint, finalPoint, posX, posY)
end

function F.CheckCacheHearthstoneData()
    local countTotal, countLoaded = 0, 0
    for _, config in pairs(I.HearthstoneData) do
        countTotal = countTotal + 1
        if config.id then countLoaded = countLoaded + 1 end
    end

    if countTotal == countLoaded then I.HearthstoneDataLoaded = true end
end

function F.CacheHearthstoneData()
    for id, config in pairs(I.HearthstoneData) do
        if (config.type == "toy") or (config.type == "item") then
            local itemMixin = CreateFromMixins(ItemMixin)
            itemMixin:SetItemID(id)
            itemMixin:ContinueOnItemLoad(function()
                config.id = id
                config.name = itemMixin:GetItemName()
                config.known = (config.type == "item") and true or PlayerHasToy(id)
                F.CheckCacheHearthstoneData()
            end)
        elseif (config.type == "spell") then
            local spellMixin = CreateFromMixins(SpellMixin)
            spellMixin:SetSpellID(id)
            spellMixin:ContinueOnSpellLoad(function()
                config.id = id
                config.name = spellMixin:GetSpellName()
                config.known = IsSpellKnownOrOverridesKnown(id)
                F.CheckCacheHearthstoneData()
            end)
        end
    end
end