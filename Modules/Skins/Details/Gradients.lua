local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local SD = TXUI:NewModule("SkinsDetailsGradients", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local _G = _G
local select = select

-- Vars
local DT
local GR

function SD:RefreshDetails()
    if (not self.db) or (not DT) then return end

    for _, instance in DT:ListInstances() do
        if (instance.iniciada) then
            instance:InstanceReset()
            instance:InstanceRefreshRows()
            instance:ReajustaGump()
            instance:ForceRefresh()
        end
    end
end

function SD:RefreshRow(row, instanceId, useCache, r, g, b)
    if (not self.db) or (not self.db.enabled) then return end
    if (not row) or (not row.textura) then return self:DebugPrint("Row is empty", row) end

    local fadeDirection
    local fadeColorR, fadeColorG, fadeColorB

    local statusMin, statusMax = row.statusbar:GetMinMaxValues()
    local percent = (row.statusbar:GetValue() - statusMin) / (statusMax - statusMin)

    if (not row.statusbar.template) then
        row.lineBorder:Kill()
        row.statusbar:CreateBackdrop("Default", nil, false, false, true)
    end

    if (not useCache) then
        local unitClass
        local actor = row.minha_tabela
        local calculateBackupFG = true

        if (actor) and (actor.name) then
            unitClass = actor:class()
            if (unitClass) then calculateBackupFG = false end
        end

        if (not calculateBackupFG) then
            local shiftMap = self.db.classColorMap[I.Enum.GradientMode.Color.SHIFT][unitClass]
            local normalMap = self.db.classColorMap[I.Enum.GradientMode.Color.NORMAL][unitClass]

            if (not shiftMap) or (not normalMap) then
                calculateBackupFG = true
            else
                r, g, b = normalMap.r, normalMap.g, normalMap.b
                fadeColorR, fadeColorG, fadeColorB = shiftMap.r, shiftMap.g, shiftMap.b
            end
        end

        if (calculateBackupFG) then fadeColorR, fadeColorG, fadeColorB = GR:CalculateBackupColor(r, g, b) end

        row.cachedColorMap = row.cachedColorMap or {}
        row.cachedColorMap.r = r
        row.cachedColorMap.g = g
        row.cachedColorMap.b = b
        row.cachedColorMap.fadeColorR = fadeColorR
        row.cachedColorMap.fadeColorG = fadeColorG
        row.cachedColorMap.fadeColorB = fadeColorB
    elseif (row.cachedColorMap) then
        r = row.cachedColorMap.r
        g = row.cachedColorMap.g
        b = row.cachedColorMap.b

        fadeColorR = row.cachedColorMap.fadeColorR
        fadeColorG = row.cachedColorMap.fadeColorG
        fadeColorB = row.cachedColorMap.fadeColorB
    else
        return -- if we are using a cache, and there is no cache, a return is fine here
    end

    -- Set statusbar colors
    self.hooks[row.textura]["SetVertexColor"](row.textura, 1, 1, 1, 1)
    row.textura:SetTexture(self.db.texture)

    -- Set background colors
    row.background:SetVertexColor(1, 1, 1, 1)
    row.background:SetTexture(self.db.texture)

    -- ! Personal change
    if (self.setFontShadows) then
        row.lineText1:SetShadowColor(0, 0, 0, 1)
        row.lineText2:SetShadowColor(0, 0, 0, 1)
        row.lineText3:SetShadowColor(0, 0, 0, 1)
        row.lineText4:SetShadowColor(0, 0, 0, 1)
        row.lineText1:SetShadowOffset(2, -2)
        row.lineText2:SetShadowOffset(2, -2)
        row.lineText3:SetShadowOffset(2, -2)
        row.lineText4:SetShadowOffset(2, -2)
    end

    -- Get direction we want
    local fadeMode = I.Enum.GradientMode.Mode.HORIZONTAL

    -- Get fade direction
    if (instanceId == 1) then -- right
        fadeDirection = I.Enum.GradientMode.Direction.RIGHT
    elseif (instanceId == 2) then -- left
        fadeDirection = I.Enum.GradientMode.Direction.LEFT
    end

    -- Default to top-to-bottom mode when no direction is defined
    if (not fadeDirection) then
        fadeMode = I.Enum.GradientMode.Mode.VERTICAL
        fadeDirection = I.Enum.GradientMode.Direction.RIGHT
    end

    -- Calculate & Set the gradient
    if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
        -- Fade out r, g, b colors on low hp
        local rStr, gStr, bStr = F.FastColorGradient(percent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

        -- Set Gradient
        row.textura:SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeColorR, fadeColorG, fadeColorB, rStr, gStr, bStr)
    else
        -- Fade out shade colors on low hp
        local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(percent, r, g, b, fadeColorR, fadeColorG, fadeColorB)

        -- Set Gradient
        row.textura:SetGradient(I.Enum.GradientMode.Mode[fadeMode], r, g, b, fadeStrR, fadeStrG, fadeStrB)
    end

    -- Calculate our backdrop color
    r, g, b, fadeColorR, fadeColorG, fadeColorB = select(2, GR:CalculateBackdropColor(nil, r, g, b, fadeColorR,
                                                                                      fadeColorG, fadeColorB, false))

    -- Calculate & Set the gradient
    if (fadeDirection == I.Enum.GradientMode.Direction.LEFT) then
        -- Fade out r, g, b colors on low hp
        local fadeStrR, fadeStrG, fadeStrB = F.FastColorGradient(1 - percent, r, g, b, fadeColorR, fadeColorG,
                                                                 fadeColorB)

        -- Set Gradient
        row.background:SetGradient(I.Enum.GradientMode.Mode[fadeMode], fadeStrR, fadeStrG, fadeStrB, r, g, b)
    else
        -- Fade out shade colors on low hp
        local rStr, gStr, bStr = F.FastColorGradient(1 - percent, fadeColorR, fadeColorG, fadeColorB, r, g, b)

        -- Set Gradient
        row.background:SetGradient(I.Enum.GradientMode.Mode[fadeMode], rStr, gStr, bStr, fadeColorR, fadeColorG,
                                   fadeColorB)
    end
end

function SD:RefreshRows(instance, instanceSpecific)
    if (not self.db) or (not self.db.enabled) then return end

    if (instanceSpecific) then instance = instanceSpecific end
    if (not instance) or (not instance.barras) then return self:DebugPrint("Instance is empty", instance) end

    local instanceId = instance:GetInstanceId()

    for _, bar in ipairs(instance.barras) do
        if (bar and bar.textura) then
            -- Hook for Color Update
            if (not self:IsHooked(bar.textura, "SetVertexColor")) then
                self:RawHook(bar.textura, "SetVertexColor", function(_, r, g, b)
                    self:RefreshRow(bar, instanceId, false, r, g, b)
                end, true)
            end
            -- Hook for Value Update
            if (not self:IsHooked(bar.statusbar, "SetValue")) then
                self:SecureHook(bar.statusbar, "SetValue", function()
                    self:RefreshRow(bar, instanceId, true)
                end)
            end
        end
    end
end

function SD:EndRefresh(_, instance)
    self:RefreshRows(instance)
end

function SD:UpdateSettings()
    self:RefreshDetails()
end

function SD:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function SD:Disable()
    self:UnregisterAllEvents()
    self:UnhookAll()

    -- Refresh after unhook
    self:RefreshDetails()
end

function SD:Enable()
    if (not self.db) or (not self.db.enabled) or (not TXUI:HasRequirements(I.Requirements.DetailsGradientMode)) then
        return
    end

    self:UpdateSettings()
    self:UnregisterAllEvents()

    -- Get frameworks
    DT = DT or _G.Details
    GR = GR or TXUI:GetModule("ThemesGradients")

    -- Sanity check
    if (not DT) or (not GR) then return self:DebugPrint("Could not get frameworks", DT, GR) end

    -- Set correct colors
    for _, instance in DT:ListInstances() do
        instance.row_info.textL_class_colors = false
        instance.row_info.textR_class_colors = false
        instance.row_info.texture_class_colors = true
    end

    -- ! Personal Change
    if (F.IsDeveloper({ I.Enum.Developers.TOXI })) then self.setFontShadows = true end

    -- Hook functions
    self:SecureHook(DT, "InstanceRefreshRows", "RefreshRows")
    self:SecureHook(DT, "EndRefresh", "EndRefresh")
    self:SecureHook(DT, "ApplyProfile", "ProfileUpdate")

    -- Refresh after hook
    self:RefreshDetails()
end

function SD:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.themes.gradientMode

    if self.Initialized then
        self:Enable()
    else
        self:Initialize()
    end
end

function SD:Initialize()
    -- Set db
    self.db = E.db.TXUI.themes.gradientMode

    -- Don't init second time
    if self.Initialized then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- We are done, hooray!
    self.Initialized = true

    -- Wait for AddOnLoad and trigger profile update when addon gets loaded
    TXUI:GetModule("Skins"):AddCallbackForAddon("Details", function()
        self:ProfileUpdate()
    end)
end

TXUI:RegisterModule(SD:GetName())
