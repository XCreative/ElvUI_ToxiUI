local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local M = TXUI:GetModule("Misc")

local CreateFrame = CreateFrame

function M:WeakAuraAnchorLoad()
    local frame = CreateFrame("Frame", "ToxiUIWAAnchor", E.UIParent, "BackdropTemplate")
    frame:SetParent("ElvUF_Player")
    frame:Point("CENTER", E.UIParent, "CENTER", 0, -200)
    frame:SetFrameStrata("BACKGROUND")
    frame:Size(300, 100)

    E:CreateMover(frame, "ToxiUIWAAnchorMover", TXUI.Title .. " WA Anchor")
end

-- Created dummy WeakAura Anchor, for use by advanced users
function M:WeakAuraAnchor()
    -- Get Frameworks
    local uf = E:GetModule("UnitFrames")

    -- Enable!
    if (uf.unitstoload ~= nil) then
        self:SecureHook(uf, "LoadUnits", "WeakAuraAnchorLoad")
    else
        self:WeakAuraAnchorLoad()
    end
end

M:AddCallback("WeakAuraAnchor")