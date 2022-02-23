local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local TH = TXUI:NewModule("Themes", "AceEvent-3.0")

function TH:Toggle(theme, value)
    -- Don't allow changes before init
    if (not self.Initialized) then return end

    -- get profiles
    local pf = TXUI:GetModule("Profiles")

    --
    --[[ GradientMode ]] --
    --
    if theme == "gradientMode" then
        -- save settings
        E.db.TXUI.themes.gradientMode.enabled = value

        -- apply texture settings
        pf:ElvUITextures()
        pf:ElvUITexturesPrivate()

        -- apply custom texture skinning to elvui
        TXUI:GetModule("ThemesGradients"):ProfileUpdate()

        -- apply custom texture skinning to details
        TXUI:GetModule("SkinsDetailsGradients"):ProfileUpdate()
    end

    --
    --[[ Dark Mode ]] --
    --
    if theme == "darkMode" then
        -- save settings
        E.db.TXUI.themes.darkMode.enabled = value
        E.db.TXUI.themes.darkMode.transparency = value

        -- apply elvui profile
        pf:ElvUIColors()

        -- update before we make changes
        E:UpdateUnitFrames()
        E:UpdateMoverPositions()

        -- fix anchor
        pf:ElvUIAnchors()

        -- update elvui again with new anchors
        E:UpdateUnitFrames()
        E:UpdateMoverPositions()

        -- apply transparency to elvui
        TXUI:GetModule("ThemesDarkTransparency"):ProfileUpdate()

        -- apply dark mode skinning to details
        TXUI:GetModule("SkinsDetailsDark"):ProfileUpdate()
    end

    --
    --[[ Dark Mode Transparency ]] --
    --
    if theme == "darkModeTransparency" then
        -- save settings
        E.db.TXUI.themes.darkMode.transparency = value

        -- apply transparency to elvui
        TXUI:GetModule("ThemesDarkTransparency"):ProfileUpdate()

        -- apply dark mode skinning to details
        TXUI:GetModule("SkinsDetailsDark"):ProfileUpdate()
    end
end

function TH:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function TH:Disable()
    self:UnregisterAllEvents()
end

function TH:Enable()
    self:UnregisterAllEvents()
end

function TH:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.themes

    if (self.db) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function TH:Initialize()
    -- Set db
    self.db = E.db.TXUI.themes

    -- Don't init second time
    if self.Initialized then return end

    -- Don't do anything if db dosen't exists
    if (not self.db) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(TH:GetName())
