local E, _, V, P, G = unpack(_G.ElvUI)
local EP = E.Libs.EP
local addonName, addon = ...

local _G = _G
local find = string.find
local GetAddOnMetadata = GetAddOnMetadata
local tonumber = tonumber

local TXUI = E.Libs.AceAddon:NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

V.TXUI = {}
P.TXUI = {}
G.TXUI = {}

local F = {}
local I = {}

addon[1] = TXUI
addon[2] = F
addon[3] = E
addon[4] = I
addon[5] = V.TXUI
addon[6] = P.TXUI
addon[7] = G.TXUI
_G[addonName] = addon

TXUI.AddOnName = addonName
TXUI.GitHash = GetAddOnMetadata(addonName, "X-GitHash")
TXUI.DevRelease = false
TXUI.DevTag = ""
TXUI.DelayedWorldEntered = false

TXUI.Modules = {}
TXUI.Modules.Changelog = TXUI:NewModule("Changelog", "AceEvent-3.0", "AceTimer-3.0")
TXUI.Modules.Options = TXUI:NewModule("Options")
TXUI.Modules.Skins = TXUI:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")

--[[ Initialization ]] --
function TXUI:Initialize()
    -- Don't init second time
    if self.initialized then return end

    -- Call pre init for ourselfs
    self:ModulePreInitialize(self)

    -- Mark dev release
    if self.GitHash then
        if find(self.GitHash, "alpha") then
            self.DevTag = F.StringError("[ALPHA]")
        elseif find(self.GitHash, "beta") then
            self.DevTag = F.StringError("[BETA]")
        elseif find(self.GitHash, "project%-version") then
            self.GitHash = "DEV" -- will be filled by changelog
            self.DevTag = F.StringError("[DEV]")
        end

        self.DevRelease = (self.DevTag ~= "")
    end

    -- Check required ElvUI Version
    local ElvUIVersion = tonumber(E.version)
    local RequiredVersion = tonumber(GetAddOnMetadata(self.AddOnName, "X-ElvUIVersion"))

    -- ElvUI's version check
    if ElvUIVersion < 1 or (ElvUIVersion < RequiredVersion) then
        E:Delay(2, function()
            E:StaticPopup_Show("ELVUI_UPDATE_AVAILABLE")
        end)
        return
    end

    -- Force ElvUI Setup to hide
    E.private.install_complete = E.version

    -- Late init event
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "EnteredWorld")

    -- Lets go!
    self:InitializeModules()

    -- Register Plugin
    EP:RegisterPlugin(self.AddOnName, function()
        return self:GetModule("Options"):OptionsCallback()
    end)

    -- Monitor ElvUI Profile updated
    self:SecureHook(E, "StaggeredUpdateAll", "UpdateProfiles")

    -- Set initialized
    self.initialized = true
end

EP:HookInitialize(TXUI, TXUI.Initialize)
