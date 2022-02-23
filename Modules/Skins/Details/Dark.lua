local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local SD = TXUI:NewModule("SkinsDetailsDark", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local _G = _G

-- Vars
local DT
local LSM

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

function SD:CalculateBackdropColor(eColors, r, g, b)
    local elvUIColors = eColors or E.db.unitframe.colors
    local multiplier = (elvUIColors.healthMultiplier > 0 and elvUIColors.healthMultiplier) or 0.35

    if elvUIColors.customhealthbackdrop then
        r, g, b = elvUIColors.health_backdrop.r, elvUIColors.health_backdrop.g, elvUIColors.health_backdrop.b
    else
        r, g, b = r * multiplier, g * multiplier, b * multiplier
    end

    return r, g, b
end

function SD:RefreshRow(row, r, g, b, bgR, bgG, bgB)
    row.textura:SetVertexColor(r, g, b, 1)
    row.textura:SetTexture(self.statusbarTexture)

    if (not row.statusbar.template) then
        row.lineBorder:Kill()
        row.statusbar:CreateBackdrop("Default", nil, false, false, true)
        row.statusbar.backdrop.Center:StripTextures()
        row.statusbar.backdrop.Center:Kill()
    end

    if (self.db.transparency) then
        row.background:SetTexture(E.media.blankTex)
        row.background:SetVertexColor(bgR, bgG, bgB, self.db.transparencyAlpha)
    else
        row.background:SetTexture(self.statusbarTexture)
        row.background:SetVertexColor(bgR, bgG, bgB, 1)
    end
end

function SD:RefreshRows(instance, instanceSpecific)
    if (not self.db) or (not self.db.enabled) then return end

    if (instanceSpecific) then instance = instanceSpecific end
    if (not instance) or (not instance.barras) then return self:DebugPrint("Instance is empty", instance) end

    local elvUIColors = E.db.unitframe.colors
    local r, g, b = elvUIColors.health.r, elvUIColors.health.g, elvUIColors.health.b
    local bgR, bgG, bgB = self:CalculateBackdropColor(elvUIColors, r, g, b)

    for _, bar in ipairs(instance.barras) do self:RefreshRow(bar, r, g, b, bgR, bgG, bgB) end
end

function SD:EndRefresh(_, instance)
    self:RefreshRows(instance)
end

function SD:UpdateSettings()
    -- Get textures and calculate colors
    self.statusbarTexture = LSM:Fetch("statusbar", E.db.unitframe.statusbar)
    if (not self.statusbarTexture) then self.statusbarTexture = E.media.blankTex end -- backup to elvui texture if not found

    self:RefreshDetails()
end

function SD:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function SD:Disable()
    self:UnregisterAllEvents()
    self:UnhookAll()

    -- Set old colors if using our profile
    if TXUI:HasRequirements({ I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE }) then
        -- Get framework
        DT = DT or _G.Details

        for _, instance in DT:ListInstances() do
            instance.row_info.textL_class_colors = false
            instance.row_info.textR_class_colors = false
            instance.row_info.texture_class_colors = true
        end
    end

    -- Refresh after unhook
    self:RefreshDetails()
end

function SD:Enable()
    if (not self.db) or (not self.db.enabled) or (not TXUI:HasRequirements(I.Requirements.DetailsDarkMode)) then
        return
    end

    -- Unregister events
    self:UnregisterAllEvents()

    -- Get frameworks
    DT = DT or _G.Details
    LSM = LSM or E.Libs.LSM

    -- Update settings
    self:UpdateSettings()

    -- Sanity check
    if (not DT) or (not LSM) then return self:DebugPrint("Could not get frameworks", DT, LSM) end

    -- Set correct colors
    for _, instance in DT:ListInstances() do
        instance.row_info.textL_class_colors = true
        instance.row_info.textR_class_colors = true
        instance.row_info.texture_class_colors = false
    end

    -- Hook functions
    self:SecureHook(DT, "InstanceRefreshRows", "RefreshRows")
    self:SecureHook(DT, "EndRefresh", "EndRefresh")
    self:SecureHook(DT, "ApplyProfile", "ProfileUpdate")

    -- Refresh after hook
    self:RefreshDetails()
end

function SD:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.themes.darkMode

    if self.Initialized then
        self:Enable()
    else
        self:Initialize()
    end
end

function SD:Initialize()
    -- Set db
    self.db = E.db.TXUI.themes.darkMode

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
