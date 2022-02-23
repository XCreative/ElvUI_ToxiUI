local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local S = TXUI:GetModule("Skins")

-- Globals
local _G = _G
local unpack = unpack

-- Vars
local AS

-- ZygorGuidesViewer
function S.AddOnSkins_Zyogr()
    local ZygorGuidesViewer = _G.ZygorGuidesViewer

    if AS:IsHooked(ZygorGuidesViewer, "UpdateFrame") then AS:Unhook(ZygorGuidesViewer, "UpdateFrame") end
    if AS:IsHooked(ZygorGuidesViewer.Pointer, "SetFontSize") then AS:Unhook(ZygorGuidesViewer, "SetFontSize") end

    AS:RawHook(ZygorGuidesViewer, "UpdateFrame", function(this, ...)
        local UpdateFrame = AS.hooks[this].UpdateFrame(this, ...)
        local frame = _G.ZygorGuidesViewerFrame

        -- GuideViewer
        frame:StripTextures()
        frame.Border.Back:StripTextures()
        frame.Border:CreateBackdrop("Transparent")

        return UpdateFrame
    end, true)

    AS:RawHook(ZygorGuidesViewer.Pointer, "SetFontSize", function(this)
        local arrow = this.ArrowFrame.title
        arrow:SetFont(AS.Font, ZygorGuidesViewer.db.profile.arrowfontsize, "OUTLINE")
        arrow:SetShadowColor(0, 0, 0, 0)
        arrow:SetShadowOffset(0, 0)
        arrow:SetTextColor(0.67, 0.67, 0.67)
        arrow:SetAlpha(0.8)
    end, true)
end

-- InFlight
function S.AddOnSkins_InFlight()
    local InFlight = _G.InFlight

    if AS:IsHooked(InFlight, "UpdateLook") then AS:Unhook(InFlight, "UpdateLook") end

    AS:SecureHook(InFlight, "UpdateLook", function(this)
        if not _G.InFlightBar then this:CreateBar() end
        local bar = _G.InFlightBar

        local backdrop = AS:FindChildFrameByPoint(bar, "Frame", "TOPLEFT", bar, "TOPLEFT", -5, 5)
        if backdrop then backdrop:Kill() end

        bar:CreateBackdrop("Transparent")
    end)
end

function S:AddOnSkins()
    -- Get Frameworks
    AS = unpack(_G.AddOnSkins)

    -- AddOnSkins not found?
    if (not AS) then return self:DebugPrint("Could not find AddOnSkins") end

    -- Zygor
    if AS:CheckAddOn("ZygorGuidesViewer") then
        local title = TXUI.Title .. ": Zygor"
        AS:RegisterSkin(title, S.AddOnSkins_Zyogr)
        if AS:CheckOption(title) then self:AddCallbackForAddon("ZygorGuidesViewer", S.AddOnSkins_Zyogr) end
    end

    -- InFlight
    if AS:CheckAddOn("InFlight_Load") then
        local title = TXUI.Title .. ": InFlight"
        AS:RegisterSkin(title, S.AddOnSkins_InFlight)
        if AS:CheckOption(title) then self:AddCallbackForAddon("InFlight", S.AddOnSkins_InFlight) end
    end
end

S:AddCallbackForAddon("AddOnSkins")
