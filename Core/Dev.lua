local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local SetCVar = SetCVar

function TXUI:SetupDevConfigs()
    if (not self.DevRelease) or (not F.IsTXUIProfile()) then return end

    -- Enable Script Errors
    SetCVar("scriptErrors", 1)

    -- Set taint errors to be enabled
    E.db.general.taintLog = true
end
