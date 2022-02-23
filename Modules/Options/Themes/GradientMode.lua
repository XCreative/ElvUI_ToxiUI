local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

local _G = _G
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local PowerBarColor = _G.PowerBarColor

function O:ToxiUI_Themes_GradientMode()
    -- Create Tab
    self.options.themes.args["gradientMode"] = {
        order = self:GetOrder(),
        type = "group",
        childGroups = "tab",
        name = "|cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt Mode|r",
        get = function(info)
            return E.db.TXUI.themes.gradientMode[info[#info]]
        end,
        set = function(info, value)
            E.db.TXUI.themes.gradientMode[info[#info]] = value
            TXUI:GetModule("ThemesGradients"):UpdateSettings()
        end,
        args = {}
    }

    -- Options
    local options = self.options.themes.args["gradientMode"]["args"]
    local optionsHidden

    -- General
    do
        -- General Group
        local generalGroup = self:AddInlineRequirementsDesc(options, { name = "Description" }, {
            name = "We provide different themes for " .. TXUI.Title .. ", you can enable or disable them below." ..
                "\n\n" .. F.StringError(
                "Warning: Enabling one of these settings may overwrite colors or textures in ElvUI and Details, they also prevent you from changing certain settings in ElvUI!") ..
                "\n\n"
        }, I.Requirements.GradientMode)

        -- Enable
        generalGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables fancy gradients for " .. TXUI.Title .. ".\n\n" ..
                F.StringError("Warning: Enabling this setting will overwrite textures in ElvUI and Details!!"),
            name = function()
                return self:GetEnableName(E.db.TXUI.themes.gradientMode.enabled, generalGroup)
            end,
            get = function()
                return E.db.TXUI.themes.gradientMode.enabled
            end,
            set = function(_, value)
                TXUI:GetModule("Themes"):Toggle("gradientMode", value)
            end
        }

        -- Hidden helper
        optionsHidden = function()
            return self:GetEnabledState(E.db.TXUI.themes.gradientMode.enabled, generalGroup) ~= self.enabledState.YES
        end
    end

    -- Colors
    do
        -- Tab
        local tab = self:AddGroup(options, { name = "Class Colors", hidden = optionsHidden })

        -- Colors Group
        local colorGroup = self:AddInlineDesc(tab["args"], { name = "Class Colors" }, {
            name = TXUI.Title .. " Gradient theme " .. F.StringClass("shifts", "MONK") ..
                " from one color to another. You can change the " .. F.StringClass("shifts", "MONK") .. " below.\n\n"
        })

        -- Get correct classname table
        local classNames = LOCALIZED_CLASS_NAMES_MALE
        if UnitSex("player") == 3 then classNames = LOCALIZED_CLASS_NAMES_FEMALE end

        -- Class Colors
        for class, _ in pairs(P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT]) do

            -- Class Name
            self:AddInlineSoloDesc(colorGroup["args"],
                                   { width = 1, customWidth = 120, name = F.StringClass(classNames[class], class) })

            -- Shift Color
            colorGroup["args"][class .. "shift"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.classColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT,
                                              P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT],
                                              class),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.classColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, class)
            }

            -- Spacer for arrow & arrow
            self:AddInlineSoloDesc(colorGroup["args"], { width = 1, customWidth = 30, name = "" })
            self:AddInlineSoloDesc(colorGroup["args"],
                                   { width = 1, customWidth = 30, name = F.StringClass(">", "MONK") })

            -- Normal Color
            colorGroup["args"][class .. "normal"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.classColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL,
                                              P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL],
                                              class),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.classColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, class)
            }

            -- Spacer
            self:AddTinySpacer(colorGroup["args"])
        end
    end

    -- Reaction Colors
    do
        local name = "NPC Colors"

        -- Tab
        local tab = self:AddGroup(options, { name = name, hidden = optionsHidden })

        -- Colors Group
        local colorGroup = self:AddInlineDesc(tab["args"], { name = name }, {
            name = "Here you can change the " .. F.StringClass("gradient shifts", "MONK") .. " of NPC colors.\n\n"
        })

        -- Reaction Colors
        for reaction, _ in pairs(P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT]) do

            -- Get correct color index for blizzard colors
            local colorIndex = 1
            if (reaction == "GOOD") then
                colorIndex = 5
            elseif (reaction == "NEUTRAL") then
                colorIndex = 4
            end

            -- Reaction Name
            local npcColorName = "Neutral"
            if (reaction == "GOOD") then
                npcColorName = "Friendly"
            elseif (reaction == "BAD") then
                npcColorName = "Enemy"
            end

            -- Reaction Name
            self:AddInlineSoloDesc(colorGroup["args"], {
                width = 1,
                customWidth = 120,
                name = F.StringRGB(npcColorName, FACTION_BAR_COLORS[colorIndex])
            })

            -- Shift Color
            colorGroup["args"][reaction .. "shift"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.reactionColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT,
                                              P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT],
                                              reaction),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.reactionColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, reaction)
            }

            -- Spacer for arrow & arrow
            self:AddInlineSoloDesc(colorGroup["args"], { width = 1, customWidth = 30, name = "" })
            self:AddInlineSoloDesc(colorGroup["args"],
                                   { width = 1, customWidth = 30, name = F.StringClass(">", "MONK") })

            -- Normal Color
            colorGroup["args"][reaction .. "normal"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.reactionColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL,
                                              P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.NORMAL],
                                              reaction),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.reactionColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, reaction)
            }

            -- Spacer
            self:AddTinySpacer(colorGroup["args"])
        end
    end

    -- Power Colors
    do
        local name = "Power Colors"

        -- Tab
        local tab = self:AddGroup(options, { name = name, hidden = optionsHidden })

        -- Power Color Group
        local colorGroup = self:AddInlineDesc(tab["args"], { name = name }, {
            name = "Here you can change the " .. F.StringClass("gradient shifts", "MONK") .. " of Power colors.\n\n"
        })

        -- Power Colors
        for power, _ in pairs(P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT]) do

            local colorIndex = power
            if (colorIndex == "ALT_POWER") then colorIndex = "MANA" end

            -- Class Name
            self:AddInlineSoloDesc(colorGroup["args"], {
                width = 1,
                customWidth = 120,
                name = F.StringRGB(F.LowercaseEnum(power),
                                   { F.CalculateMultiplierColorArray(1.35, PowerBarColor[colorIndex]) })
            })

            -- Shift Color
            colorGroup["args"][power .. "shift"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.powerColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT,
                                              P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT],
                                              power),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.powerColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, power)
            }

            -- Spacer for arrow & arrow
            self:AddInlineSoloDesc(colorGroup["args"], { width = 1, customWidth = 30, name = "" })
            self:AddInlineSoloDesc(colorGroup["args"],
                                   { width = 1, customWidth = 30, name = F.StringClass(">", "MONK") })

            -- Normal Color
            colorGroup["args"][power .. "normal"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.powerColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL,
                                              P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.NORMAL],
                                              power),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.powerColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, power)
            }

            -- Spacer
            self:AddTinySpacer(colorGroup["args"])
        end
    end

    -- Other Colors
    do
        -- Tab
        local tab = self:AddGroup(options, { name = "Other Colors", hidden = optionsHidden })

        -- State Group
        local stateGroup = self:AddInlineDesc(tab["args"], { name = "State Colors" }, {
            name = "Here you can change the " .. F.StringClass("gradient shifts", "MONK") .. " of State colors.\n\n"
        })

        -- State Colors
        for special, _ in pairs(P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT]) do

            -- State Description
            self:AddInlineSoloDesc(stateGroup["args"], {
                width = 1,
                customWidth = 120,
                name = F.StringRGB(F.LowercaseEnum(special),
                                   P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL][special])
            })

            -- Shift Color
            stateGroup["args"][special .. "shift"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.specialColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT,
                                              P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT],
                                              special),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.specialColorMap." ..
                                                  I.Enum.GradientMode.Color.SHIFT, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, special)
            }

            -- Spacer for arrow & arrow
            self:AddInlineSoloDesc(stateGroup["args"], { width = 1, customWidth = 30, name = "" })
            self:AddInlineSoloDesc(stateGroup["args"],
                                   { width = 1, customWidth = 30, name = F.StringClass(">", "MONK") })

            -- Normal Color
            stateGroup["args"][special .. "normal"] = {
                order = self:GetOrder(),
                type = "color",
                name = "",
                hasAlpha = false,
                width = 1,
                customWidth = 30,
                get = self:GetFontColorGetter("TXUI.themes.gradientMode.specialColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL,
                                              P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL],
                                              special),
                set = self:GetFontColorSetter("TXUI.themes.gradientMode.specialColorMap." ..
                                                  I.Enum.GradientMode.Color.NORMAL, function()
                    TXUI:GetModule("ThemesGradients"):UpdateSettings()
                    TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                end, special)
            }

            -- Spacer
            self:AddTinySpacer(stateGroup["args"])
        end

        self:AddSpacer(tab["args"])

        -- Cast Group
        local castGroup = self:AddInlineDesc(tab["args"], { name = "Castbar Colors" }, {
            name = "Here you can change the " .. F.StringClass("gradient shifts", "MONK") .. " of Castbar colors.\n\n"
        })

        -- Cast Colors
        for cast, _ in pairs(P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT]) do
            if (cast == "NOINTERRUPT") or (cast == "DEFAULT") then
                -- Name
                local settingsName
                if (cast == "NOINTERRUPT") then
                    settingsName = "Non-interruptible"
                elseif (cast == "DEFAULT") then
                    settingsName = "Regular"
                else
                    settingsName = F.LowercaseEnum(cast)
                end

                -- Cast Description
                self:AddInlineSoloDesc(castGroup["args"], {
                    width = 1,
                    customWidth = 120,
                    name = F.StringRGB(settingsName,
                                       P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL][cast])
                })

                -- Shift Color
                castGroup["args"][cast .. "shift"] = {
                    order = self:GetOrder(),
                    type = "color",
                    name = "",
                    hasAlpha = false,
                    width = 1,
                    customWidth = 30,
                    get = self:GetFontColorGetter("TXUI.themes.gradientMode.castColorMap." ..
                                                      I.Enum.GradientMode.Color.SHIFT,
                                                  P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT],
                                                  cast),
                    set = self:GetFontColorSetter("TXUI.themes.gradientMode.castColorMap." ..
                                                      I.Enum.GradientMode.Color.SHIFT, function()
                        TXUI:GetModule("ThemesGradients"):UpdateSettings()
                        TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                    end, cast)
                }

                -- Spacer for arrow & arrow
                self:AddInlineSoloDesc(castGroup["args"], { width = 1, customWidth = 30, name = "" })
                self:AddInlineSoloDesc(castGroup["args"],
                                       { width = 1, customWidth = 30, name = F.StringClass(">", "MONK") })

                -- Normal Color
                castGroup["args"][cast .. "normal"] = {
                    order = self:GetOrder(),
                    type = "color",
                    name = "",
                    hasAlpha = false,
                    width = 1,
                    customWidth = 30,
                    get = self:GetFontColorGetter("TXUI.themes.gradientMode.castColorMap." ..
                                                      I.Enum.GradientMode.Color.NORMAL,
                                                  P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL],
                                                  cast),
                    set = self:GetFontColorSetter("TXUI.themes.gradientMode.castColorMap." ..
                                                      I.Enum.GradientMode.Color.NORMAL, function()
                        TXUI:GetModule("ThemesGradients"):UpdateSettings()
                        TXUI:GetModule("SkinsDetailsGradients"):UpdateSettings()
                    end, cast)
                }

                -- Spacer
                self:AddTinySpacer(castGroup["args"])
            end
        end
    end

    -- Spacer
    self:AddSpacer(options)
end

O:AddCallback("ToxiUI_Themes_GradientMode")
