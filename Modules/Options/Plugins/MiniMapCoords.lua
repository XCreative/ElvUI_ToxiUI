local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Plugins_MiniMapCoords()

    -- Create Tab
    self.options.plugins.args["miniMapCoords"] = {
        order = self:GetOrder(),
        type = "group",
        name = "MiniMapCoords",
        get = function(info)
            return E.db.TXUI.miniMapCoords[info[#info]]
        end,
        set = function(info, value)
            E.db.TXUI.miniMapCoords[info[#info]] = value
            TXUI:GetModule("MiniMapCoords"):ProfileUpdate()
        end,
        args = {}
    }

    -- Options
    local options = self.options.plugins.args["miniMapCoords"]["args"]
    local optionsHidden

    -- General
    do
        -- General Group
        local generalGroup = self:AddInlineRequirementsDesc(options, { name = "Description" },
                                                            { name = "Coordinates displayed on your MiniMap.\n\n" },
                                                            I.Requirements.MiniMapCoords)

        -- Enable
        generalGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " MiniMapCoords.",
            name = function()
                return self:GetEnableName(E.db.TXUI.miniMapCoords.enabled, generalGroup)
            end
        }

        -- Hidden helper
        optionsHidden = function()
            return self:GetEnabledState(E.db.TXUI.miniMapCoords.enabled, generalGroup) ~= self.enabledState.YES
        end
    end

    -- Spacer
    self:AddSpacer(options)

    -- Position
    do
        -- Position Group
        local positionGroup = self:AddInlineDesc(options, { name = "Position", hidden = optionsHidden }, {
            name = "Coordinate position relative to the minimap -- both settings at 0 would be the center."
        })

        -- Position X
        positionGroup["args"]["xOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "X Offset",
            min = -300,
            max = 300,
            step = 1
        }

        -- Position Y
        positionGroup["args"]["yOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Y Offset",
            min = -300,
            max = 300,
            step = 1
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- Fonts
    do
        -- Fonts Group
        local fontGroup = self:AddInlineDesc(options, { name = "Font", hidden = optionsHidden },
                                             { name = "Font settings for Minimap Coordinates." })

        -- Fonts Font
        fontGroup["args"]["coordFont"] = {
            order = self:GetOrder(),
            type = "select",
            dialogControl = "LSM30_Font",
            name = "Font",
            desc = "Set the font.",
            values = self:GetAllFontsFunc()
        }

        -- Fonts Outline
        fontGroup["args"]["coordFontOutline"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Font Outline",
            desc = "Set the font outline.",
            values = self:GetAllFontOutlinesFunc(),
            disabled = function()
                return (E.db.TXUI.miniMapCoords["coordFontShadow"] == true)
            end
        }

        -- Fonts Size
        fontGroup["args"]["coordFontSize"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Font Size",
            desc = "Set the font size.",
            min = 1,
            max = 100,
            step = 1
        }

        -- Fonts Shadow
        fontGroup["args"]["coordFontShadow"] = {
            order = self:GetOrder(),
            type = "toggle",
            name = "Font Shadow",
            desc = "Set font drop shadow."
        }

        -- Spacer
        self:AddSpacer(fontGroup.args)

        -- Font color select
        fontGroup["args"]["coordFontColor"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Font Color",
            values = self:GetAllFontColorsFunc()
        }

        -- Font Custom Color
        fontGroup["args"]["coordFontCustomColor"] = {
            order = self:GetOrder(),
            type = "color",
            name = "Custom Color",
            hasAlpha = true,
            get = self:GetFontColorGetter("TXUI.miniMapCoords", P.miniMapCoords),
            set = self:GetFontColorSetter("TXUI.miniMapCoords", function()
                TXUI:GetModule("MiniMapCoords"):ProfileUpdate()
            end),
            hidden = function()
                return E.db.TXUI.miniMapCoords.coordFontColor ~= "CUSTOM"
            end
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- Format
    do
        -- Format Group
        local formatGroup = self:AddInlineDesc(options, { name = "Format", hidden = optionsHidden },
                                               { name = "Decimal format of Minimap Coordinates" })

        -- Formats
        formatGroup["args"]["format"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Format",
            desc = "Decimal format",
            values = { ["%.0f"] = "42", ["%.1f"] = "42.0", ["%.2f"] = "42.01", ["%.3f"] = "42.012" }
        }
    end
end

O:AddCallback("Plugins_MiniMapCoords")
