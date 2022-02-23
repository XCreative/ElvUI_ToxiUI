local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local function calculateFontSize(size)
    return E.db.TXUI.addons.fontScale and (size + E.db.TXUI.addons.fontScale) or size
end

function PF:ElvUIFont()
    -- General
    E.db["general"]["font"] = I.General.DefaultFont
    E.db["general"]["fontStyle"] = I.General.DefaultFontOutline

    E.db["general"]["itemLevel"]["itemLevelFont"] = I.General.DefaultFont
    E.db["general"]["itemLevel"]["itemLevelFontOutline"] = I.General.DefaultFontOutline

    -- Misc
    E.db["tooltip"]["font"] = I.General.DefaultFont
    E.db["tooltip"]["I.General.DefaultFontOutline"] = I.General.DefaultFontOutline

    -- Chat
    E.db["chat"]["font"] = I.General.DefaultFont
    E.db["chat"]["I.General.DefaultFontOutline"] = I.General.DefaultFontOutline
    E.db["chat"]["tabFont"] = I.General.DefaultFont
    E.db["chat"]["tabFontOutline"] = I.General.DefaultFontOutline

    -- WT
    if F.IsAddOnEnabled("ElvUI_WindTools") then
        E.db["WT"]["social"]["friendList"]["infoFont"]["name"] = I.General.DefaultFont
        E.db["WT"]["social"]["friendList"]["infoFont"]["style"] = I.General.DefaultFontOutline

        E.db["WT"]["social"]["friendList"]["nameFont"]["name"] = I.General.DefaultFont
        E.db["WT"]["social"]["friendList"]["nameFont"]["style"] = I.General.DefaultFontOutline
    end
end

function PF:ElvUIFontPrivates()
    -- General
    E.private["general"]["chatBubbleFont"] = I.General.DefaultFont
    E.private["general"]["chatBubbleFontOutline"] = I.General.DefaultFontOutline

    -- Blizzard
    E.private["general"]["dmgfont"] = I.General.DefaultFont
    E.private["general"]["namefont"] = I.General.DefaultFont

    -- WT
    if F.IsAddOnEnabled("ElvUI_WindTools") then
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["name"] = I.General.DefaultFont
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["style"] = I.General.DefaultFontOutline

        E.private["WT"]["quest"]["objectiveTracker"]["info"]["name"] = I.General.DefaultFont
        E.private["WT"]["quest"]["objectiveTracker"]["info"]["style"] = I.General.DefaultFontOutline

        E.private["WT"]["quest"]["objectiveTracker"]["title"]["name"] = I.General.DefaultFont
        E.private["WT"]["quest"]["objectiveTracker"]["title"]["style"] = I.General.DefaultFontOutline
    end
end

function PF:ElvUIFontSize()
    -- General
    E.db["general"]["fontSize"] = calculateFontSize(15)

    -- Tooltip
    E.db["tooltip"]["headerFontSize"] = calculateFontSize(16)
    E.db["tooltip"]["smallTextFontSize"] = calculateFontSize(14)
    E.db["tooltip"]["textFontSize"] = calculateFontSize(14)

    -- WT
    if F.IsAddOnEnabled("ElvUI_WindTools") then
        E.db["WT"]["social"]["friendList"]["infoFont"]["size"] = calculateFontSize(13)
        E.db["WT"]["social"]["friendList"]["nameFont"]["size"] = calculateFontSize(14)
    end
end

function PF:ElvUIFontSizePrivates()
    -- WT
    if F.IsAddOnEnabled("ELVUI_WindTools") then
        E.private["WT"]["maps"]["instanceDifficulty"]["font"]["size"] = calculateFontSize(16)
        E.private["WT"]["quest"]["objectiveTracker"]["header"]["size"] = calculateFontSize(22)
        E.private["WT"]["quest"]["objectiveTracker"]["info"]["size"] = calculateFontSize(15)
        E.private["WT"]["quest"]["objectiveTracker"]["title"]["size"] = calculateFontSize(17)
    end
end

function PF:ApplyFontSizeChange(value)
    -- No update needed
    if E.db.TXUI.addons.fontScale == value then return end

    -- Set font db value
    E.db.TXUI.addons.fontScale = value

    -- Apply font change
    self:ElvUIFontSize()
    self:ElvUIFontSizePrivates()

    -- Update ElvUI
    E:UpdateMedia()
    E:StaggeredUpdateAll(nil, true)
end
