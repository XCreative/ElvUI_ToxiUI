local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local GR = TXUI:NewModule("ThemesGradients", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local _G = _G
local gsub = string.gsub
local select = select
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitThreatSituation = UnitThreatSituation
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay
local ALTERNATE_POWER_INDEX = _G.Enum.PowerType.Alternate or 10

-- Vars
local UF

function GR:GetUnitFrameType(frame)
    if frame then
        if frame.unitframeType then
            return frame.unitframeType
        else
            local parent = frame:GetParent()
            if parent and parent.unitframeType then return parent.unitframeType end
        end
    end
end

function GR:CalculateBackdropColor(eColors, r, g, b, fadeColorR, fadeColorG, fadeColorB, calculateBackupBG)
    local elvUIColors = eColors or E.db.unitframe.colors
    local multiplier = (elvUIColors.healthMultiplier > 0 and elvUIColors.healthMultiplier) or 0.35

    if (not calculateBackupBG) and elvUIColors.customhealthbackdrop then
        r, g, b = elvUIColors.health_backdrop.r, elvUIColors.health_backdrop.g, elvUIColors.health_backdrop.b
        calculateBackupBG = true
    end

    if (calculateBackupBG) then
        fadeColorR, fadeColorG, fadeColorB = self:CalculateBackupColor(r, g, b)
    else
        r, g, b = F.CalculateMultiplierColor(multiplier, r, g, b)
        fadeColorR, fadeColorG, fadeColorB = F.CalculateMultiplierColor(multiplier, fadeColorR, fadeColorG, fadeColorB)
    end

    return multiplier, r, g, b, fadeColorR, fadeColorG, fadeColorB
end

function GR:CalculateBackupColor(r, g, b)
    return F.CalculateMultiplierColor(I.GradientMode.BackupMultiplier, r, g, b)
end

--[[ UnitFrame Health Gradient ]] --
function GR:PostUpdateHealthColor(health, unit, r, g, b)
    if (not self.db) or (not self.db.enabled) then return end

    -- Get Parent frame
    local frame = health:GetParent()

    -- Get type of unit, raid, party, focus etc
    local unitType = self:GetUnitFrameType(frame)
    if (not unitType) then return self:DebugPrint("UnitFrame Type was empty for frame", unitType) end

    -- Get direction we want
    local fadeMode = I.Enum.GradientMode.Mode.HORIZONTAL
    local fadeDirection = self.leftFrames[unitType] and I.Enum.GradientMode.Direction.LEFT or
                              (self.rightFrames[unitType] and I.Enum.GradientMode.Direction.RIGHT)

    -- Default to top-to-bottom mode when no direction is defined
    if (not fadeDirection) then
        fadeMode = I.Enum.GradientMode.Mode.VERTICAL
        fadeDirection = I.Enum.GradientMode.Direction.RIGHT
    end

    -- Vars
    local hpPercent = health.cur / health.max
    local elvUIColors = E.db.unitframe.colors
    local fadeColorR, fadeColorG, fadeColorB
    local calculateBackupFG, colorMap, colorEntry

    -- Get Online status
    local isPlayer = UnitIsPlayer(unit) or UnitTreatAsPlayerForDisplay(unit)
    local playerConnected = UnitIsConnected(unit)
    local playerControlled = UnitPlayerControlled(unit)

    -- Check if we can use the colormap or generate colors ourself
    if (isPlayer) and (not UnitIsDeadOrGhost(unit)) and (playerConnected) and (UnitIsCharmed(unit)) and
        UnitIsEnemy("player", unit) then
        calculateBackupFG = false
        colorMap = self.db.reactionColorMap
        colorEntry = "BAD"
    elseif (health.colorDisconnected) and (not playerConnected) then
        calculateBackupFG = false
        colorMap = self.db.specialColorMap
        colorEntry = "DISCONNECTED"
    elseif (health.colorTapping) and (not playerControlled) and (UnitIsTapDenied(unit)) then
        calculateBackupFG = false
        colorMap = self.db.specialColorMap
        colorEntry = "TAPPED"
    elseif (health.colorThreat) and (not playerControlled) and (UnitThreatSituation("player", unit)) then
        calculateBackupFG = true
    elseif ((health.colorClass and (isPlayer)) or (health.colorClassNPC and (not isPlayer))) or
        ((health.colorClassPet or health.colorPetByUnitClass) and (playerControlled) and (not isPlayer)) then
        if health.colorPetByUnitClass then unit = (unit == "pet") and "player" or gsub(unit, "pet", "") end
        calculateBackupFG = false
        colorMap = self.db.classColorMap
        colorEntry = select(2, UnitClass(unit))
    elseif (health.colorReaction) and (UnitReaction(unit, "player")) then
        calculateBackupFG = false
        colorMap = self.db.reactionColorMap
        local reaction = UnitReaction(unit, "player")
        if (reaction > 4) then
            colorEntry = "GOOD"
        elseif (reaction > 3) then
            colorEntry = "NEUTRAL"
        else
            colorEntry = "BAD"
        end
    else
        calculateBackupFG = true
    end

    -- Caclulate colors
    if (not calculateBackupFG) then
        -- Get maps for class
        if (not colorEntry) then
            calculateBackupFG = true
        else
            local shiftMap = colorMap[I.Enum.GradientMode.Color.SHIFT][colorEntry]
            local normalMap = colorMap[I.Enum.GradientMode.Color.NORMAL][colorEntry]

            -- Sanity check
            if (not shiftMap) or (not normalMap) then
                calculateBackupFG = true
                self:DebugPrint("No shift or normal health color for", "unit:", unit, "entry:", colorEntry)
            else
                -- Set new colors from maps
                r, g, b = normalMap.r, normalMap.g, normalMap.b
                fadeColorR, fadeColorG, fadeColorB = shiftMap.r, shiftMap.g, shiftMap.b
            end
        end
    end

    -- Calculate backup colors
    if (calculateBackupFG) then
        -- fallbac if custom settings arent used
        if (not b) then r, g, b = elvUIColors.health.r, elvUIColors.health.g, elvUIColors.health.b end

        -- Claculate fade backup color
        fadeColorR, fadeColorG, fadeColorB = self:CalculateBackupColor(r, g, b)
    end

    -- Always set a white color so gradients work
    health:SetStatusBarColor(1, 1, 1, 1)

    -- Calculate & Set the gradient
    if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
        -- Fade out r, g, b colors on low hp
        local rStr, gStr, bStr = F.FastColorGradient(hpPercent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

        -- Set Gradient
        health:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG, fadeColorB,
                                                 rStr, gStr, bStr)
    else
        -- Fade out shade colors on low hp
        local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(hpPercent, r, g, b, fadeColorR, fadeColorG, fadeColorB)

        -- Set Gradient
        health:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeStrR, fadeStrG,
                                                 fadeStrB)
    end

    -- Handle Health Background
    if (health.bg) then
        local calculateBackupBG = false

        -- Always force dead backdrop first
        if elvUIColors.useDeadBackdrop and (unit and UnitIsDeadOrGhost(unit)) then
            r, g, b = elvUIColors.health_backdrop_dead.r, elvUIColors.health_backdrop_dead.g,
                      elvUIColors.health_backdrop_dead.b
            calculateBackupBG = true
        end

        -- Calculate our backdrop color
        health.bg.multiplier, r, g, b, fadeColorR, fadeColorG, fadeColorB =
            self:CalculateBackdropColor(elvUIColors, r, g, b, fadeColorR, fadeColorG, fadeColorB, calculateBackupBG)

        -- Always set a white color so gradients work
        health.bg:SetVertexColor(1, 1, 1, 1)

        -- Calculate & Set the gradient
        if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
            -- Fade out r, g, b colors on low hp
            local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(1 - hpPercent, r, g, b, fadeColorR, fadeColorG,
                                                                     fadeColorB)

            -- Set Gradient
            health.bg:SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeStrR, fadeStrG, fadeStrB, r, g, b)
        else
            -- Fade out shade colors on low hp
            local rStr, gStr, bStr = F.FastColorGradient(1 - hpPercent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

            -- Set Gradient
            health.bg:SetGradient(I.Enum.GradientMode.Mode[fadeMode], rStr, gStr, bStr, fadeColorR, fadeColorG,
                                  fadeColorB)
        end
    end
end

--[[ Castbar Gradient ]] --
function GR:PostUpdateCastColor(castbar, useCache, castFailed)
    if (not self.db) or (not self.db.enabled) then return end

    -- Get Parent frame
    local frame = castbar:GetParent()

    -- Get type of unit, raid, party, focus etc
    local unitType = self:GetUnitFrameType(frame)
    if (not unitType) then return self:DebugPrint("UnitFrame Type was empty for castbar frame", unitType) end

    -- Vars
    local percent = (castbar.duration or 0) / (castbar.max or 1)
    local fadeColorR, fadeColorG, fadeColorB
    local r, g, b

    -- Get direction we want
    local fadeMode = I.Enum.GradientMode.Mode.HORIZONTAL
    local fadeDirection = self.leftFrames[unitType] and I.Enum.GradientMode.Direction.LEFT or
                              (self.rightFrames[unitType] and I.Enum.GradientMode.Direction.RIGHT)

    -- Default to top-to-bottom mode when no direction is defined
    if (not fadeDirection) then
        fadeMode = I.Enum.GradientMode.Mode.VERTICAL
        fadeDirection = I.Enum.GradientMode.Direction.RIGHT
    end

    if (not useCache) then
        local colorMap, colorEntry

        -- Get ElvUI Settings
        local customColor = frame.db and frame.db.castbar and frame.db.castbar.customColor
        local custom = customColor and customColor.enable and customColor

        -- Determine right color to use
        if (castFailed) then
            colorMap = self.db.castColorMap
            colorEntry = "INTERRUPTED"
        elseif castbar.notInterruptible and
            (UnitIsPlayer(castbar.unit) or (castbar.unit ~= "player" and UnitCanAttack("player", castbar.unit))) then
            colorMap = self.db.castColorMap
            colorEntry = "NOINTERRUPT"
        elseif ((custom and custom.useClassColor) or (not custom and UF.db.colors.castClassColor)) and
            UnitIsPlayer(castbar.unit) then
            colorMap = self.db.classColorMap
            colorEntry = select(2, UnitClass(castbar.unit))
        else
            colorMap = self.db.castColorMap
            colorEntry = "DEFAULT"
        end

        -- Backup if no map entry (empty class etc)
        if (not colorEntry) then
            colorMap = self.db.castColorMap
            colorEntry = "DEFAULT"
        end

        -- Caclulate colors
        local shiftMap = colorMap[I.Enum.GradientMode.Color.SHIFT][colorEntry]
        local normalMap = colorMap[I.Enum.GradientMode.Color.NORMAL][colorEntry]

        -- Sanity check
        if (not shiftMap) or (not normalMap) then
            shiftMap = self.db.castColorMap[I.Enum.GradientMode.Color.SHIFT]["DEFAULT"]
            normalMap = self.db.castColorMap[I.Enum.GradientMode.Color.NORMAL]["DEFAULT"]
            self:DebugPrint("No shift or normal cast color for", "unit:", castbar.unit, "entry:", colorEntry)
        end

        -- Set new colors from maps
        r, g, b = normalMap.r, normalMap.g, normalMap.b
        fadeColorR, fadeColorG, fadeColorB = shiftMap.r, shiftMap.g, shiftMap.b

        -- Cache
        castbar.cachedColorMap = castbar.cachedColorMap or {}
        castbar.cachedColorMap.r = r
        castbar.cachedColorMap.g = g
        castbar.cachedColorMap.b = b
        castbar.cachedColorMap.fadeColorR = fadeColorR
        castbar.cachedColorMap.fadeColorG = fadeColorG
        castbar.cachedColorMap.fadeColorB = fadeColorB
    elseif (castbar.cachedColorMap) then
        r = castbar.cachedColorMap.r
        g = castbar.cachedColorMap.g
        b = castbar.cachedColorMap.b

        fadeColorR = castbar.cachedColorMap.fadeColorR
        fadeColorG = castbar.cachedColorMap.fadeColorG
        fadeColorB = castbar.cachedColorMap.fadeColorB
    else
        return -- we can safely ignore the call
    end

    -- Always set a white color so gradients work
    castbar:SetStatusBarColor(1, 1, 1, 1)

    -- Calculate & Set the gradient
    if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
        -- Fade out r, g, b colors on low hp
        local rStr, gStr, bStr = F.FastColorGradient(percent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

        -- Set Gradient
        castbar:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG,
                                                  fadeColorB, rStr, gStr, bStr)
    else
        -- Fade out shade colors on low hp
        local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(percent, r, g, b, fadeColorR, fadeColorG, fadeColorB)

        -- Set Gradient
        castbar:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeStrR, fadeStrG,
                                                  fadeStrB)
    end

    -- Handle Health Background
    if (castbar.bg) then
        -- Calculate our backdrop color
        r, g, b = F.CalculateMultiplierColor(0.35, r, g, b)
        fadeColorR, fadeColorG, fadeColorB = F.CalculateMultiplierColor(0.35, fadeColorR, fadeColorG, fadeColorB)

        -- Always set a white color so gradients work
        castbar.bg:SetVertexColor(1, 1, 1, 1)

        -- Set the gradient
        if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
            castbar.bg:SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG, fadeColorB, r, g, b)
        else
            castbar.bg:SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeColorR, fadeColorG, fadeColorB)
        end
    end
end

--[[ Power Gradient ]] --
function GR:PostUpdatePowerColor(power, unit, r, g, b)
    if (not self.db) or (not self.db.enabled) then return end

    -- Get Parent frame
    local frame = power:GetParent()

    -- Get type of unit, raid, party, focus etc
    local unitType = self:GetUnitFrameType(frame)
    if (not unitType) then return self:DebugPrint("UnitFrame Type was empty for power frame", unitType) end

    -- Vars
    local percent = (power.cur - power.min) / (power.max - power.min)
    local fadeColorR, fadeColorG, fadeColorB

    -- Get direction we want
    local fadeMode = I.Enum.GradientMode.Mode.HORIZONTAL
    local fadeDirection = self.leftFrames[unitType] and I.Enum.GradientMode.Direction.LEFT or
                              (self.rightFrames[unitType] and I.Enum.GradientMode.Direction.RIGHT)

    -- Default to top-to-bottom mode when no direction is defined
    if (not fadeDirection) then
        fadeMode = I.Enum.GradientMode.Mode.VERTICAL
        fadeDirection = I.Enum.GradientMode.Direction.RIGHT
    end

    local calculateBackupFG = true
    local colorMap, colorEntry

    if (power.colorPower) then
        calculateBackupFG = false
        colorMap = self.db.powerColorMap
        if (power.displayType ~= ALTERNATE_POWER_INDEX) then
            local pToken, altR, altG, altB = select(2, UnitPowerType(unit or power.unit or frame.unit))
            if (not colorMap[I.Enum.GradientMode.Color.NORMAL][pToken]) then
                if (altR) then
                    calculateBackupFG = true
                    r, g, b = altR, altG, altB
                    if (r > 1 or g > 1 or b > 1) then r, g, b = r / 255, g / 255, b / 255 end
                else
                    colorEntry = "MANA"
                end
            else
                colorEntry = pToken
            end
        else
            colorEntry = "ALT_POWER"
        end
    elseif (power.colorClass and UnitIsPlayer(unit)) or (power.colorClassNPC and not UnitIsPlayer(unit)) or
        (power.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
        calculateBackupFG = false
        colorMap = self.db.classColorMap
        colorEntry = select(2, UnitClass(unit or power.unit or frame.unit))
    end

    -- Caclulate colors
    if (not calculateBackupFG) then
        -- Get maps for class
        if (not colorEntry) then
            calculateBackupFG = true
        else
            local shiftMap = colorMap[I.Enum.GradientMode.Color.SHIFT][colorEntry]
            local normalMap = colorMap[I.Enum.GradientMode.Color.NORMAL][colorEntry]

            -- Sanity check
            if (not shiftMap) or (not normalMap) then
                calculateBackupFG = true
                self:DebugPrint("No shift or normal power color for", "unit:", unit or power.unit or frame.unit,
                                "entry:", colorEntry)
            else
                -- Set new colors from maps
                r, g, b = normalMap.r, normalMap.g, normalMap.b
                fadeColorR, fadeColorG, fadeColorB = shiftMap.r, shiftMap.g, shiftMap.b
            end
        end
    end

    -- Get backup color if needed
    if (calculateBackupFG) then
        if (b == nil) then r, g, b = power:GetStatusBarColor() end
        fadeColorR, fadeColorG, fadeColorB = self:CalculateBackupColor(r, g, b)
    end

    -- Always set a white color so gradients work
    power:SetStatusBarColor(1, 1, 1, 1)

    -- Calculate & Set the gradient
    if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
        -- Fade out r, g, b colors on low hp
        local rStr, gStr, bStr = F.FastColorGradient(percent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

        -- Set Gradient
        power:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG, fadeColorB,
                                                rStr, gStr, bStr)
    else
        -- Fade out shade colors on low hp
        local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(percent, r, g, b, fadeColorR, fadeColorG, fadeColorB)

        -- Set Gradient
        power:GetStatusBarTexture():SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeStrR, fadeStrG,
                                                fadeStrB)
    end

    -- Update Power Prediction color
    if frame and frame.PowerPrediction and frame.PowerPrediction.mainBar then
        if UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction and UF.db.colors.powerPrediction.enable then
            local color = UF.db.colors.powerPrediction.color
            frame.PowerPrediction.mainBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
        else
            frame.PowerPrediction.mainBar:SetStatusBarColor(F.CalculateMultiplierColor(1.25, r, g, b))
        end
    end

    -- Handle Health Background
    if (power.BG) then
        -- Calculate our backdrop color
        r, g, b = F.CalculateMultiplierColor(0.35, r, g, b)
        fadeColorR, fadeColorG, fadeColorB = F.CalculateMultiplierColor(0.35, fadeColorR, fadeColorG, fadeColorB)

        -- Always set a white color so gradients work
        power.BG:SetVertexColor(1, 1, 1, 1)

        -- Set the gradient
        if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
            power.BG:SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG, fadeColorB, r, g, b)
        else
            power.BG:SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeColorR, fadeColorG, fadeColorB)
        end
    end
end

function GR:UpdateStatusBarFrame(frame)
    if (not self.db) or (not self.db.enabled) then return end
    if (not frame) then return end

    -- Comfigure Health
    if (frame.Health) then
        frame.Health:SetStatusBarTexture(self.db.texture)
        frame.Health.bg:SetTexture(self.db.texture)

        -- Hook if needed
        if (not self:IsHooked(frame.Health, "PostUpdateColor")) then
            self:RawHook(frame.Health, "PostUpdateColor", "PostUpdateHealthColor")
        end
    end

    -- Configure CastBar
    if (frame.Castbar) then
        frame.Castbar:SetStatusBarTexture(self.db.texture)
        frame.Castbar.bg:SetTexture(self.db.texture)

        -- Hook if needed
        if (not self:IsHooked(frame.Castbar, "PostCastStart")) then
            self:SecureHook(frame.Castbar, "PostCastStart", function()
                self:PostUpdateCastColor(frame.Castbar, false, false)
            end)
        end

        if (not self:IsHooked(frame.Castbar, "PostCastFail")) then
            self:SecureHook(frame.Castbar, "PostCastFail", function()
                self:PostUpdateCastColor(frame.Castbar, false, true)
            end)
        end

        if (not self:IsHooked(frame.Castbar, "PostCastInterruptible")) then
            self:SecureHook(frame.Castbar, "PostCastInterruptible", function()
                self:PostUpdateCastColor(frame.Castbar, false, false)
            end)
        end

        if (not self:IsHooked(frame.Castbar, "SetValue")) then
            self:SecureHook(frame.Castbar, "SetValue", function()
                self:PostUpdateCastColor(frame.Castbar, true, false)
            end)
        end

        if (not self:IsHooked(frame.Castbar, "SetMinMaxValues")) then
            self:SecureHook(frame.Castbar, "SetMinMaxValues", function()
                self:PostUpdateCastColor(frame.Castbar, true, false)
            end)
        end
    end

    -- Configure Power Bar
    if (frame.Power) then
        frame.Power:SetStatusBarTexture(self.db.texture)
        frame.Power.BG:SetTexture(self.db.texture)

        -- Hook if needed
        if (not self:IsHooked(frame.Power, "PostUpdateColor")) then
            self:SecureHook(frame.Power, "PostUpdateColor", function(_, unit, r, g, b)
                self:PostUpdatePowerColor(frame.Power, unit, r, g, b)
            end)
        end
    end
end

function GR:ConfigureStatusBarFrame(_, frame)
    self:UpdateStatusBarFrame(frame)
end

function GR:UpdateStatusBar(_, frame)
    if (not self.db) or (not self.db.enabled) then return end
    if (not frame) then return end

    local parentFrame = frame:GetParent()

    if (not parentFrame) then return end

    self:UpdateStatusBarFrame(parentFrame)
end

function GR:UpdateStatusBars()
    for frame in pairs(UF.statusbars) do if frame then self:UpdateStatusBar(nil, frame) end end
end

function GR:ForceUpdate()
    -- We check a non specific DB entry to see if the DB is populated
    if UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction then UF:Update_AllFrames() end
end

function GR:UpdateSettings()
    self.leftFrames = I.GradientMode.Layouts[E.db.TXUI.installer.layout].Left
    self.rightFrames = I.GradientMode.Layouts[E.db.TXUI.installer.layout].Right

    self:ForceUpdate() -- Calls configure hooks
end

function GR:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function GR:Disable()
    self:UnregisterAllEvents()
    self:UnhookAll()

    if (self.Initialized) then
        self:ForceUpdate()
    end
end

function GR:Enable()
    self:UpdateSettings()
    self:UnregisterAllEvents()

    -- Hook functions for configure functions
    self:SecureHook(UF, "Configure_HealthBar", "ConfigureStatusBarFrame")
    self:SecureHook(UF, "Configure_Castbar", "ConfigureStatusBarFrame")
    self:SecureHook(UF, "Configure_Power", "ConfigureStatusBarFrame")

    -- Hook functions for update functions
    self:SecureHook(UF, "Update_StatusBars", "UpdateStatusBars")
    self:SecureHook(UF, "Update_StatusBar", "UpdateStatusBar")

    -- Update!
    self:ForceUpdate()
end

function GR:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.themes.gradientMode

    if TXUI:HasRequirements(I.Requirements.GradientMode) and (self.db and self.db.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function GR:Initialize()
    -- Set db
    self.db = E.db.TXUI.themes.gradientMode

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.GradientMode)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- Get Frameworks
    UF = E:GetModule("UnitFrames")

    -- Enable!
    if (UF.Initialized) then
        self:Enable()
    else
        self:SecureHook(UF, "Initialize", "Enable")
    end

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(GR:GetName())
