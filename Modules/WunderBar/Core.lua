local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:NewModule("WunderBar", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
WB:SetDefaultModuleLibraries("AceEvent-3.0")

-- Globals
local find = string.find
local format = string.format
local gsub = string.gsub
local InCombatLockdown = InCombatLockdown
local strsplit = strsplit
local type = type

-- Vars
WB.isEnabled = false
WB.isVisible = false
WB.isMouseOver = false

WB.registeredModules = {}
WB.registeredModulesNames = {}

function WB:RegisterSubModule(subModule, events)
    -- Since we don't load submodules over the core function, pre-init them here
    TXUI:ModulePreInitialize(subModule)

    local data = {}
    data.name = subModule:GetName()
    data.events = type(events) == "string" and { strsplit("[, ]", events) } or events

    local displayName = format(data.name)

    if find(displayName, "ElvUI:") then
        displayName = gsub(displayName, "ElvUI:", "|cff999999ElvUI:|r")
    elseif find(displayName, "LDB:") then
        displayName = gsub(displayName, "LDB:", "|cff999999LDB:|r")
    else
        displayName = TXUI.Title .. ": " .. displayName .. "|r"
    end

    self.registeredModules[data.name] = data
    self.registeredModulesNames[data.name] = displayName

    return data
end

function WB:EnableDebugMode()
    if (not self.isEnabled) then return end

    local debugColors = {
        { 240, 71, 43 }, { 228, 154, 38 }, { 241, 196, 15 }, { 111, 184, 66 }, { 68, 156, 199 }, { 74, 119, 193 },
        { 129, 71, 212 }, { 201, 83, 161 }, { 176, 177, 161 }, { 108, 120, 116 }
    }

    for _, module in ipairs(self.moduleFrames) do
        module:CreateBackdrop()
        module.backdrop:SetBackdropColor(debugColors[module.moduleIndex][1] / 255,
                                         debugColors[module.moduleIndex][2] / 255,
                                         debugColors[module.moduleIndex][3] / 255, 1)
    end
end

function WB:Disable()
    self:CancelAllTimers()
    self:UnregisterAllEvents()
    self:UnhookAll()

    self.isEnabled = false
    self.isVisible = false
    self.isMouseOver = false

    if self.Initialized then
        if (self.bar) then
            self.bar:SetAlpha(0)
            self.bar:Hide()
        end

        self:StopAllAnimations()
        self:DisableAllModules()
    end
end

function WB:Enable()
    self:UnregisterAllEvents()
    self.isEnabled = true
    self.isVisible = false
    self.isMouseOver = false

    -- Register event
    self:RegisterEvent("PLAYER_REGEN_ENABLED", self.CheckVisibility, self)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", self.CheckVisibility, self)
    self:RegisterEvent("PLAYER_UPDATE_RESTING", self.CheckVisibility, self)
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.CheckVisibility, self)
    self:RegisterEvent("PET_BATTLE_CLOSE", self.CheckVisibility, self)
    self:RegisterEvent("PET_BATTLE_OPENING_START", self.CheckVisibility, self)

    -- Register Scripts
    self:SecureHookScript(self.bar, "OnEnter", "BarOnEnter")
    self:SecureHookScript(self.bar, "OnLeave", "BarOnLeave")
    self:SecureHookScript(self.bar, "OnUpdate", "BarOnUpdate")

    -- Show yourself you wunderbare bar
    self.bar:Show()
    self.bar:SetAlpha(0)

    -- Update
    self:UpdateBar()
    self:UpdatePanelSubModules()
end

function WB:IsEnabled()
    return self.isEnabled
end

function WB:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function WB:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function WB:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.wunderbar

    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if TXUI:HasRequirements(I.Requirements.WunderBar) and (self.db and self.db.general and self.db.general.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

--[[ Initialization ]] --
function WB:Initialize(worldInit)
    -- Don't init second time
    if self.Initialized then return end

    -- Get db
    self.db = E.db.TXUI.wunderbar

    -- If disable don't do anything
    if (not self.db) or (not self.db.general.enabled) or (not TXUI:HasRequirements(I.Requirements.WunderBar)) then
        return
    end

    -- Register start events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- We stop here if we are not from a entered world call
    if (not worldInit) then return end

    -- Register ElvUI & LDB DataText
    self:RegisterElvUIDatatexts()
    self:RegisterLDBDatatexts()

    -- Show conflict message with XIV
    if F.IsAddOnEnabled("XIV_Databar") then
        local popup = E.PopupDialogs.INCOMPATIBLE_ADDON
        popup.button2 = TXUI.Title .. " WunderBar"
        popup.button1 = "XIV"
        popup.button3 = nil
        popup.module = popup.button2
        popup.addon = "XIV_Databar"
        popup.accept = function()
            E.db.TXUI.wunderbar.general.enabled = false;
            ReloadUI()
        end
        popup.cancel = function(dialog)
            DisableAddOn(dialog.addon)
            ReloadUI()
        end

        E:StaticPopup_Show("INCOMPATIBLE_ADDON", popup.button1, popup.button2)
    end

    -- Cache hearthstone data
    F.CacheHearthstoneData()

    -- Construct
    self:ConstructBar()
    self:ConstructModules()

    -- Enable
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(WB:GetName())
