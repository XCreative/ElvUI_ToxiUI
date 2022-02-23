local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Plugins_BlizzardFonts()

    -- Create Tab
    self.options.plugins.args["blizzardFonts"] = {
        order = self:GetOrder(),
        type = "group",
        name = "Blizzard Fonts",
        get = function(info)
            return E.db.TXUI.blizzardFonts[info[#info]]
        end,
        set = function(info, value)
            E.db.TXUI.blizzardFonts[info[#info]] = value
            TXUI:GetModule("BlizzardFonts"):ProfileUpdate()
        end,
        args = {}
    }

    -- Options
    local options = self.options.plugins.args["blizzardFonts"]["args"]
    local optionsHidden

    -- General
    do
        -- General Group
        local generalGroup = self:AddInlineRequirementsDesc(options, { name = "Description" }, {
            name = "Replaces various fonts from Blizzard with the settings below.\n\n"
        }, I.Requirements.BlizzardFonts)

        -- Enable
        generalGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " BlizzardFonts.",
            name = function()
                return self:GetEnableName(E.db.TXUI.blizzardFonts.enabled, generalGroup)
            end
        }

        -- Hidden helper
        optionsHidden = function()
            return self:GetEnabledState(E.db.TXUI.blizzardFonts.enabled, generalGroup) ~= self.enabledState.YES
        end
    end

    -- Spacer
    self:AddSpacer(options)

    -- Zone Text
    do
        -- Zone Text Group
        local zoneTextGroup = self:AddInlineDesc(options, { name = "Zone Text", hidden = optionsHidden }, {
            name = "This will change the text in the middle of your screen when you enter a new zone/subzone"
        })

        -- Spacer
        self:AddSpacer(zoneTextGroup["args"])

        -- Main Zone Text
        do
            local fontGroup = self:AddInlineGroup(zoneTextGroup["args"], { name = "Zone Text" })

            -- Fonts Font
            fontGroup["args"]["zoneFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["zoneFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.blizzardFonts["zoneFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["zoneFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["zoneFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }
        end

        -- Subzone Text
        do
            local fontGroup = self:AddInlineGroup(zoneTextGroup["args"], { name = "Subzone Text" })

            -- Fonts Font
            fontGroup["args"]["subZoneFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["subZoneFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.blizzardFonts["subZoneFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["subZoneFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["subZoneFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }
        end

        -- PvP Zone Info Text
        do
            local fontGroup = self:AddInlineGroup(zoneTextGroup["args"], { name = "PvP Text" })

            -- Fonts Font
            fontGroup["args"]["pvpZoneFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["pvpZoneFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc(),
                disabled = function()
                    return (E.db.TXUI.blizzardFonts["pvpZoneFontShadow"] == true)
                end
            }

            -- Fonts Size
            fontGroup["args"]["pvpZoneFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }

            -- Fonts Shadow
            fontGroup["args"]["pvpZoneFontShadow"] = {
                order = self:GetOrder(),
                type = "toggle",
                name = "Font Shadow",
                desc = "Set font drop shadow."
            }
        end
    end

    -- Spacer
    self:AddSpacer(options)

    -- Misc Text
    do
        -- Misc Text Group
        local miscTextGroup = self:AddInlineDesc(options, { name = "Misc Text", hidden = optionsHidden },
                                                 { name = "This will change dialog frame texts." })

        -- Spacer
        self:AddSpacer(miscTextGroup["args"])

        -- Mail Text
        do
            local fontGroup = self:AddInlineGroup(miscTextGroup["args"], { name = "Mail Text" })

            -- Fonts Font
            fontGroup["args"]["mailFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["mailFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc()
            }

            -- Fonts Size
            fontGroup["args"]["mailFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }
        end

        -- Gossip/Quest Text
        do
            local fontGroup = self:AddInlineGroup(miscTextGroup["args"], { name = "Gossip/Quest Text" })

            -- Fonts Font
            fontGroup["args"]["gossipFont"] = {
                order = self:GetOrder(),
                type = "select",
                dialogControl = "LSM30_Font",
                name = "Font",
                desc = "Set the font.",
                values = self:GetAllFontsFunc()
            }

            -- Fonts Outline
            fontGroup["args"]["gossipFontOutline"] = {
                order = self:GetOrder(),
                type = "select",
                name = "Font Outline",
                desc = "Set the font outline.",
                values = self:GetAllFontOutlinesFunc()
            }

            -- Fonts Size
            fontGroup["args"]["gossipFontSize"] = {
                order = self:GetOrder(),
                type = "range",
                name = "Font Size",
                desc = "Set the font size.",
                min = 1,
                max = 100,
                step = 1
            }
        end
    end
end

O:AddCallback("Plugins_BlizzardFonts")
