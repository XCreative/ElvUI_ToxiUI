local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local _G = _G
local pairs = pairs
local tinsert = table.insert
local xpcall = xpcall

-- Core Variables
TXUI.AddOnColorRGB = { 0, 228 / 255, 245 / 255 }
TXUI.AddOnColorRGBA = { r = TXUI.AddOnColorRGB[1], g = TXUI.AddOnColorRGB[2], b = TXUI.AddOnColorRGB[3], a = 1 }
TXUI.Title = "|cffffffffToxi|r|cff00e4f5UI|r"
TXUI.ReleaseVersion = 0 -- for internal tracking, this is populated inside the changelog module
TXUI.Changelog = {}
TXUI.Links = {
    ["DiscordToxi"] = "https://discord.gg/T7J4mNv",
    ["WALink"] = "https://luxthos.com",
    ["SkinIcons"] = "https://wago.io/IconSkins"
}

-- Modules
TXUI.RegisteredModules = {}

local function errorhandler(err)
    return _G.geterrorhandler()(err)
end

function TXUI:RegisterModule(name)
    if not (self.RegisteredModules[name]) then tinsert(self.RegisteredModules, name) end
end

function TXUI.UpdateProfiles()
    TXUI:DBConvert()

    for _, moduleName in pairs(TXUI.RegisteredModules) do
        local module = TXUI:GetModule(moduleName)
        if module.ProfileUpdate then module:ProfileUpdate() end
    end
end

--[[ EnteredWorld ]] --
do
    local eventFired = false
    function TXUI:EnteredWorld()
        if (not eventFired) then
            E:Delay(8, self.EnteredWorld, self)
            eventFired = true
        else
            TXUI.DelayedWorldEntered = true

            -- Show Dev Mode or Tester Message
            if (self.DevRelease) then
                local isDev = F.IsDeveloper()
                local entryName = F.GetChatIconEntryName() or "Person"
                local prettyName = isDev and F.FastTextGradient(entryName, 0, 0.9, 1, 0, 0.6, 1) or
                                       F.FastTextGradient("awesome " .. entryName, 0.57, 0.92, 0.49, 0.38, 0.81, 0.43)
                local message = isDev and ("Dev features are " .. F.StringError("active")) or
                                    ("Debug mode is " .. F.StringError("enabled"))
                self:DebugPrint("Initialize > Hello " .. prettyName .. "!", message)
                F.PrintDelayedDebugMessages()
            end
        end
    end
end

function TXUI:ModulePreInitialize(module)
    module.Print = F.Print
    module.Printf = F.Printf
    module.DebugPrint = F.DebugPrint
    module.DebugPrintf = F.DebugPrintf
end

function TXUI:InitializeModules()
    -- Setup stuff for devs
    self:SetupDevConfigs()

    -- Changelog first, most important for all functions
    do
        local module = self:GetModule("Changelog")
        self:ModulePreInitialize(module)
        if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
    end

    -- Convet DBs, after changelog is loaded but before anything else
    self:DBConvert()

    -- Skins, second most important
    do
        local module = self:GetModule("Skins")
        self:ModulePreInitialize(module)
        if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
    end

    -- Options, third most important
    do
        local module = self:GetModule("Options")
        self:ModulePreInitialize(module)
        if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
    end

    -- All other modules that are registered the normal way
    for _, moduleName in pairs(TXUI.RegisteredModules) do
        local module = self:GetModule(moduleName)
        self:ModulePreInitialize(module)
        if module.Initialize then xpcall(module.Initialize, errorhandler, module) end
    end

    -- Init Popups
    self:LoadStaticPopups()

    -- Init commands
    self:LoadCommands()
end
