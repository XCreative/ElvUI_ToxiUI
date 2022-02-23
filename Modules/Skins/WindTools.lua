local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local S = TXUI:GetModule("Skins")
local LSM = E.Libs.LSM

local _G = _G
local format = string.format
local unpack = unpack

function S:ElvUI_WindTools_QueueTimer()
    local loader = _G.BigWigsLoader

    -- BW Core not found, return
    if not loader then return end

    -- Unregister WindTools skinning cause we do our own
    E:Delay(2, function()
        loader.UnregisterMessage("WindTools", "BigWigs_FrameCreated") -- trolololol
    end)

    -- And go
    loader.RegisterMessage("ToxiUI", "BigWigs_FrameCreated", function(_, frame, name)
        if name == "QueueTimer" then
            local parent = frame:GetParent()
            frame:StripTextures()
            frame:CreateBackdrop("Transparent")
            frame:SetStatusBarTexture(E.media.normTex)
            frame:SetStatusBarColor(unpack(TXUI.AddOnColorRGB))
            frame:Size(parent:GetWidth(), 10)
            frame:ClearAllPoints()
            frame:Point("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
            frame:Point("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -5)
            frame.text.SetFormattedText = function(text, _, time)
                text:SetText(format("%d", time))
            end
            frame.text:FontTemplate(LSM:Fetch("font", "- Big Noodle Titling"), 24, "OUTLINE")
            frame.text:ClearAllPoints()
            frame.text:Point("TOP", frame, "TOP", 0, -3)
        end
    end)
end

S:AddCallbackForEnterWorld("ElvUI_WindTools_QueueTimer")
