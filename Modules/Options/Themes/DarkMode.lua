local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:ToxiUI_Themes_DarkMode()
    -- Create Tab
    self.options.themes.args["darkMode"] = {
        order = self:GetOrder(),
        type = "group",
        name = "|cffbdbdbdDark Mode|r",
        get = function(info)
            return E.db.TXUI.themes.darkMode[info[#info]]
        end,
        set = function(info, value)
            E.db.TXUI.themes.darkMode[info[#info]] = value
            TXUI:GetModule("ThemesDarkTransparency"):UpdateSettings()
            TXUI:GetModule("SkinsDetailsDark"):UpdateSettings()
        end,
        args = {}
    }

    -- Options
    local options = self.options.themes.args["darkMode"]["args"]
    local optionsHidden

    -- General
    do
        -- General Group
        local generalGroup = self:AddInlineRequirementsDesc(options, { name = "Description" }, {
            name = "We provide different themes for " .. TXUI.Title .. ", you can enable or disable them below." ..
                "\n\n" .. F.StringError(
                "Warning: Enabling one of these settings may overwrite colors or textures in ElvUI and Details, they also prevent you from changing certain settings in ElvUI!") ..
                "\n\n"
        }, I.Requirements.DarkMode)

        -- Enable
        generalGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the Dark theme for " .. TXUI.Title .. ".\n\n" ..
                F.StringError("Warning: Enabling this setting will overwrite textures in ElvUI and Details!!"),
            name = function()
                return self:GetEnableName(E.db.TXUI.themes.darkMode.enabled, generalGroup)
            end,
            get = function()
                return E.db.TXUI.themes.darkMode.enabled
            end,
            set = function(_, value)
                TXUI:GetModule("Themes"):Toggle("darkMode", value)
            end
        }

        -- Hidden helper
        optionsHidden = function()
            return self:GetEnabledState(E.db.TXUI.themes.darkMode.enabled, generalGroup) ~= self.enabledState.YES
        end
    end

    -- Spacer
    self:AddSpacer(options)

    -- Transparency
    do
        -- Transparency Group
        local transparencyGroup = self:AddInlineDesc(options, { name = "Transparency", hidden = optionsHidden },
                                                     { name = "Change the backdrop transparency (alpha)." })

        -- Dark Mode Theme Transparency Enable
        transparencyGroup["args"]["darkModeTransparency"] = {
            order = self:GetOrder(),
            type = "toggle",
            name = "Transparency",
            desc = "Toggling this on enables the Dark theme transparency for " .. TXUI.Title,
            get = function()
                return E.db.TXUI.themes.darkMode.transparency
            end,
            set = function(_, value)
                TXUI:GetModule("Themes"):Toggle("darkModeTransparency", value)
            end,
            disabled = function()
                return not TXUI:HasRequirements(I.Requirements.DarkModeTransparency)
            end
        }

        -- Transparency Alpha Slider
        transparencyGroup["args"]["transparencyAlpha"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Transparency Alpha",
            min = 0,
            max = 0.75,
            step = 0.01,
            disabled = function()
                return not E.db.TXUI.themes.darkMode.transparency
            end
        }
    end

end

O:AddCallback("ToxiUI_Themes_DarkMode")
