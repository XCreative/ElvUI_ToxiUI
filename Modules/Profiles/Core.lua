local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:NewModule("Profiles", "AceHook-3.0")

--[[ Initialization ]] --
function PF:Initialize()
    -- Don't init second time
    if self.Initialized then return end

    -- We actually don't need todo anything, everything is handled by the installer

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(PF:GetName())
