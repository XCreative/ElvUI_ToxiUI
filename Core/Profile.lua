local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local _G = _G

-- Defaults
P.installer = { ["layout"] = I.Enum.Layouts.DPS }
P.changelog = { ["seenVersion"] = 0, ["releaseVersion"] = 0, ["lastLayoutVersion"] = 0, ["lastDBConversion"] = 0 }

-- General
P.general = {
    ["overrideDevMode"] = true -- force disable dev mode
}

-- Themes
P.themes = {
    ["darkMode"] = {
        ["enabled"] = false, -- Disabled by default
        ["transparency"] = false, -- Disabled by default
        ["transparencyAlpha"] = 0.7 -- Alpha of Background
    },
    ["gradientMode"] = {
        ["enabled"] = true, -- Enabled by default
        ["texture"] = E.media.blankTex,
        ["interruptCDEnabled"] = false,
        ["interruptSoonEnabled"] = false,
        ["reactionColorMap"] = {
            [I.Enum.GradientMode.Color.NORMAL] = {
                ["BAD"] = { ["r"] = 0.85, ["g"] = 0.25, ["b"] = 0.25 }, -- Enemy
                ["NEUTRAL"] = { ["r"] = 0.87, ["g"] = 0.76, ["b"] = 0.29 }, -- neutral
                ["GOOD"] = { ["r"] = 0.14, ["g"] = 0.85, ["b"] = 0.15 } -- friendly
            },
            [I.Enum.GradientMode.Color.SHIFT] = {
                ["BAD"] = { ["r"] = 0.78, ["g"] = 0.13, ["b"] = 0.13 }, -- Enemy
                ["NEUTRAL"] = { ["r"] = 0.81, ["g"] = 0.57, ["b"] = 0.27 }, -- neutral
                ["GOOD"] = { ["r"] = 0.15, ["g"] = 0.65, ["b"] = 0.00 } -- friendly
            }
        },
        ["castColorMap"] = {
            [I.Enum.GradientMode.Color.NORMAL] = {
                ["DEFAULT"] = { ["r"] = 1.00, ["g"] = 0.75, ["b"] = 0.00 }, -- cast def.
                ["NOINTERRUPT"] = { ["r"] = 0.56, ["g"] = 0.55, ["b"] = 0.55 }, -- cast non.
                ["INTERRUPTED"] = { ["r"] = 0.85, ["g"] = 0.25, ["b"] = 0.25 } -- cast was stopped
            },
            [I.Enum.GradientMode.Color.SHIFT] = {
                ["DEFAULT"] = { ["r"] = 1.00, ["g"] = 0.68, ["b"] = 0.00 }, -- cast def.
                ["NOINTERRUPT"] = { ["r"] = 0.45, ["g"] = 0.44, ["b"] = 0.44 }, -- cast non.
                ["INTERRUPTED"] = { ["r"] = 0.60, ["g"] = 0.12, ["b"] = 0.12 } -- cast was stopped
            }
        },
        ["powerColorMap"] = {
            [I.Enum.GradientMode.Color.NORMAL] = {
                ["ALT_POWER"] = { ["r"] = 0.13, ["g"] = 0.46, ["b"] = 0.83 }, -- swap alt
                ["MANA"] = { ["r"] = 0.26, ["g"] = 0.85, ["b"] = 0.82 }, -- mana
                ["RAGE"] = { ["r"] = 0.93, ["g"] = 0.20, ["b"] = 0.20 }, -- rage
                ["FOCUS"] = { ["r"] = 0.86, ["g"] = 0.46, ["b"] = 0.23 }, -- focus
                ["ENERGY"] = { ["r"] = 0.85, ["g"] = 0.85, ["b"] = 0.17 }, -- energy
                ["RUNIC_POWER"] = { ["r"] = 0.11, ["g"] = 0.84, ["b"] = 1.00 }, -- runic
                ["PAIN"] = { ["r"] = 0.96, ["g"] = 0.96, ["b"] = 0.96 }, -- pain
                ["FURY"] = { ["r"] = 0.91, ["g"] = 0.12, ["b"] = 0.96 }, -- fury
                ["LUNAR_POWER"] = { ["r"] = 0.61, ["g"] = 0.33, ["b"] = 1.00 }, -- astral
                ["INSANITY"] = { ["r"] = 0.59, ["g"] = 0.16, ["b"] = 0.74 }, -- insanity
                ["MAELSTROM"] = { ["r"] = 0.00, ["g"] = 0.59, ["b"] = 1.00 } -- maelstrom
            },
            [I.Enum.GradientMode.Color.SHIFT] = {
                ["ALT_POWER"] = { ["r"] = 0.15, ["g"] = 0.29, ["b"] = 0.82 }, -- swap alt
                ["MANA"] = { ["r"] = 0.04, ["g"] = 0.78, ["b"] = 0.87 }, -- mana
                ["RAGE"] = { ["r"] = 0.81, ["g"] = 0.09, ["b"] = 0.09 }, -- rage
                ["FOCUS"] = { ["r"] = 0.81, ["g"] = 0.35, ["b"] = 0.12 }, -- focus
                ["ENERGY"] = { ["r"] = 0.82, ["g"] = 0.72, ["b"] = 0.00 }, -- energy
                ["RUNIC_POWER"] = { ["r"] = 0.00, ["g"] = 0.61, ["b"] = 1.00 }, -- runic
                ["PAIN"] = { ["r"] = 0.80, ["g"] = 0.80, ["b"] = 0.80 }, -- pain
                ["FURY"] = { ["r"] = 0.77, ["g"] = 0.08, ["b"] = 0.71 }, -- fury
                ["LUNAR_POWER"] = { ["r"] = 0.62, ["g"] = 0.31, ["b"] = 0.91 }, -- astral
                ["INSANITY"] = { ["r"] = 0.52, ["g"] = 0.04, ["b"] = 0.69 }, -- insanity
                ["MAELSTROM"] = { ["r"] = 0.00, ["g"] = 0.45, ["b"] = 1.00 } -- maelstrom
            }
        },
        ["specialColorMap"] = {
            [I.Enum.GradientMode.Color.NORMAL] = {
                ["DISCONNECTED"] = { ["r"] = 1.00, ["g"] = 0.42, ["b"] = 0.35 }, -- disconnect
                ["TAPPED"] = { ["r"] = 0.64, ["g"] = 0.65, ["b"] = 0.69 } -- tapped
            },
            [I.Enum.GradientMode.Color.SHIFT] = {
                ["DISCONNECTED"] = { ["r"] = 0.91, ["g"] = 0.34, ["b"] = 0.28 }, -- disconnect
                ["TAPPED"] = { ["r"] = 0.49, ["g"] = 0.51, ["b"] = 0.56 } -- tapped
            }
        },
        ["classColorMap"] = {
            [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
                ["DEATHKNIGHT"] = { ["r"] = 0.96, ["g"] = 0.15, ["b"] = 0.32 },
                ["DEMONHUNTER"] = { ["r"] = 0.73, ["g"] = 0, ["b"] = 0.96 },
                ["DRUID"] = { ["r"] = 1.00, ["g"] = 0.49, ["b"] = 0.04 },
                ["HUNTER"] = { ["r"] = 0.67, ["g"] = 0.93, ["b"] = 0.31 },
                ["MAGE"] = { ["r"] = 0.20, ["g"] = 0.78, ["b"] = 0.99 },
                ["MONK"] = { ["r"] = 0, ["g"] = 1.00, ["b"] = 0.59 },
                ["PALADIN"] = { ["r"] = 0.96, ["g"] = 0.55, ["b"] = 0.73 },
                ["PRIEST"] = { ["r"] = 1.00, ["g"] = 1.00, ["b"] = 1.00 },
                ["ROGUE"] = { ["r"] = 1.00, ["g"] = 0.92, ["b"] = 0.25 },
                ["SHAMAN"] = { ["r"] = 0.04, ["g"] = 0.49, ["b"] = 0.93 },
                ["WARLOCK"] = { ["r"] = 0.52, ["g"] = 0.38, ["b"] = 0.93 },
                ["WARRIOR"] = { ["r"] = 0.88, ["g"] = 0.64, ["b"] = 0.38 }
            },
            [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
                ["DEATHKNIGHT"] = { ["r"] = 0.73, ["g"] = 0.11, ["b"] = 0.17 },
                ["DEMONHUNTER"] = { ["r"] = 0.70, ["g"] = 0, ["b"] = 0.54 },
                ["DRUID"] = { ["r"] = 1.00, ["g"] = 0.37, ["b"] = 0.04 },
                ["HUNTER"] = { ["r"] = 0.60, ["g"] = 0.80, ["b"] = 0.33 },
                ["MAGE"] = { ["r"] = 0.02, ["g"] = 0.60, ["b"] = 0.81 },
                ["MONK"] = { ["r"] = 0.02, ["g"] = 0.75, ["b"] = 0.45 },
                ["PALADIN"] = { ["r"] = 0.85, ["g"] = 0.33, ["b"] = 0.56 },
                ["PRIEST"] = { ["r"] = 0.82, ["g"] = 0.82, ["b"] = 0.82 },
                ["ROGUE"] = { ["r"] = 1.00, ["g"] = 0.82, ["b"] = 0.26 },
                ["SHAMAN"] = { ["r"] = 0, ["g"] = 0.38, ["b"] = 0.75 },
                ["WARLOCK"] = { ["r"] = 0.39, ["g"] = 0.29, ["b"] = 0.68 },
                ["WARRIOR"] = { ["r"] = 0.78, ["g"] = 0.55, ["b"] = 0.29 }
            }
        }
    }
}

-- AddOn Skinning
P.addons = {
    -- ElvUI Theme
    ["elvUITheme"] = {
        ["enabled"] = false, -- Disabled by default

        ["shadowEnabled"] = false, -- Disabled by default
        ["shadowAlpha"] = 0.45,
        ["shadowSize"] = 3
    },

    -- ElvUI Fonts
    ["fontScale"] = 0,

    -- AFK Mode
    ["afkMode"] = {
        ["enabled"] = true, -- Enabled by default
        ["turnCamera"] = true,
        ["playEmotes"] = true
    },

    -- Deconstruct
    ["deconstruct"] = {
        ["enabled"] = true, -- Enabled by default
        ["highlightMode"] = "DARK", -- DARK by default, possible "NONE", "DARK", "ALPHA"

        ["animations"] = true,
        ["animationsMult"] = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
        -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

        ["glowEnabled"] = true, -- Enabled by default
        ["glowAlpha"] = 1,

        ["labelEnabled"] = true, -- Enabled by default
        ["labelFont"] = "- Steelfish",
        ["labelFontSize"] = 20,
        ["labelFontShadow"] = false,
        ["labelFontOutline"] = "OUTLINE"
    },

    -- Game Menu Button
    ["gameMenuButton"] = {
        ["enabled"] = true -- Enabled by default
    },

    -- Fade Persist
    ["fadePersist"] = {
        ["enabled"] = true, -- Enabled by default
        ["mode"] = "MOUSEOVER" -- MOUSEOVER, NO_COMBAT, IN_COMBAT, ELVUI, ALWAYS
    },

    -- WeakAuras
    ["weakAurasBars"] = {
        ["enabled"] = true -- Enabled by default
    },
    ["weakAurasIcons"] = {
        ["enabled"] = true, -- Enabled by default
        ["iconShape"] = I.Enum.IconShape.RECTANGLE
    }
}

-- ElvUI Icons
P.elvUIIcons = {
    ["roleIcons"] = {
        ["enabled"] = true, -- Enabled by default
        ["theme"] = "TXUI"
    },

    ["deadIcons"] = {
        ["enabled"] = true, -- Enabled by default
        ["theme"] = "TXUI",
        ["size"] = 41,
        ["xOffset"] = 0,
        ["yOffset"] = 10
    },

    ["offlineIcons"] = {
        ["enabled"] = true, -- Enabled by default
        ["theme"] = "TXUI",
        ["size"] = 46,
        ["xOffset"] = 0,
        ["yOffset"] = 0
    }
}

-- Blizzard Fonts
P.blizzardFonts = {
    ["enabled"] = true, -- Enabled by default

    -- Zone
    ["zoneFont"] = "- Futura",
    ["zoneFontSize"] = 33,
    ["zoneFontShadow"] = true,
    ["zoneFontOutline"] = "NONE",

    -- Sub-Zone
    ["subZoneFont"] = "- Futura",
    ["subZoneFontSize"] = 32,
    ["subZoneFontShadow"] = true,
    ["subZoneFontOutline"] = "NONE",

    -- PvP-Zone
    ["pvpZoneFont"] = "- Futura",
    ["pvpZoneFontSize"] = 22,
    ["pvpZoneFontShadow"] = true,
    ["pvpZoneFontOutline"] = "NONE",

    -- Mail Text
    ["mailFont"] = "- Futura",
    ["mailFontSize"] = 14,
    ["mailFontShadow"] = false, -- dosen't support shadows
    ["mailFontOutline"] = "NONE",

    -- Gossip/Quest Text
    ["gossipFont"] = "- Futura",
    ["gossipFontSize"] = 14,
    ["gossipFontShadow"] = false, -- dosen't support shadows
    ["gossipFontOutline"] = "NONE"
}

-- VehicleBar
P.vehicleBar = {
    ["enabled"] = true,
    ["animations"] = true,
    ["animationsMult"] = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
    -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

    ["position"] = "BOTTOM,ElvUIParent,BOTTOM,0,210"
}

-- MiniMapCoords
P.miniMapCoords = {
    ["enabled"] = true,
    ["xOffset"] = 0,
    ["yOffset"] = -115,
    ["format"] = "%.0f",

    ["coordFont"] = "- Steelfish",
    ["coordFontSize"] = 22,
    ["coordFontShadow"] = false,
    ["coordFontOutline"] = "OUTLINE",
    ["coordFontColor"] = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    ["coordFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 }
}

-- Armory
P.armory = {
    ["enabled"] = true, -- Enabled by default

    ["animations"] = true,
    ["animationsMult"] = 3.3333, -- Animation speed, higher than 1 => slower, lower than 1 => faster
    -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

    ["background"] = {
        ["enabled"] = true, -- Enabled by default
        ["alpha"] = 0.5,
        ["style"] = 1
    },

    ["stats"] = {
        ["showAvgItemLevel"] = true, -- Enabled by default
        ["itemLevelFormat"] = "%.2f",

        ["itemLevelFont"] = "- Big Noodle Titling",
        ["itemLevelFontSize"] = 30,
        ["itemLevelFontShadow"] = true,
        ["itemLevelFontOutline"] = "NONE",
        ["itemLevelFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
        ["itemLevelFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["headerFont"] = "- Big Noodle Titling",
        ["headerFontSize"] = 22,
        ["headerFontShadow"] = true,
        ["headerFontOutline"] = "NONE",
        ["headerFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
        ["headerFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["labelFont"] = "- Futura",
        ["labelFontSize"] = 15,
        ["labelFontShadow"] = true,
        ["labelFontOutline"] = "NONE",
        ["labelFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
        ["labelFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["valueFont"] = "- Futura",
        ["valueFontSize"] = 15,
        ["valueFontShadow"] = true,
        ["valueFontOutline"] = "NONE",
        ["valueFontColor"] = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
        ["valueFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["alternatingBackgroundEnabled"] = true, -- Enabled by default
        ["alternatingBackgroundAlpha"] = 0.5,

        -- Sets the mode for stats
        -- 0 (Hide), 1 (Smart/Blizzard), 2 (Always Show if not 0), 3 (Always Show)
        ["mode"] = {
            -- Attributes Category
            ["STRENGTH"] = { mode = 1 },
            ["AGILITY"] = { mode = 1 },
            ["INTELLECT"] = { mode = 1 },
            ["STAMINA"] = { mode = 1 },
            ["HEALTH"] = { mode = 0 },
            ["POWER"] = { mode = 0 },
            ["ARMOR"] = { mode = 0 },
            ["STAGGER"] = { mode = 0 },
            ["MANAREGEN"] = { mode = 0 },
            ["ENERGY_REGEN"] = { mode = 0 },
            ["RUNE_REGEN"] = { mode = 0 },
            ["FOCUS_REGEN"] = { mode = 0 },
            ["MOVESPEED"] = { mode = 1 },

            -- Enhancements Category
            ["ATTACK_DAMAGE"] = { mode = 0 },
            ["ATTACK_AP"] = { mode = 0 },
            ["ATTACK_ATTACKSPEED"] = { mode = 0 },
            ["SPELLPOWER"] = { mode = 0 },
            ["CRITCHANCE"] = { mode = 1 },
            ["HASTE"] = { mode = 1 },
            ["MASTERY"] = { mode = 1 },
            ["VERSATILITY"] = { mode = 1 },
            ["LIFESTEAL"] = { mode = 0 },
            ["AVOIDANCE"] = { mode = 0 },
            ["SPEED"] = { mode = 0 },
            ["DODGE"] = { mode = 0 },
            ["PARRY"] = { mode = 0 },
            ["BLOCK"] = { mode = 0 }
        }
    },

    ["pageInfo"] = {
        ["itemLevelTextEnabled"] = true,
        ["iconsEnabled"] = true,

        ["enchantTextEnabled"] = true,
        ["abbreviateEnchantText"] = false,
        ["missingEnchantText"] = true,

        ["itemQualityGradientEnabled"] = true,
        ["itemQualityGradientWidth"] = 65,
        ["itemQualityGradientHeight"] = 3,
        ["itemQualityGradientStartAlpha"] = 1,
        ["itemQualityGradientEndAlpha"] = 0,

        ["iLvLFont"] = "- Futura",
        ["iLvLFontSize"] = 14,
        ["iLvLFontShadow"] = true,
        ["iLvLFontOutline"] = "NONE",

        ["enchantFont"] = "- Futura",
        ["enchantFontSize"] = 14,
        ["enchantFontShadow"] = true,
        ["enchantFontOutline"] = "NONE"
    },

    ["nameTextOffsetX"] = 0,
    ["nameTextOffsetY"] = 0,
    ["nameTextFont"] = "- Big Noodle Titling",
    ["nameTextFontSize"] = 22,
    ["nameTextFontShadow"] = true,
    ["nameTextFontOutline"] = "NONE",
    ["nameTextFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    ["nameTextFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 },

    ["titleTextOffsetX"] = 5,
    ["titleTextOffsetY"] = -2,
    ["titleTextFont"] = "- Big Noodle Titling",
    ["titleTextFontSize"] = 16,
    ["titleTextFontShadow"] = true,
    ["titleTextFontOutline"] = "NONE",
    ["titleTextFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    ["titleTextFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 },

    ["levelTitleTextOffsetX"] = 0,
    ["levelTitleTextOffsetY"] = -1,
    ["levelTitleTextFont"] = "- Big Noodle Titling",
    ["levelTitleTextFontSize"] = 20,
    ["levelTitleTextFontShadow"] = true,
    ["levelTitleTextFontOutline"] = "NONE",
    ["levelTitleTextFontColor"] = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    ["levelTitleTextFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 },

    ["levelTextOffsetX"] = 0,
    ["levelTextOffsetY"] = -1,
    ["levelTextFont"] = "- Big Noodle Titling",
    ["levelTextFontSize"] = 24,
    ["levelTextFontShadow"] = true,
    ["levelTextFontOutline"] = "NONE",
    ["levelTextFontColor"] = "CUSTOM", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
    ["levelTextFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 },

    ["specIconFont"] = "- ToxiUI Icons",
    ["specIconFontSize"] = 18,
    ["specIconFontShadow"] = true,
    ["specIconFontOutline"] = "NONE",
    ["specIconFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    ["specIconFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 },

    ["classTextOffsetX"] = 0,
    ["classTextOffsetY"] = -2,
    ["classTextFont"] = "- Big Noodle Titling",
    ["classTextFontSize"] = 20,
    ["classTextFontShadow"] = true,
    ["classTextFontOutline"] = "NONE",
    ["classTextFontColor"] = "GRADIENT", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM, GRADIENT
    ["classTextFontCustomColor"] = { ["r"] = 0.84, ["g"] = 0.73, ["b"] = 0, ["a"] = 1 }
}

-- Wunderbar
P.wunderbar = {
    ["general"] = {
        ["enabled"] = true,

        ["experimentalDynamicSize"] = true,

        ["animations"] = true,
        ["animationsEvents"] = false,
        ["animationsMult"] = 1, -- Animation speed, higher than 1 => slower, lower than 1 => faster
        -- This applies to bar combat fadeIn/fadeOut and "normal" font color changes (not clock/txui button etc)

        ["barWidth"] = E.physicalWidth,
        ["barHeight"] = 30,
        ["barSpacing"] = 20, -- spacing from the screen edges, reduces the size of the 3 panels
        ["barVisibility"] = "NO_COMBAT", -- ALWAYS, NO_COMBAT, RESTING
        ["barMouseOverOnly"] = false,

        ["noCombatClick"] = true,
        ["noCombatHover"] = false,

        ["backgroundTexture"] = "BuiOnePixel",
        ["backgroundColor"] = "CLASS", -- NONE, CLASS, VALUE (ElvUI), CUSTOM
        ["backgroundCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 0 },
        ["backgroundGradient"] = false,
        ["backgroundGradientAlpha"] = 1,

        ["accentFontColor"] = "TXUI", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
        ["accentFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["iconFont"] = "- ToxiUI Icons",
        ["iconFontColor"] = "NONE", -- CLASS, TXUI, VALUE (ElvUI), CUSTOM
        ["iconFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 },

        ["normalFont"] = "- Futura",
        ["normalFontSize"] = 14,
        ["normalFontShadow"] = true,
        ["normalFontOutline"] = "NONE",
        ["normalFontColor"] = "NONE", -- NONE, CLASS, TXUI, VALUE (ElvUI), CUSTOM
        ["normalFontCustomColor"] = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1 }
    },
    ["modules"] = {
        ["LeftPanel"] = { "MicroMenu", "", "Durability" },
        ["MiddlePanel"] = { "SpecSwitch", "Time", "Profession" },
        ["RightPanel"] = { "Currency", "System", "Hearthstone" }
    },
    ["subModules"] = {
        ["Time"] = {
            ["localTime"] = true, -- this should be in sync with ElvUI profile for better tooltips
            ["twentyFour"] = _G.GetCurrentRegion() ~= 1, -- sets 24h for everyone, except US
            ["timeFormat"] = "HH:MM", -- valid are HH:MM, H:MM, H:M

            ["experimentalDynamicSize"] = false,

            ["textOffset"] = 1,
            ["mainFontSize"] = 32,
            ["useAccent"] = true,

            ["flashColon"] = true,
            ["flashOnInvite"] = true,

            ["infoEnabled"] = true,
            ["infoFont"] = "- Futura",
            ["infoFontSize"] = 16,
            ["infoOffset"] = 24,
            ["infoUseAccent"] = true,
            ["infoTextDisplayed"] = { ["mail"] = true, ["date"] = true, ["ampm"] = false }
        },
        ["System"] = {
            ["iconLatency"] = "",
            ["iconFramerate"] = "",
            ["iconColor"] = true,
            ["iconFontSize"] = 18,

            ["textColor"] = true,
            ["textColorFadeFromNormal"] = true,
            ["textColorLatencyThreshold"] = 60, -- or above
            ["textColorFramerateThreshold"] = 60, -- or under

            ["showIcons"] = true,
            ["fastUpdate"] = true,

            ["useWorldLatency"] = false
        },
        ["DataBar"] = {
            ["mode"] = "auto",

            ["icon"] = "",
            ["iconFontSize"] = 18,

            ["infoEnabled"] = false,
            ["infoFont"] = "- Futura",
            ["infoFontSize"] = 17,
            ["infoOffset"] = 13,
            ["infoUseAccent"] = true,

            ["showCompletedXP"] = false,
            ["showIcon"] = true,
            ["barHeight"] = 10,
            ["barOffset"] = 0
        },
        ["Profession"] = {
            ["general"] = {
                ["useUppercase"] = true,

                ["selectedProf1"] = 1, -- 0 = Disabled, 1 = Prof1, anything else = override
                ["selectedProf2"] = 1, -- 0 = Disabled, 1 = Prof2, anything else = override

                ["iconFontSize"] = 18,

                ["showIcons"] = true,
                ["showBars"] = true,

                ["barHeight"] = 2,
                ["barOffset"] = -4,
                ["barSpacing"] = 4
            },
            ["icons"] = {
                [164] = "", -- Blacksmithing
                [165] = "", -- Leatherworking
                [171] = "", -- Alchemy
                [182] = "", -- Herbalism
                [185] = "", -- Cooking
                [186] = "", -- Mining
                [202] = "", -- Engineering
                [333] = "", -- Enchanting
                [356] = "", -- Fishing
                [755] = "", -- Jewelcrafting
                [773] = "", -- Inscription
                [197] = "", -- Tailoring
                [393] = "", -- Skinning
                [794] = "" -- Archaeology
            }
        },
        ["Currency"] = {
            ["icon"] = "",
            ["iconFontSize"] = 18,

            ["displayedCurrency"] = "GOLD", -- NEEDS to be GOLD
            ["enabledCurrencies"] = {
                [1767] = true, -- Stygia
                [1828] = true, -- Soul Ash
                [1813] = true -- Reservoir Anima
            }, -- Format: [currencyID] = true,

            ["showIcon"] = true,
            ["showSmall"] = false,
            ["showBagSpace"] = true
        },
        ["Volume"] = {
            ["showIcon"] = true,
            ["useUppercase"] = true,
            ["textColor"] = "GREEN", -- NONE, GREEN, ACCENT

            ["icon"] = "",
            ["iconColor"] = false,
            ["iconFontSize"] = 18
        },
        ["Hearthstone"] = {
            ["showIcon"] = true,

            ["icon"] = "",
            ["iconColor"] = false,
            ["iconFontSize"] = 18,

            ["cooldownEnabled"] = true,
            ["cooldownFont"] = "- Futura",
            ["cooldownFontSize"] = 18,
            ["cooldownOffset"] = 16,
            ["cooldownUseAccent"] = true,

            ["useUppercase"] = true,

            ["textColor"] = true,
            ["textColorFadeToNormal"] = true,

            ["primaryHS"] = 6948,
            ["secondaryHS"] = 110560,
            ["additionaHS"] = {}
        },
        ["Durability"] = {
            ["icon"] = "",
            ["iconColor"] = false,
            ["iconFontSize"] = 18,

            ["textColor"] = true,
            ["textColorFadeFromNormal"] = true,

            ["showIcon"] = true,
            ["showPerc"] = true,
            ["showItemLevel"] = true,
            ["itemLevelShort"] = true, -- hides decimal places

            ["animateLow"] = true,
            ["animateThreshold"] = 20
        },
        ["SpecSwitch"] = {
            ["general"] = {
                ["useUppercase"] = true,

                ["showIcons"] = true,
                ["showSpec1"] = true, -- active spec
                ["showSpec2"] = false, -- loot spec

                ["iconFontSize"] = 18,

                ["infoEnabled"] = true,
                ["infoShowIcon"] = false,
                ["infoFont"] = "- Futura",
                ["infoIcon"] = "",
                ["infoFontSize"] = 12,
                ["infoOffset"] = 18,
                ["infoUseAccent"] = true
            },
            ["icons"] = {
                [0] = "", -- unknown
                [62] = "", -- mage arcane
                [63] = "", -- mage fire
                [64] = "", -- mage frost
                [65] = "", -- pala holy
                [66] = "", -- pala prot
                [70] = "", -- pala ret
                [71] = "", -- warr arms
                [72] = "", -- warr fury
                [73] = "", -- warr prot
                [102] = "", -- drui balance
                [103] = "", -- drui feral
                [104] = "", -- drui bear
                [105] = "", -- drui resto
                [250] = "", -- dk blood
                [251] = "", -- dk frost
                [252] = "", -- dk unholy
                [253] = "", -- hun bm
                [254] = "", -- hun mm
                [255] = "", -- hun sv
                [256] = "", -- pri disc
                [257] = "", -- pri holy
                [258] = "", -- pri shadow
                [259] = "", -- rog ass
                [260] = "", -- rog outlaw
                [261] = "", -- rog sub
                [262] = "", -- sha ele
                [263] = "", -- sha enha
                [264] = "", -- sha resto
                [265] = "", -- lock affl
                [266] = "", -- lock demo
                [267] = "", -- lock destro
                [268] = "", -- monk brew
                [269] = "", -- monk wind
                [270] = "", -- monk mist
                [577] = "", -- dh havoc
                [581] = "" -- dh veng
            }
        },
        ["MicroMenu"] = {
            ["general"] = {
                ["infoEnabled"] = true,
                ["infoFont"] = "- Futura",
                ["infoFontSize"] = 18,
                ["infoOffset"] = 15,
                ["infoUseAccent"] = true,

                ["iconFontSize"] = 20,
                ["iconSpacing"] = 10,

                ["additionalTooltips"] = true,
                ["newbieToolips"] = true,
                ["onlyFriendsWoW"] = false,
                ["onlyFriendsWoWRetail"] = false
            },
            ["icons"] = {
                ["menu"] = { ["enabled"] = true, ["icon"] = "" },
                ["chat"] = { ["enabled"] = true, ["icon"] = "" },
                ["guild"] = { ["enabled"] = true, ["icon"] = "" },
                ["social"] = { ["enabled"] = true, ["icon"] = "" },
                ["char"] = { ["enabled"] = true, ["icon"] = "" },
                ["spell"] = { ["enabled"] = true, ["icon"] = "" },
                ["talent"] = { ["enabled"] = true, ["icon"] = "" },
                ["ach"] = { ["enabled"] = true, ["icon"] = "" },
                ["quest"] = { ["enabled"] = true, ["icon"] = "" },
                ["lfg"] = { ["enabled"] = true, ["icon"] = "" },
                ["journal"] = { ["enabled"] = true, ["icon"] = "" },
                ["pvp"] = { ["enabled"] = true, ["icon"] = "", ["icon_a"] = "", ["icon_h"] = "" },
                ["pet"] = { ["enabled"] = true, ["icon"] = "" },
                ["shop"] = { ["enabled"] = true, ["icon"] = "" },
                ["help"] = { ["enabled"] = false, ["icon"] = "" },
                ["txui"] = { ["enabled"] = true, ["icon"] = "" }
            }
        },
        ["ElvUILDB"] = { ["useUppercase"] = true, ["textColor"] = false }
    }
}
