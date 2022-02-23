local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")
local LSM = E.Libs.LSM

local _G = _G
local format = string.format
local next = next
local pairs = pairs
local tinsert = table.insert
local type = type
local xpcall = xpcall

O.txUIDisabled = function()
    return not F.IsTXUIProfile()
end

O.enabledState = F.Enum { "YES", "NO", "FORCE_DISABLED" }
O.orderIndex = 1
O.callOnInit = {}
O.options = {
    themes = {
        order = 2,
        type = "group",
        group = "tab",
        name = F.FastTextGradient("Themes", 0, 0.9, 1, 0, 0.6, 1),
        desc = "Toggle between Original, Gradient & Dark modes",
        icon = I.Media.Icons.Themes,
        hidden = O.txUIDisabled,
        args = {}
    },
    wunderbar = {
        order = 3,
        type = "group",
        group = "tab",
        name = F.FastTextGradient("WunderBar", 0.57, 0.92, 0.49, 0.38, 0.81, 0.43),
        desc = "Configure all options for the bottom bar",
        icon = I.Media.Icons.WunderBar,
        hidden = O.txUIDisabled,
        args = {}
    },
    addons = {
        order = 4,
        type = "group",
        group = "tab",
        name = F.FastTextGradient("AddOns", 0.95, 0.420, 0.420, 0.89, 0.19, 0.39),
        desc = "Configure features for additional AddOns we support",
        icon = I.Media.Icons.Addons,
        hidden = O.txUIDisabled,
        args = {}
    },
    plugins = {
        order = 5,
        type = "group",
        group = "tab",
        name = F.FastTextGradient("Plugins", 0.70, 0.55, 0.94, 0.62, 0.32, 1),
        desc = "Extra features for ElvUI",
        icon = I.Media.Icons.Plugins,
        hidden = O.txUIDisabled,
        args = {}
    },
    information = {
        order = 6,
        type = "group",
        group = "tab",
        name = F.FastTextGradient("Information", 0.93, 0.79, 0.36, 0.89, 0.65, 0.19),
        desc = "Changelog & other important information",
        icon = I.Media.Icons.Information,
        args = {}
    }
}

-- Error handler
local function errorhandler(err)
    return _G.geterrorhandler()(err)
end

function O:GetAllFontsFunc()
    return function()
        return LSM:HashTable("font")
    end
end

function O:GetAllFontOutlinesFunc()
    return function()
        return {
            NONE = "None",
            OUTLINE = "Outline",
            THICKOUTLINE = "Thick",
            MONOCHROME = "Monochrome",
            MONOCHROMEOUTLINE = "Monochrome Outline",
            MONOCHROMETHICKOUTLINE = "Monochrome Thick"
        }
    end
end

function O:GetAllFontColorsFunc(additional)
    local colorSelection = {
        NONE = "None",
        CLASS = F.StringClass("Class Color"),
        VALUE = F.StringElvUIValue("ElvUI Color"),
        TXUI = TXUI.Title .. F.StringToxiUI(" Color"),
        COVENANT = F.StringCovenant("Covenant Color"),
        CUSTOM = "Custom"
    }

    return function()
        return E:CopyTable(colorSelection, additional or {})
    end
end

function O:GetFontColorGetter(profileDB, defaultDB, customKey)
    return function(info)
        local key = customKey or info[#info]
        local profileEntry = F.GetDBFromPath(profileDB)[key]
        local defaultEntry = defaultDB[key]
        return profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a, defaultEntry.r, defaultEntry.g,
               defaultEntry.b, defaultEntry.a
    end
end

function O:GetFontColorSetter(profileDB, callback, customKey)
    return function(info, r, g, b, a)
        local key = customKey or info[#info]
        local profileEntry = F.GetDBFromPath(profileDB)[key]
        profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a = r, g, b, a
        callback()
    end
end

function O:GetEnabledState(check, group)
    local enabled = (check == true)
    local forceDisabled = false

    if group and group.disabled then
        if type(group.disabled) == "boolean" then
            forceDisabled = group.disabled
        elseif type(group.disabled) == "function" then
            forceDisabled = group.disabled()
        end
    end

    if (enabled and enabled == true) and (not forceDisabled) then
        return self.enabledState.YES
    elseif (not forceDisabled) then
        return self.enabledState.NO
    end

    return self.enabledState.FORCE_DISABLED
end

function O:GetEnableName(check, group)
    local enabled = self:GetEnabledState(check, group)

    if enabled == self.enabledState.YES then
        return F.StringGood("Enabled")
    elseif enabled == self.enabledState.NO then
        return F.StringError("Disabled")
    end

    return "Disabled"
end

function O:AddGroup(options, others)
    local orderIdx = self:GetOrder()
    local group = { order = orderIdx, type = "group", args = {} }
    E:CopyTable(group, others)
    options["fancyInlineGroup" .. orderIdx] = group
    return options["fancyInlineGroup" .. orderIdx]
end

function O:AddInlineGroup(options, others)
    local orderIdx = self:GetOrder()
    local group = { order = orderIdx, inline = true, type = "group", args = {} }
    E:CopyTable(group, others)
    options["fancyInlineGroup" .. orderIdx] = group
    return options["fancyInlineGroup" .. orderIdx]
end

function O:AddDesc(options, othersGroup, othersDesc)
    local orderIdx = self:GetOrder()
    local inlineGroup = self:AddGroup(options, othersGroup)
    local group = { order = orderIdx, type = "description" }
    E:CopyTable(group, othersDesc)
    inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
    return inlineGroup
end

function O:AddInlineDesc(options, othersGroup, othersDesc)
    local orderIdx = self:GetOrder()
    local inlineGroup = self:AddInlineGroup(options, othersGroup)
    local group = { order = orderIdx, type = "description" }
    E:CopyTable(group, othersDesc)
    inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
    return inlineGroup
end

function O:AddInlineSoloDesc(options, othersDesc)
    local orderIdx = self:GetOrder()
    local group = { order = orderIdx, type = "description" }
    E:CopyTable(group, othersDesc)
    options["fancyInlineDesc" .. orderIdx] = group
    return group
end

function O:AddInlineRequirementsDesc(options, othersGroup, othersDesc, requirements)
    local orderIdx = self:GetOrder()
    local inlineGroup = self:AddInlineGroup(options, othersGroup)
    local group = { order = orderIdx, type = "description" }
    E:CopyTable(group, othersDesc)

    inlineGroup.disabled = function()
        return not TXUI:HasRequirements(requirements)
    end

    -- Define if not defined
    if (not group["name"]) then group["name"] = "" end

    -- Convert to function
    if type(group["name"]) == "string" then
        local originalText = "" .. group["name"]

        group["name"] = function()
            local description = "" .. originalText
            local check = TXUI:CheckRequirements(requirements)
            if (check and check ~= true) then
                local reason = TXUI:GetRequirementString(check)
                if (reason) then description = description .. F.StringError(reason) .. "\n\n" end
            end
            return description
        end
    else
        self:DebugPrint("GroupName is not a string, cannot convert to requirements check")
    end

    inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
    return inlineGroup
end

function O:AddSpacer(options, big)
    options["fancySpacer" .. self:GetOrder()] = {
        order = self:GetOrder(),
        type = "description",
        name = big and "\n\n" or "\n"
    }
    return options["fancySpacer" .. self:GetOrder()]
end

function O:AddTinySpacer(options)
    options["fancySpacer" .. self:GetOrder()] = { order = self:GetOrder(), type = "description", name = "" }
    return options["fancySpacer" .. self:GetOrder()]
end

function O:GetOrder()
    self.orderIndex = self.orderIndex + 1
    return self.orderIndex
end

function O:ResetOrder()
    self.orderIndex = 1
end

function O:AddCallback(name, func)
    -- Don't load any other settings except general and changelog when TXUI is not installed
    if not F.IsTXUIProfile() and (name ~= "Information" and name ~= "General" and name ~= "Changelog") then return end

    tinsert(self.callOnInit, func or self[name])
end

function O:OptionsCallback()
    -- Well, something went wrong, like really wrong
    if not self.Initialized then return end

    -- Add name at the top of elvui
    E.Options.name = E.Options.name .. " + " .. TXUI.Title ..
                         format(" |cff99ff33%s|r", TXUI:GetModule("Changelog"):FormattedVersion())

    -- Header Logo and Tab Panel
    E.Options.args.TXUI = {
        type = "group",
        childGroups = "tree",
        name = TXUI.Title .. " " .. (TXUI.DevRelease and TXUI.DevTag or ""),
        args = {
            logo = {
                order = 1,
                type = "description",
                name = "",
                image = function()
                    return I.Media.Logos.Logo, 256, 128
                end
            }
        }
    }

    -- Fill the options table
    for catagory, info in pairs(self.options) do
        E.Options.args.TXUI.args[catagory] = {
            order = info.order,
            type = "group",
            childGroups = info.group,
            name = info.name,
            desc = info.desc,
            hidden = info.hidden,
            icon = info.icon,
            args = info.args
        }
    end
end

--[[ Initialization ]] --
function O:Initialize()
    -- Don't init second time
    if self.Initialized then return end

    -- Call registered submodules
    for index, func in next, self.callOnInit do
        xpcall(func, errorhandler, self)
        self.callOnInit[index] = nil
    end

    -- Removing settings tab when not installed
    if not F.IsTXUIProfile() then self.options.settings = nil end

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(O:GetName())
