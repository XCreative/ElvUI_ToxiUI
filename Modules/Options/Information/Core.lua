local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")

function O:Information()
    -- Reset order for new page
    self:ResetOrder()

    local options = self.options.information.args

    options["general"] = {
        name = "General", -- Install Info
        order = self:GetOrder(),
        type = "group",
        args = {}
    }

    options["changelog"] = {
        name = "Changelog", -- Changelog view
        order = self:GetOrder(),
        type = "group",
        childGroups = "select",
        args = {}
    }

    options["reset"] = {
        name = "Reset", -- Profile and module reset
        order = self:GetOrder(),
        type = "group",
        args = {},
        hidden = self.txUIDisabled
    }
end

O:AddCallback("Information")
