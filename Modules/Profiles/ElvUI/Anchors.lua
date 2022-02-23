local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local pairs = pairs

function PF:ElvUIAnchors()

    -- Define anchored frames
    local anchorFrames = {
        ["ElvUF_PetMover"] = {
            ["anchor"] = "ElvUF_PlayerMover",
            ["unitFrame"] = "pet",
            ["direction"] = "LEFT",
            ["padding"] = 2
        },

        ["ElvUF_TargetTargetMover"] = {
            ["anchor"] = "ElvUF_TargetMover",
            ["unitFrame"] = "targettarget",
            ["direction"] = "RIGHT",
            ["padding"] = 2
        }
    }

    -- Calculate anchored frame positions
    for frame, data in pairs(anchorFrames) do F.CalculatedAnchoredPositions(frame, data) end
end
