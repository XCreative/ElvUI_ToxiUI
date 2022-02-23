local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local T = TXUI:NewModule("Theme", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Globals
local _G = _G

function T:UpdateTemplateStrata(frame)
    if (frame.txSoftShadow) then
        frame.txSoftShadow:SetFrameLevel(frame:GetFrameLevel())
        frame.txSoftShadow:SetFrameStrata(frame:GetFrameStrata())
    end
end

function T:SetTemplate(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
    template = template or frame.template or "Default"
    glossTex = glossTex or frame.glossTex or nil
    ignoreUpdates = ignoreUpdates or frame.ignoreUpdates or false

    if (ignoreUpdates) then return end

    local isStatusBar = false
    local parent = frame:GetParent()

    if (parent) then
        if (parent.IsObjectType) and (parent:IsObjectType("Texture") or parent:IsObjectType("Statusbar")) then
            isStatusBar = true
        elseif (E.statusBars[parent] ~= nil) then
            isStatusBar = true
        end
    end

    local skinForUnitFrame = isUnitFrameElement and (not isNamePlateElement)
    local skinForTransparent = (template == "Transparent") and (not isNamePlateElement) and (not isStatusBar)
    local skinForTexture = (template == "Default" and (not glossTex)) and (not isUnitFrameElement) and
                               (not isNamePlateElement) and (not isStatusBar)

    -- Transparent & UnitFrames
    if (skinForTransparent or skinForUnitFrame or isStatusBar) and
        (self.db and self.db.enabled and self.db.shadowEnabled) then
        if (not frame.TXCreateSoftShadow) then
            return self:DebugPrint("API function TXCreateSoftShadow not found!")
        end

        frame:TXCreateSoftShadow(self.db.shadowSize, self.db.shadowAlpha)
    else
        if (frame.txSoftShadow) then frame.txSoftShadow:Hide() end
    end

    -- Transparent
    if (skinForTransparent or skinForTexture) and (self.db and self.db.enabled) then
        if (not frame.TXCreateInnerNoise) or (not frame.TXCreateInnerShadow) then
            return self:DebugPrint("API functions not found!", "TXCreateInnerNoise", (not frame.TXCreateInnerNoise),
                                   "TXCreateInnerShadow", (not frame.TXCreateInnerShadow))
        end

        -- Needed for Tooltips, since those are no longer Backdrop Templates
        -- ElvUI needs to fix their tooltip skinning for the NineSlice change Blizzard did (when/if they notice .....)
        -- Ref: https://github.com/Gethe/wow-ui-source/blob/4b8a0a911090d4679db954d61291a852db9542fe/Interface/AddOns/Blizzard_Deprecated/Deprecated_9_1_5.lua
        if (frame.Center ~= nil) then
            frame.Center:SetDrawLayer("BACKGROUND", -7)
        end

        frame:TXCreateInnerNoise()
        frame:TXCreateInnerShadow(skinForTexture)
    else
        if (frame.txInnerNoise) then frame.txInnerNoise:Hide() end
        if (frame.txInnerShadow) then frame.txInnerShadow:Hide() end
    end
end

function T:SetTemplateAS(_, frame, template, _)
    self:SetTemplate(frame, template)
end

function T:API(object)
    local mt = getmetatable(object).__index

    -- No api attached?
    if (not mt.SetTemplate) then
        return self:DebugPrint("Could not find SetTemplate Meta Function", object:GetObjectType())
    end

    -- Create TX functions
    if (not mt.TXCreateInnerShadow) then mt.TXCreateInnerShadow = F.CreateInnerShadow end
    if (not mt.TXCreateInnerNoise) then mt.TXCreateInnerNoise = F.CreateInnerNoise end
    if (not mt.TXCreateSoftShadow) then mt.TXCreateSoftShadow = F.CreateSoftShadow end

    -- Hook elvui template
    if (not self:IsHooked(mt, "SetTemplate")) then
        self:SecureHook(mt, "SetTemplate", "SetTemplate")
        -- self:DebugPrint("Hooked type", object:GetObjectType())
    end

    -- Hook FrameLevel
    if (mt.SetFrameLevel) and (not self:IsHooked(mt, "SetFrameLevel")) then
        self:SecureHook(mt, "SetFrameLevel", "UpdateTemplateStrata")
    end

    -- Hook FrameStrata
    if (mt.SetFrameStrata) and (not self:IsHooked(mt, "SetFrameStrata")) then
        self:SecureHook(mt, "SetFrameStrata", "UpdateTemplateStrata")
    end
end

function T:UpdateClubInfo(frame, clubInfo)
    local cI = clubInfo or frame.clubInfo
    if (not cI) or (not cI.clubId) or (clubInfo.clubId ~= 156744552) then return end

    frame.Icon:SetBlendMode("DISABLE")
    frame.Icon:SetTexture(I.Media.Logos.LogoSmall)
    frame.Icon:SetTexCoord(unpack(E.TexCoords))
end

function T:ForceRefresh()
    -- Refresh Templates
    E:UpdateFrameTemplates()

    -- Refresh all media
    E:UpdateMediaItems(true)
end

function T:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function T:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function T:Disable()
    self:UnregisterAllEvents()

    -- Force refresh to disable theme
    if (self.Initialized) and (self.db) and (not self.db.enabled) then self:ForceRefresh() end

    self:UnhookAll()
end

function T:Enable()
    -- Unregister events
    self:UnregisterAllEvents()

    -- AddOnSkins Skinning
    TXUI:GetModule("Skins"):AddCallbackForAddon("AddOnSkins", function()
        local as = _G.AddOnSkins and _G.AddOnSkins[1]
        if (not as) then return end
        self:SecureHook(as, "SetTemplate", "SetTemplateAS")
        as:UpdateSettings()
    end)

    TXUI:GetModule("Skins"):AddCallbackForAddon("Blizzard_Communities", function()
        local communitiesListEntryMixin = _G.CommunitiesListEntryMixin
        self:SecureHook(communitiesListEntryMixin, "SetAddCommunity", "UpdateClubInfo")
        self:SecureHook(communitiesListEntryMixin, "SetFindCommunity", "UpdateClubInfo")
        self:SecureHook(communitiesListEntryMixin, "SetGuildFinder", "UpdateClubInfo")
        self:SecureHook(communitiesListEntryMixin, "SetClubInfo", "UpdateClubInfo")
    end)

    -- Scan all MetaTables
    self:MetatableScan()

    -- Force Refresh
    self:ForceRefresh()
end

function T:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.addons.elvUITheme

    if self.db and self.db.enabled then
        if (self.Initialized) then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

function T:MetatableScan()
    -- Register API and hook frames
    local handled = { Frame = true }
    local object = CreateFrame("Frame")
    self:API(object)
    self:API(object:CreateTexture())
    self:API(object:CreateFontString())
    self:API(object:CreateMaskTexture())
    self:API(_G.GameFontNormal)
    self:API(CreateFrame("ScrollFrame"))

    object = EnumerateFrames()
    while object do
        if (not object:IsForbidden()) and (not handled[object:GetObjectType()]) then
            self:API(object)
            handled[object:GetObjectType()] = true
        end

        object = EnumerateFrames(object)
    end
end

function T:Initialize(worldInit)
    -- Set db
    self.db = E.db.TXUI.addons.elvUITheme

    -- Don't init second time
    if self.Initialized then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return

        -- Register start events
    elseif (not worldInit) then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        return
    end

    -- Og, og
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(T:GetName())
