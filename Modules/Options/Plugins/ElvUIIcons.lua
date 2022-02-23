local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Plugins_ElvUIIcons()

    -- Create Tab
    self.options.plugins.args["elvUIIcons"] =
        { order = self:GetOrder(), type = "group", name = "ElvUI Icons", args = {} }

    -- Options
    local options = self.options.plugins.args["elvUIIcons"]["args"]

    -- Description
    self:AddInlineDesc(options, { name = "Description" }, {
        name = TXUI.Title .. " changes certain " .. F.StringElvUI("ElvUI") ..
            " icons that you can enable/disable below."
    })

    -- Spacer
    self:AddSpacer(options)

    -- Role Icons
    do
        -- Role Icon Group
        local roleIconGroup = self:AddInlineRequirementsDesc(options, {
            name = "Role Icons",
            get = function(info)
                return E.db.TXUI.elvUIIcons.roleIcons[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.elvUIIcons.roleIcons[info[#info]] = value
                TXUI:GetModule("DeadIcons"):ProfileUpdate()
            end
        }, {
            name = "Change the Role icons of " .. F.StringElvUI("ElvUI") .. " to new colorful " .. TXUI.Title ..
                " icons.\n\n"
        }, I.Requirements.RoleIcons)

        -- Enable
        roleIconGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " Role Icons.",
            name = function()
                return self:GetEnableName(E.db.TXUI.elvUIIcons.roleIcons.enabled, roleIconGroup)
            end
        }

        -- Hidden helper
        local roleIconDisabled = function()
            return self:GetEnabledState(E.db.TXUI.elvUIIcons.roleIcons.enabled, roleIconGroup) ~= self.enabledState.YES
        end

        -- Theme
        roleIconGroup["args"]["theme"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Style",
            desc = "Change the icons",
            values = { ["TXUI"] = TXUI.Title .. " Colored", ["TXUI_WHITE"] = TXUI.Title .. " White" },
            hidden = roleIconDisabled
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- Dead Icons
    do
        -- Dead Icon Group
        local deadIconGroup = self:AddInlineRequirementsDesc(options, {
            name = "Dead Icon",
            get = function(info)
                return E.db.TXUI.elvUIIcons.deadIcons[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.elvUIIcons.deadIcons[info[#info]] = value
                TXUI:GetModule("DeadIcons"):ProfileUpdate()
            end
        },
                                                             {
            name = "Adds a 'Dead' indicator to " .. F.StringElvUI("ElvUI") .. " with " .. TXUI.Title .. " icons.\n\n"
        }, I.Requirements.RoleIcons)

        -- Enable
        deadIconGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " 'Dead' icon.",
            name = function()
                return self:GetEnableName(E.db.TXUI.elvUIIcons.deadIcons.enabled, deadIconGroup)
            end
        }

        -- Hidden helper
        local deadIconDisabled = function()
            return self:GetEnabledState(E.db.TXUI.elvUIIcons.deadIcons.enabled, deadIconGroup) ~= self.enabledState.YES
        end

        -- Theme
        deadIconGroup["args"]["theme"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Style",
            desc = "Change the icon",
            values = { ["TXUI"] = TXUI.Title, ["BLIZZARD"] = "Blizzard" },
            hidden = deadIconDisabled
        }

        -- Size
        deadIconGroup["args"]["size"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Size",
            desc = "Set the icon size.",
            min = 1,
            max = 100,
            step = 1,
            hidden = deadIconDisabled
        }

        -- Position X
        deadIconGroup["args"]["xOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "X Offset",
            min = -300,
            max = 300,
            step = 1,
            hidden = deadIconDisabled
        }

        -- Position Y
        deadIconGroup["args"]["yOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Y Offset",
            min = -300,
            max = 300,
            step = 1,
            hidden = deadIconDisabled
        }
    end

    -- Spacer
    self:AddSpacer(options)

    -- Offline Icons
    do
        -- Offline Icon Group
        local offlineIconGroup = self:AddInlineRequirementsDesc(options, {
            name = "Offline Icon",
            get = function(info)
                return E.db.TXUI.elvUIIcons.offlineIcons[info[#info]]
            end,
            set = function(info, value)
                E.db.TXUI.elvUIIcons.offlineIcons[info[#info]] = value
                TXUI:GetModule("OfflineIcons"):ProfileUpdate()
            end
        }, {
            name = "Adds a 'Offline' indicator to " .. F.StringElvUI("ElvUI") .. " with " .. TXUI.Title .. " icons.\n\n"
        }, I.Requirements.RoleIcons)

        -- Enable
        offlineIconGroup["args"]["enabled"] = {
            order = self:GetOrder(),
            type = "toggle",
            desc = "Toggling this on enables the " .. TXUI.Title .. " 'Offline' icon.",
            name = function()
                return self:GetEnableName(E.db.TXUI.elvUIIcons.offlineIcons.enabled, offlineIconGroup)
            end
        }

        -- Hidden helper
        local offlineIconDisabled = function()
            return self:GetEnabledState(E.db.TXUI.elvUIIcons.offlineIcons.enabled, offlineIconGroup) ~=
                       self.enabledState.YES
        end

        -- Theme
        offlineIconGroup["args"]["theme"] = {
            order = self:GetOrder(),
            type = "select",
            name = "Style",
            desc = "Change the icon",
            values = {
                ["TXUI"] = TXUI.Title,
                ["ALERT"] = "Blizzard - 'Alert'",
                ["ARTHAS"] = "Blizzard - 'Arthas'",
                ["PASS"] = "Blizzard - 'Pass'",
                ["NOTREADY"] = "Blizzard - 'Not Ready'"
            },
            hidden = offlineIconDisabled
        }

        -- Size
        offlineIconGroup["args"]["size"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Size",
            desc = "Set the icon size.",
            min = 1,
            max = 100,
            step = 1,
            hidden = offlineIconDisabled
        }

        -- Position X
        offlineIconGroup["args"]["xOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "X Offset",
            min = -300,
            max = 300,
            step = 1,
            hidden = offlineIconDisabled
        }

        -- Position Y
        offlineIconGroup["args"]["yOffset"] = {
            order = self:GetOrder(),
            type = "range",
            name = "Y Offset",
            min = -300,
            max = 300,
            step = 1,
            hidden = offlineIconDisabled
        }
    end
end

O:AddCallback("Plugins_ElvUIIcons")
