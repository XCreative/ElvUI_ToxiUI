local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

local ReloadUI = ReloadUI

function O:Plugins_Armory()

    -- Create Tab
    self.options.plugins.args["armory"] = {
        order = self:GetOrder(),
        type = "group",
        childGroups = "tab",
        name = "Armory",
        get = function(info)
            return E.db.TXUI.armory[info[#info]]
        end,
        set = function(info, value)
            E.db.TXUI.armory[info[#info]] = value
            TXUI:GetModule("Armory"):UpdateCharacterArmory()
        end,
        args = {}
    }

    -- Options
    local options = self.options.plugins.args["armory"]["args"]
    local optionsHidden

    -- General
    do
        -- General Group
        local generalGroup = self:AddInlineRequirementsDesc(options, { name = "Description" }, {
            name = TXUI.Title .. " Armory changes the appearance of your Character sheet.\n\n"
        }, I.Requirements.Armory)

        -- Enable
        generalGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " Armory.",
            name = function()
                return self:GetEnableName(E.db.TXUI.armory.enabled, generalGroup)
            end,
            set = function(info, value)
                E.db.TXUI.armory[info[#info]] = value

                if value == false then
                    ReloadUI()
                else
                    TXUI:GetModule("Armory"):ProfileUpdate()
                end
            end,
            confirm = function(_, value)
                if value == false then
                    return "To disable " .. TXUI.Title .. " Armory you must reload your UI.\n\n Are you sure?"
                else
                    return false
                end
            end
        }

        -- Hidden helper
        optionsHidden = function()
            return self:GetEnabledState(E.db.TXUI.armory.enabled, generalGroup) ~= self.enabledState.YES
        end
    end

    -- General Tab
    do
        -- Tab
        local tab = self:AddGroup(options, { name = "General", hidden = optionsHidden })

        -- Avg Item Level
        do
            -- Avg Item Level Group
            local itemLevelGroup = self:AddInlineDesc(tab["args"], {
                name = "Item Level",
                get = function(info)
                    return E.db.TXUI.armory.stats[info[#info]]
                end,
                set = function(info, value)
                    E.db.TXUI.armory.stats[info[#info]] = value
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end
            }, { name = "Settings for Item Level in " .. TXUI.Title .. " Armory.\n\n" })

            -- Show Avg Item Level of Best Items (in Bags)
            itemLevelGroup["args"]["showAvgItemLevel"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Enabling this will show the maximum possible item level you can achieve with items currently in your bags.",
                name = "Bags iLvl"
            }

            -- Formats
            itemLevelGroup["args"]["itemLevelFormat"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Format",
                desc = "Decimal format",
                values = { ["%.0f"] = "42", ["%.1f"] = "42.0", ["%.2f"] = "42.01", ["%.3f"] = "42.012" }
            }

            -- Spacer
            self:AddSpacer(itemLevelGroup["args"])

            -- Fonts Font
            itemLevelGroup["args"]["itemLevelFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            itemLevelGroup["args"]["itemLevelFontOutline"] =
                {
                    order = self:GetOrder(),
                    type = "select",
                    name = "Font Outline",
                    desc = "Set the font outline.",
                    values = self:GetAllFontOutlinesFunc(),
                    disabled = function()
                        return (E.db.TXUI.armory.stats["itemLevelFontShadow"] == true)
                    end
                }

            -- Fonts Size
            itemLevelGroup["args"]["itemLevelFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }

            -- Fonts Shadow
            itemLevelGroup["args"]["itemLevelFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            itemLevelGroup["args"]["itemLevelFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            itemLevelGroup["args"]["itemLevelFontCustomColor"] =
                {
                    order = self:GetOrder(),
                    type = "color",
                    name = "Custom Color",
                    hasAlpha = true,
                    get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
                    set = self:GetFontColorSetter("TXUI.armory.stats", function()
                        TXUI:GetModule("Armory"):UpdateCharacterArmory()
                    end),
                    hidden = function()
                        return E.db.TXUI.armory.stats.itemLevelFontColor ~= "CUSTOM"
                    end
                }
        end

        -- Animations
        do
            -- General Group
            local animationsGroup = self:AddInlineDesc(tab["args"], { name = "Animations" }, {
                name = "Armory animations when opening the Character sheet.\n\n"
            })

            -- Enable
            animationsGroup["args"]["animations"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Toggling this on enables the " .. TXUI.Title .. " Armory Animations.",
                name = function()
                    return self:GetEnableName(E.db.TXUI.armory.animations)
                end
            }

            local animationsDisabled = function()
                return not E.db.TXUI.armory.animations
            end

            -- Animation Speed
            animationsGroup["args"]["animationsMult"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Animation Speed",
                min = 0.1,
                max = 2,
                step = 0.1,
                isPercent = true,
                get = function()
                    return 1 / E.db.TXUI.armory.animationsMult
                end,
                set = function(_, value)
                    E.db.TXUI.armory.animationsMult = 1 / value
                end,
                disabled = animationsDisabled
            }
        end

        -- Background
        do
            -- Background Group
            local backgroundGroup = self:AddInlineDesc(tab["args"], {
                name = "Background",
                get = function(info)
                    return E.db.TXUI.armory.background[info[#info]]
                end,
                set = function(info, value)
                    E.db.TXUI.armory.background[info[#info]] = value
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end
            }, { name = "Settings for the custom " .. TXUI.Title .. " Armory background.\n\n" })

            -- Enable
            backgroundGroup["args"]["enabled"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Toggling this on enables the " .. TXUI.Title .. " Armory background.",
                name = function()
                    return self:GetEnableName(E.db.TXUI.armory.background.enabled)
                end
            }

            local optionsDisabled = function()
                return self:GetEnabledState(E.db.TXUI.armory.background.enabled) ~= self.enabledState.YES
            end

            -- Alpha
            backgroundGroup["args"]["alpha"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Alpha",
                min = 0,
                max = 1,
                step = 0.01,
                isPercent = true,
                disabled = optionsDisabled
            }

            -- Style
            backgroundGroup["args"]["style"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Style",
                desc = "Change the Background image.",
                values = {
                    [1] = "1 (Default)",
                    [2] = "2",
                    [3] = "3",
                    [4] = "4",
                    [5] = "5",
                    [6] = "6",
                    [7] = "7",
                    [8] = "8",
                    [9] = "9"
                },
                disabled = optionsDisabled
            }
        end
    end

    -- Title
    do
        -- Tab
        local tab = self:AddGroup(options, { name = "Header", hidden = optionsHidden })

        -- Name Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Name Text" })

            -- Fonts Font
            fontGroup["args"]["nameTextFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["nameTextFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory["nameTextFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["nameTextFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["nameTextFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["nameTextFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["nameTextFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory", P.armory),
                set = self:GetFontColorSetter("TXUI.armory", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory["nameTextFontColor"] ~= "CUSTOM"
                end
            }

            -- Spacer
            self:AddSpacer(fontGroup["args"])

            -- Position X
            fontGroup["args"]["nameTextOffsetX"] = {
                order = self:GetOrder(),
                type = "range",
                name = "X Offset",
                min = -100,
                max = 100,
                step = 1
            }

            -- Position Y
            fontGroup["args"]["nameTextOffsetY"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Y Offset",
                min = -100,
                max = 100,
                step = 1
            }
        end

        -- Title Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Title Text" })

            -- Fonts Font
            fontGroup["args"]["titleTextFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["titleTextFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory["titleTextFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["titleTextFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["titleTextFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["titleTextFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["titleTextFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory", P.armory),
                set = self:GetFontColorSetter("TXUI.armory", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory["titleTextFontColor"] ~= "CUSTOM"
                end
            }

            -- Spacer
            self:AddSpacer(fontGroup["args"])

            -- Position X
            fontGroup["args"]["titleTextOffsetX"] = {
                order = self:GetOrder(),
                type = "range",
                name = "X Offset",
                min = -100,
                max = 100,
                step = 1
            }

            -- Position Y
            fontGroup["args"]["titleTextOffsetY"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Y Offset",
                min = -100,
                max = 100,
                step = 1
            }
        end

        -- Level Title Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Level Label" })

            -- Fonts Font
            fontGroup["args"]["levelTitleTextFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["levelTitleTextFontOutline"] =
                {
                    order = self:GetOrder(),
                    type = "select",
                    name = "Font Outline",
                    desc = "Set the font outline.",
                    values = self:GetAllFontOutlinesFunc(),
                    disabled = function()
                        return (E.db.TXUI.armory["levelTitleTextFontShadow"] == true)
                    end
                }

            -- Fonts Size
            fontGroup["args"]["levelTitleTextFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["levelTitleTextFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["levelTitleTextFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc()
            }

            -- Font Custom Color
            fontGroup["args"]["levelTitleTextFontCustomColor"] =
                {
                    order = self:GetOrder(),
                    type = "color",
                    name = "Custom Color",
                    hasAlpha = true,
                    get = self:GetFontColorGetter("TXUI.armory", P.armory),
                    set = self:GetFontColorSetter("TXUI.armory", function()
                        TXUI:GetModule("Armory"):UpdateCharacterArmory()
                    end),
                    hidden = function()
                        return E.db.TXUI.armory.levelTitleTextFontColor ~= "CUSTOM"
                    end
                }

            -- Spacer
            self:AddSpacer(fontGroup["args"])

            -- Position X
            fontGroup["args"]["levelTitleTextOffsetX"] = {
                order = self:GetOrder(),
                type = "range",
                name = "X Offset",
                min = -100,
                max = 100,
                step = 1
            }

            -- Position Y
            fontGroup["args"]["levelTitleTextOffsetY"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Y Offset",
                min = -100,
                max = 100,
                step = 1
            }
        end

        -- Level Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Level Value" })

            -- Fonts Font
            fontGroup["args"]["levelTextFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["levelTextFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory["levelTextFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["levelTextFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["levelTextFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["levelTextFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc()
            }

            -- Font Custom Color
            fontGroup["args"]["levelTextFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory", P.armory),
                set = self:GetFontColorSetter("TXUI.armory", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory.levelTextFontColor ~= "CUSTOM"
                end
            }

            -- Spacer
            self:AddSpacer(fontGroup["args"])

            -- Position X
            fontGroup["args"]["levelTextOffsetX"] = {
                order = self:GetOrder(),
                type = "range",
                name = "X Offset",
                min = -100,
                max = 100,
                step = 1
            }

            -- Position Y
            fontGroup["args"]["levelTextOffsetY"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Y Offset",
                min = -100,
                max = 100,
                step = 1
            }
        end

        -- Class Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Class Text" })

            -- Fonts Font
            fontGroup["args"]["classTextFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["classTextFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory["classTextFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["classTextFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["classTextFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["classTextFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["classTextFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory", P.armory),
                set = self:GetFontColorSetter("TXUI.armory", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory["classTextFontColor"] ~= "CUSTOM"
                end
            }

            -- Spacer
            self:AddSpacer(fontGroup["args"])

            -- Position X
            fontGroup["args"]["classTextOffsetX"] = {
                order = self:GetOrder(),
                type = "range",
                name = "X Offset",
                min = -100,
                max = 100,
                step = 1
            }

            -- Position Y
            fontGroup["args"]["classTextOffsetY"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Y Offset",
                min = -100,
                max = 100,
                step = 1
            }
        end

        -- Spec Icon
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Spec Icon" })
            -- Fonts Outline
            fontGroup["args"]["specIconFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory["specIconFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["specIconFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["specIconFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["specIconFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["specIconFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory", P.armory),
                set = self:GetFontColorSetter("TXUI.armory", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory["specIconFontColor"] ~= "CUSTOM"
                end
            }
        end
    end

    -- Item Slot
    do
        -- Tab
        local tab = self:AddGroup(options, {
            name = "Item Slot",
            get = function(info)
                return E.db.TXUI.armory.pageInfo[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.armory.pageInfo[info[#info]] = value
                TXUI:GetModule("Armory"):UpdateCharacterArmory()
            end,
            hidden = optionsHidden
        })

        -- Item Quality Gradient
        do
            -- Item Level Group
            local gradientGroup = self:AddInlineDesc(tab["args"], { name = "Item Quality Gradient" }, {
                name = "Settings for the color coming out of your item slot.\n\n"
            })

            -- Enable
            gradientGroup["args"]["itemQualityGradientEnabled"] =
                {
                    order = self:GetOrder(),
                    type = "toggle",
                    desc = "Toggling this on enables the Item Quality bars.",
                    name = function()
                        return self:GetEnableName(E.db.TXUI.armory.pageInfo.itemQualityGradientEnabled)
                    end
                }

            local optionsDisabled = function()
                return self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemQualityGradientEnabled) ~=
                           self.enabledState.YES
            end

            -- Gradient Width
            gradientGroup["args"]["itemQualityGradientWidth"] =
                {
                    order = self:GetOrder(),
                    type = "range",
                    name = "Width",
                    min = 10,
                    max = 120,
                    step = 1,
                    disabled = optionsDisabled
                }

            -- Gradient Height
            gradientGroup["args"]["itemQualityGradientHeight"] =
                {
                    order = self:GetOrder(),
                    type = "range",
                    name = "Height",
                    min = 1,
                    max = 40,
                    step = 1,
                    disabled = optionsDisabled
                }

            -- Start Alpha
            gradientGroup["args"]["itemQualityGradientStartAlpha"] =
                {
                    order = self:GetOrder(),
                    type = "range",
                    name = "Start Alpha",
                    min = 0,
                    max = 1,
                    step = 0.01,
                    isPercent = true,
                    disabled = optionsDisabled
                }

            -- End Alpha
            gradientGroup["args"]["itemQualityGradientEndAlpha"] =
                {
                    order = self:GetOrder(),
                    type = "range",
                    name = "End Alpha",
                    min = 0,
                    max = 1,
                    step = 0.01,
                    isPercent = true,
                    disabled = optionsDisabled
                }

        end

        -- Spacer
        self:AddSpacer(tab["args"])

        -- Enchant
        do
            -- Enchant Group
            local enchantGroup = self:AddInlineDesc(tab["args"], { name = "Enchant Strings" }, {
                name = "Settings for strings displaying enchant info about your item.\n\n"
            })

            -- Enable
            enchantGroup["args"]["enchantTextEnabled"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Toggling this on enables the " .. TXUI.Title .. " Armory Enchant strings.",
                name = function()
                    return self:GetEnableName(E.db.TXUI.armory.pageInfo.enchantTextEnabled)
                end
            }

            local optionsDisabled = function()
                return self:GetEnabledState(E.db.TXUI.armory.pageInfo.enchantTextEnabled) ~= self.enabledState.YES
            end

            -- Missing Enchant
            enchantGroup["args"]["missingEnchantText"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Shows a red 'Missing' string when you're missing an enchant.",
                name = "Missing Enchants",
                disabled = optionsDisabled
            }

            -- Abbreviate Enchant
            enchantGroup["args"]["abbreviateEnchantText"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Abbreviates the enchant strings.",
                name = "Short Enchants",
                disabled = optionsDisabled
            }

            -- Spacer
            self:AddSpacer(enchantGroup["args"])

            -- Fonts Font
            enchantGroup["args"]["enchantFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc(),
                disabled = optionsDisabled
            }

            -- Fonts Outline
            enchantGroup["args"]["enchantFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return
                        (self:GetEnabledState(E.db.TXUI.armory.pageInfo.enchantTextEnabled) ~= self.enabledState.YES) or
                            (E.db.TXUI.armory.pageInfo["enchantFontShadow"] == true)
                end
            }

            -- Fonts Size
            enchantGroup["args"]["enchantFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1,
                disabled = optionsDisabled
            }

            -- Fonts Shadow
            enchantGroup["args"]["enchantFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow.",
                disabled = optionsDisabled
            }
        end

        -- Spacer
        self:AddSpacer(tab["args"])

        -- Item Level
        do
            -- Item Level Group
            local itemLevelGroup = self:AddInlineDesc(tab["args"], { name = "Item Level" },
                                                      { name = "Settings for Item level next to your item slots.\n\n" })

            -- Enable
            itemLevelGroup["args"]["itemLevelTextEnabled"] =
                {
                    order = self:GetOrder(),
                    type = "toggle",
                    desc = "Toggle Item level display.",
                    name = function()
                        return self:GetEnableName(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled)
                    end
                }

            local optionsDisabled = function()
                return self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled) ~= self.enabledState.YES
            end

            -- Gem/Azerite Icons
            itemLevelGroup["args"]["iconsEnabled"] = {
                order = self:GetOrder(),
                type = "toggle",
                desc = "Toggle sockets & azerite traits.",
                name = "Sockets",
                disabled = optionsDisabled
            }

            -- Spacer
            self:AddSpacer(itemLevelGroup["args"])

            -- Fonts Font
            itemLevelGroup["args"]["iLvLFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc(),
                disabled = optionsDisabled
            }

            -- Fonts Outline
            itemLevelGroup["args"]["iLvLFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (self:GetEnabledState(E.db.TXUI.armory.pageInfo.itemLevelTextEnabled) ~=
                               self.enabledState.YES) or (E.db.TXUI.armory.pageInfo["iLvLFontShadow"] == true)
                end
            }

            -- Fonts Size
            itemLevelGroup["args"]["iLvLFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1,
                disabled = optionsDisabled
            }

            -- Fonts Shadow
            itemLevelGroup["args"]["iLvLFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow.",
                disabled = optionsDisabled
            }
        end
    end

    -- Stats
    do
        -- Tab
        local tab = self:AddGroup(options, {
            name = "Attributes",
            get = function(info)
                return E.db.TXUI.armory.stats[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.armory.stats[info[#info]] = value
                TXUI:GetModule("Armory"):UpdateCharacterArmory()
            end,
            hidden = optionsHidden
        })

        -- Alternating Background
        do
            -- General Group
            local backgroundGroup = self:AddInlineGroup(tab["args"], { name = "Background Bars" })

            -- Enable
            backgroundGroup["args"]["alternatingBackgroundEnabled"] =
                {
                    order = self:GetOrder(),
                    type = "toggle",
                    desc = "Toggles the blue bars behind every second number.",
                    name = function()
                        return self:GetEnableName(E.db.TXUI.armory.stats.alternatingBackgroundEnabled)
                    end
                }

            local optionsDisabled = function()
                return self:GetEnabledState(E.db.TXUI.armory.stats.alternatingBackgroundEnabled) ~=
                           self.enabledState.YES
            end

            -- Alpha
            backgroundGroup["args"]["alternatingBackgroundAlpha"] =
                {
                    order = self:GetOrder(),
                    type = "range",
                    name = "Alpha",
                    min = 0,
                    max = 1,
                    step = 0.01,
                    isPercent = true,
                    disabled = optionsDisabled
                }
        end

        -- Category Header Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Category Header" })

            -- Fonts Font
            fontGroup["args"]["headerFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["headerFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory.stats["headerFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["headerFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["headerFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["headerFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["headerFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
                set = self:GetFontColorSetter("TXUI.armory.stats", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory.stats["headerFontColor"] ~= "CUSTOM"
                end
            }
        end

        -- Label Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Attribute Label" })

            -- Fonts Font
            fontGroup["args"]["labelFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["labelFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory.stats["labelFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["labelFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["labelFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["labelFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["labelFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
                set = self:GetFontColorSetter("TXUI.armory.stats", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory.stats["labelFontColor"] ~= "CUSTOM"
                end
            }
        end

        -- Value Text
        do
            -- Font Group
            local fontGroup = self:AddInlineGroup(tab["args"], { name = "Attribute Value" })

            -- Fonts Font
            fontGroup["args"]["valueFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["valueFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.armory.stats["valueFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["valueFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 42,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["valueFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }

            -- Font color select
            fontGroup["args"]["valueFontColor"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Color",
                values = self:GetAllFontColorsFunc(
                    { ["GRADIENT"] = F.FastTextGradient("Gradient", 0, 0.6, 1, 0, 0.9, 1) })
            }

            -- Font Custom Color
            fontGroup["args"]["valueFontCustomColor"] = {
                order = self:GetOrder(),
                type = "color",
                name = "Custom Color",
                hasAlpha = true,
                get = self:GetFontColorGetter("TXUI.armory.stats", P.armory.stats),
                set = self:GetFontColorSetter("TXUI.armory.stats", function()
                    TXUI:GetModule("Armory"):UpdateCharacterArmory()
                end),
                hidden = function()
                    return E.db.TXUI.armory.stats["valueFontColor"] ~= "CUSTOM"
                end
            }
        end

        -- Stats Mode
        do
            -- Stats Mode Group
            local statsGroup = self:AddInlineGroup(tab["args"], { name = "Attribute Visibility" })

            -- Mode
            for stat, _ in pairs(P.armory.stats.mode) do
                statsGroup["args"][stat] = {
                    order = self:GetOrder(),
                    type = "select",
                    name = F.LowercaseEnum(stat),
                    values = { [0] = "Hide", [1] = "Show Only Relevant", [2] = "Show Above 0", [3] = "Always Show" },
                    get = function(info)
                        return E.db.TXUI.armory.stats.mode[info[#info]].mode
                    end,
                    set = function(info, value)
                        E.db.TXUI.armory.stats.mode[info[#info]].mode = value
                        TXUI:GetModule("Armory"):UpdateCharacterArmory()
                    end
                }
            end
        end
    end

end

O:AddCallback("Plugins_Armory")
