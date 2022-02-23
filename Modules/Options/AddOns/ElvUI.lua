local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:AddOns_ElvUI()

    -- Create Tab
    self.options.addons.args["elvuiGroup"] = {
        order = self:GetOrder(),
        type = "group",
        name = "ElvUI " .. E.NewSign,
        args = {}
    }

    -- Options
    local options = self.options.addons.args["elvuiGroup"]["args"]

    -- ElvUI Group Description
    self:AddInlineDesc(options, { name = "Description" }, {
        name = TXUI.Title .. " provides certain additional changes to " .. F.StringElvUI("ElvUI") .. " or " ..
            TXUI.Title .. " which can be changed here."
    })

    -- Spacer
    self:AddSpacer(options)

    -- ElvUI Theme
    do
        -- ElvUI Theme
        local elvuiTheme = self:AddInlineDesc(options, {
            name = TXUI.Title .. " ElvUI Theme " .. F.StringError("(Experimental)"),
            get = function(info)
                return E.db.TXUI.addons.elvUITheme[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.addons.elvUITheme[info[#info]] = value
                TXUI:GetModule("Theme"):ForceRefresh()
            end
        }, {
            name = "Toggling this on enables the " .. TXUI.Title .. " ElvUI Theme.\n\n" ..
                F.StringError(
                    "Warning: This is an Experimental feature and may not be compatible with other ElvUI Plugins!") ..
                "\n\n"
        })

        -- ElvUI Theme Mode Enable
        elvuiTheme["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " ElvUI Theme.",
            name = function()
                return self:GetEnableName(E.db.TXUI.addons.elvUITheme.enabled)
            end,
            set = function(info, value)
                E.db.TXUI.addons.elvUITheme[info[#info]] = value
                TXUI:GetModule("Theme"):ProfileUpdate()
            end
        }

        -- Disabled helper
        local optionsDisabled = function()
            return self:GetEnabledState(E.db.TXUI.addons.elvUITheme.enabled, elvuiTheme) ~= self.enabledState.YES
        end

        -- Shadow Toggle
        elvuiTheme["args"]["shadowEnabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Enable shadows for WeakAuras and most of ElvUI bars.",
            name = "Soft Shadows",
            disabled = optionsDisabled
        }

        -- Shadow Alpha
        elvuiTheme["args"]["shadowAlpha"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Shadow Opacity",
            min = 0.1,
            max = 1,
            step = 0.01,
            isPercent = true,
            disabled = function()
                return optionsDisabled() or (not E.db.TXUI.addons.elvUITheme.shadowEnabled)
            end
        }

        -- Shadow Size
        elvuiTheme["args"]["shadowSize"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Shadow Size",
            min = 1,
            max = 10,
            step = 1,
            disabled = function()
                return optionsDisabled() or (not E.db.TXUI.addons.elvUITheme.shadowEnabled)
            end
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- ElvUI AFK Mode
    do
        -- ElvUI AFK Mode Group
        local elvuiAfkGroup = self:AddInlineDesc(options, {
            name = "AFK Mode",
            get = function(info)
                return E.db.TXUI.addons.afkMode[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.addons.afkMode[info[#info]] = value
                TXUI:GetModule("AFK"):ProfileUpdate()
            end
        }, { name = "Toggling this on enables the " .. TXUI.Title .. " AFK mode.\n\n" })

        -- ElvUI AFK Mode Enable
        elvuiAfkGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " AFK mode.",
            name = function()
                return self:GetEnableName(E.db.TXUI.addons.afkMode.enabled)
            end
        }

        -- Disabled helper
        local optionsDisabled = function()
            return self:GetEnabledState(E.db.TXUI.addons.afkMode.enabled, elvuiAfkGroup) ~= self.enabledState.YES
        end

        -- Play Random Emotes
        elvuiAfkGroup["args"]["playEmotes"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Enabling this option will display random emotes on the Player model.",
            name = "Play Emotes",
            disabled = optionsDisabled
        }

        -- Turn Camera while AFK
        elvuiAfkGroup["args"]["turnCamera"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Enabling this option turns the camera while the AFK Screen is active.",
            name = "Turn Camera",
            disabled = optionsDisabled
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- ToxiUI Deconstruct
    do
        -- ToxiUI Deconstruct Group
        local deconstructGroup = self:AddInlineRequirementsDesc(options, {
            name = "Deconstruct",
            get = function(info)
                return E.db.TXUI.addons.deconstruct[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.addons.deconstruct[info[#info]] = value
                TXUI:GetModule("Deconstruct"):ProfileUpdate()
            end
        }, { name = "Button in your bags to easily deconstruct items: disenchanting, prospecting, milling..\n\n" },
                                                                I.Requirements.Deconstruct)

        -- ToxiUI Deconstruct Enable
        deconstructGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggle the " .. TXUI.Title .. " Deconstruct module.",
            name = function()
                return self:GetEnableName(E.db.TXUI.addons.deconstruct.enabled, deconstructGroup)
            end
        }

        -- Disabled helper
        local optionsDisabled = function()
            return self:GetEnabledState(E.db.TXUI.addons.deconstruct.enabled, deconstructGroup) ~= self.enabledState.YES
        end

        deconstructGroup["args"]["highlightMode"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Highlight Usable",
            desc = "Highlight items in your bags that you can deconstruct.",
            values = { ["NONE"] = "None", ["DARK"] = "Dark", ["ALPHA"] = "Light" },
            disabled = optionsDisabled
        }

        deconstructGroup["args"]["labelEnabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Label items when you hover over them.",
            name = "Item Label",
            disabled = optionsDisabled
        }

        deconstructGroup["args"]["glowEnabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Items glow when you hover over them.",
            name = "Item Glow",
            disabled = optionsDisabled
        }

        deconstructGroup["args"]["glowAlpha"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Glow Opacity",
            min = 0.1,
            max = 1,
            step = 0.01,
            isPercent = true,
            disabled = function()
                return optionsDisabled() or (not E.db.TXUI.addons.deconstruct.glowEnabled)
            end
        }

        -- Spacer
        self:AddSpacer(deconstructGroup["args"])

        deconstructGroup["args"]["animations"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " Deconstruct Animations.",
            name = "Animations",
            disabled = optionsDisabled
        }

        local animationsDisabled = function()
            return optionsDisabled() or (not E.db.TXUI.addons.deconstruct.animations)
        end

        deconstructGroup["args"]["animationsMult"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Animation Speed",
            min = 0.1,
            max = 2,
            step = 0.1,
            isPercent = true,
            get = function()
                return 1 / E.db.TXUI.addons.deconstruct.animationsMult
            end,
            set = function(_, value)
                E.db.TXUI.addons.deconstruct.animationsMult = 1 / value
            end,
            disabled = animationsDisabled
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- ElvUI Global Fade Persist Mode
    do
        -- ElvUI Global Fade Persist Group
        local elvuiFadePersistGroup = self:AddInlineRequirementsDesc(options, { name = "ActionBar Fade" }, {
            name = "This option controls your Action Bars visibility.\n\n"
        }, I.Requirements.FadePersist)

        -- ElvUI Global Fade Persist Enable
        elvuiFadePersistGroup["args"]["elvuiFadePersist"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "This option controls when should your Action Bars appear.",
            name = function()
                return self:GetEnableName(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup)
            end,
            get = function(_)
                return E.db.TXUI.addons.fadePersist.enabled
            end,
            set = function(_, value)
                E.db.TXUI.addons.fadePersist.enabled = value
                TXUI:GetModule("FadePersist"):ProfileUpdate()
            end
        }

        -- Disabled helper
        local optionsDisabled = function()
            return self:GetEnabledState(E.db.TXUI.addons.fadePersist.enabled, elvuiFadePersistGroup) ~=
                       self.enabledState.YES
        end

        -- Mode
        elvuiFadePersistGroup["args"]["elvuiFadePersistMode"] =
            {
                order = self:GetOrder(),
                type = "select",
                name = "Mode",
                values = {
                    MOUSEOVER = "Mouseover Only",
                    NO_COMBAT = "Hide in Combat",
                    IN_COMBAT = "Show in Combat",
                    ELVUI = "ElvUI Default",
                    ALWAYS = "Show Always"
                },
                disabled = optionsDisabled,
                get = function(_)
                    return E.db.TXUI.addons.fadePersist.mode
                end,
                set = function(_, value)
                    E.db.TXUI.addons.fadePersist.mode = value
                    TXUI:GetModule("FadePersist"):ProfileUpdate()
                end
            }
    end

    -- Spacer
    self:AddSpacer(options)

    -- ToxiUI Game Menu Button
    do
        -- ToxiUI Game Menu Button Group
        local gameMenuButtonGroup = self:AddInlineRequirementsDesc(options,
                                                                   { name = TXUI.Title .. " Game Menu Button" }, {
            name = "Enabling this option shows a " .. TXUI.Title .. " button in the Game Menu (ESC).\n\n"
        }, I.Requirements.GameMenuButton)

        -- ToxiUI Game Menu Button Enable
        gameMenuButtonGroup["args"]["gameMenuButton"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Enabling this option shows a " .. TXUI.Title .. " button in the Game Menu (ESC).",
            name = function()
                return self:GetEnableName(E.db.TXUI.addons.gameMenuButton.enabled, gameMenuButtonGroup)
            end,
            get = function(_)
                return E.db.TXUI.addons.gameMenuButton.enabled
            end,
            set = function(_, value)
                E.db.TXUI.addons.gameMenuButton.enabled = value
                E:StaticPopup_Show("CONFIG_RL")
            end
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- ElvUI Font Scale
    do
        -- ElvUI Font Scale Group
        local elvuiFontScaleGroup = self:AddInlineDesc(options, { name = "Font Scale" }, {
            name = "This slider will increase most of " .. F.StringElvUI("ElvUI") .. " fonts.\n"
        })

        -- ElvUI Font Scale Enable
        elvuiFontScaleGroup["args"]["elvuiFontScale"] = {
            order = self:GetOrder(),
            type = "range",
            desc = "This slider will increase most of " .. F.StringElvUI("ElvUI") .. " fonts.",
            min = 0,
            max = 3,
            step = 1,
            name = "",
            get = function(_)
                return E.db.TXUI.addons.fontScale
            end,
            set = function(_, value)
                TXUI:GetModule("Profiles"):ApplyFontSizeChange(value)
            end
        }
    end
end

O:AddCallback("AddOns_ElvUI")
