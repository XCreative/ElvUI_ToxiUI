local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local DT = TXUI:NewModule("ThemesDarkTransparency", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local _G = _G
local HOSTILE_REACTION = _G.HOSTILE_REACTION
local pairs = pairs
local select = select
local UnitClass = UnitClass
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

-- Vars
local UF
local LSM

function DT:PostUpdateColor(health, unit, r, g, b)
    if (not self.db) or (not self.db.enabled) then return end

    -- Vars
    local frame = health:GetParent()
    local elvUIColors = E.db.unitframe.colors

    -- fallback for bg if custom settings arent used
    if (not b) then r, g, b = elvUIColors.health.r, elvUIColors.health.g, elvUIColors.health.b end

    -- Charmed player should have hostile color
    if (unit) then
        if (not UnitIsDeadOrGhost(unit)) and UnitIsConnected(unit) and UnitIsCharmed(unit) and
            UnitIsEnemy("player", unit) then
            local color = frame.colors.reaction[HOSTILE_REACTION]
            if color then health:SetStatusBarColor(color[1], color[2], color[3]) end
        end
    end

    -- Handle Health Background
    if (health.bg) then
        -- Hide bg completly
        health.bg:SetAlpha(0)

        -- Save ref
        if (not self.healthBackgroundRefs[frame.Health.bg]) then
            self.healthBackgroundRefs[frame.Health.bg] = true
        end
    end

    -- Handle Health Backdrop
    if (health.backdrop) then

        -- From ElvUI: Get how mutch the background should darken
        health.bg.multiplier = (elvUIColors.healthMultiplier > 0 and elvUIColors.healthMultiplier) or 0.35

        -- Custom Dead backdrop
        if elvUIColors.useDeadBackdrop and (unit and UnitIsDeadOrGhost(unit)) then
            health.backdrop:SetBackdropColor(elvUIColors.health_backdrop_dead.r, elvUIColors.health_backdrop_dead.g,
                                             elvUIColors.health_backdrop_dead.b, self.transparencyAlpha)

        elseif elvUIColors.customhealthbackdrop then -- Custom Health Backdrop if not dead
            health.backdrop:SetBackdropColor(elvUIColors.health_backdrop.r, elvUIColors.health_backdrop.g,
                                             elvUIColors.health_backdrop.b, self.transparencyAlpha)

        elseif elvUIColors.classbackdrop and unit then
            local classColor

            if UnitIsPlayer(unit) then
                local unitClass = select(2, UnitClass(unit))
                classColor = frame.colors.class[unitClass]
            else
                local reaction = UnitReaction(unit, "player")
                if (reaction) then classColor = frame.colors.reaction[reaction] end
            end

            if (classColor) then
                health.backdrop:SetBackdropColor(classColor[1] * health.bg.multiplier,
                                                 classColor[2] * health.bg.multiplier,
                                                 classColor[3] * health.bg.multiplier, self.transparencyAlpha)
            end
        else
            health.backdrop:SetBackdropColor(r * health.bg.multiplier, g * health.bg.multiplier,
                                             b * health.bg.multiplier, self.transparencyAlpha)
        end
    end
end

function DT:UpdateStatusBarFrame(frame)
    if (not self.db) or (not self.db.enabled) then return end
    if (not frame) or (not frame.Health) then return end

    -- Handle Health Background
    if (frame.Health.bg) then
        -- Hide bg completly
        frame.Health.bg:SetAlpha(0)

        -- Save ref
        if (not self.healthBackgroundRefs[frame.Health.bg]) then
            self.healthBackgroundRefs[frame.Health.bg] = true
        end
    end

    -- Set ElvUI vars
    frame.Health.isTransparent = true
    frame.Health.invertColors = nil
    frame.Health.backdropTex = frame.Health.bg

    -- Set transparent backdrop template instead of the default one
    if frame.Health.backdrop then
        frame.Health.backdrop:SetTemplate("Transparent", nil, nil, nil, true)
        frame.Health.backdrop:SetBackdropColor(0, 0, 0, self.transparencyAlpha)
    end

    -- Update StatusBar Texture
    frame.Health:SetStatusBarTexture(LSM:Fetch("statusbar", UF.db.statusbar))

    -- From ElvUI: This fixes Center Pixel offset problem
    local barTexture = frame.Health:GetStatusBarTexture()
    barTexture:SetInside(nil, 0, 0)

    -- Anchor correctly
    UF:SetStatusBarBackdropPoints(frame.Health, barTexture, frame.Health.bg, frame.Health:GetOrientation(),
                                  frame.db.health and frame.db.health.reverseFill)

    -- Hook if needed
    if (not self:IsHooked(frame.Health, "PostUpdateColor")) then
        self:RawHook(frame.Health, "PostUpdateColor", "PostUpdateColor")
    end
end

function DT:ConfigureStatusBarFrame(_, frame)
    self:UpdateStatusBarFrame(frame)
end

function DT:UpdateStatusBar(_, frame)
    if (not self.db) or (not self.db.enabled) then return end
    if (not frame) then return end

    local parentFrame = frame:GetParent()

    if (not parentFrame) then return end

    self:UpdateStatusBarFrame(parentFrame)
end

function DT:UpdateStatusBars()
    for frame in pairs(UF.statusbars) do if frame then self:UpdateStatusBar(nil, frame) end end
end

function DT:SetTextureHealComm(_, frame)
    if (not self.db) or (not self.db.enabled) then return end

    frame.myBar:SetStatusBarTexture(E.media.blankTex)
    frame.otherBar:SetStatusBarTexture(E.media.blankTex)
    frame.absorbBar:SetStatusBarTexture(E.media.blankTex)
    frame.healAbsorbBar:SetStatusBarTexture(E.media.blankTex)
end

function DT:ForceUpdate()
    -- We check a non specific DB entry to see if the DB is populated
    if UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction then UF:Update_AllFrames() end
end

function DT:UpdateSettings()
    -- Update Alpha settings
    self.transparencyAlpha = self.db.transparencyAlpha

    -- Update ElvUI
    self:ForceUpdate()
end

function DT:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function DT:Disable()
    self:UnregisterAllEvents()
    self:UnhookAll()

    -- Restore alpha values
    if (self.healthBackgroundRefs) then
        for frameBg, _ in pairs(self.healthBackgroundRefs) do
            frameBg:SetAlpha(1)
            self.healthBackgroundRefs[frameBg] = nil
        end
    end

    -- Update ElvUI
    if (self.Initialized) then self:ForceUpdate() end
end

function DT:Enable()
    self:UpdateSettings()
    self:UnregisterAllEvents()

    -- Hook functions
    self:SecureHook(UF, "Configure_HealthBar", "ConfigureStatusBarFrame")
    self:RawHook(UF, "SetTexture_HealComm", "SetTextureHealComm")

    -- Hook functions for update functions
    self:SecureHook(UF, "Update_StatusBars", "UpdateStatusBars")
    self:SecureHook(UF, "Update_StatusBar", "UpdateStatusBar")

    UF:Update_AllFrames()
end

function DT:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.themes.darkMode

    if TXUI:HasRequirements(I.Requirements.DarkModeTransparency) and
        (self.db and self.db.enabled and self.db.transparency) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function DT:Initialize()
    -- Set db
    self.db = E.db.TXUI.themes.darkMode

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.DarkModeTransparency)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) or (not self.db.transparency) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- Get Framework
    UF = E:GetModule("UnitFrames")
    LSM = E.Libs.LSM

    -- Array to safe background references for the disable function
    self.healthBackgroundRefs = {}

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(DT:GetName())
