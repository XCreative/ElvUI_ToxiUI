local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

function PF:ElvUITextures()
    local texture = (E.db.TXUI.themes.gradientMode.enabled and TXUI:HasRequirements(I.Requirements.GradientMode)) and
                        "- Tx Mid" or "- ToxiUI"

    E.db["general"]["altPowerBar"]["statusBar"] = texture
    E.db["unitframe"]["statusbar"] = texture
    E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["texture"] = texture
end

function PF:ElvUITexturesPrivate()
    local texture = (E.db.TXUI.themes.gradientMode.enabled and TXUI:HasRequirements(I.Requirements.GradientMode)) and
                        "- Tx Mid" or "- ToxiUI"

    E.private["general"]["normTex"] = texture
end
