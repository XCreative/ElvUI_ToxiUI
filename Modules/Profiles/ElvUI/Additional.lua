local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

-- GLOBALS: MasqueDB

function PF:ElvUIAdditional()
    -- WindTools Config
    if F.IsAddOnEnabled("ElvUI_WindTools") then
        E.db["movers"]["WTMinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-238,-4"
        E.db["WT"]["announcement"]["goodbye"]["enable"] = false
        E.db["WT"]["announcement"]["interrupt"]["enable"] = false
        E.db["WT"]["announcement"]["thanks"]["enable"] = false
        E.db["WT"]["announcement"]["thanks"]["enhancement"] = false
        E.db["WT"]["announcement"]["thanks"]["resurrection"] = false
        E.db["WT"]["announcement"]["utility"]["enable"] = false
        E.db["WT"]["combat"]["combatAlert"]["enable"] = false
        E.db["WT"]["combat"]["raidMarkers"]["enable"] = true
        E.db["WT"]["combat"]["raidMarkers"]["backdropSpacing"] = 2
        E.db["WT"]["combat"]["raidMarkers"]["buttonSize"] = 24
        E.db["WT"]["combat"]["raidMarkers"]["countDownTime"] = 7
        E.db["WT"]["combat"]["raidMarkers"]["spacing"] = 8
        E.db["WT"]["combat"]["raidMarkers"]["visibility"] = "INPARTY"
        E.db["WT"]["item"]["contacts"]["enable"] = true
        E.db["WT"]["item"]["delete"]["fillIn"] = "AUTO"
        E.db["WT"]["item"]["extraItemsBar"]["enable"] = false
        E.db["WT"]["item"]["inspect"]["player"] = false
        E.db["WT"]["item"]["inspect"]["playerOnInspect"] = false
        E.db["WT"]["item"]["inspect"]["stats"] = false
        E.db["WT"]["maps"]["whoClicked"]["enable"] = false
        E.db["WT"]["misc"]["gameBar"]["enable"] = false
        E.db["WT"]["quest"]["switchButtons"]["enable"] = false
        E.db["WT"]["quest"]["turnIn"]["enable"] = false
        E.db["WT"]["social"]["chatBar"]["enable"] = false
        E.db["WT"]["social"]["chatText"]["abbreviation"] = "NONE"
        E.db["WT"]["social"]["chatText"]["roleIconStyle"] = "BLIZZARD"
        E.db["WT"]["social"]["chatLink"]["enable"] = false
        E.db["WT"]["social"]["emote"]["enable"] = false
        E.db["WT"]["social"]["friendList"]["textures"]["status"] = "Default"
        E.db["WT"]["social"]["smartTab"]["enable"] = false
    end
end

function PF:ElvUIAdditionalPrivate()
    -- WindTools Config
    if F.IsAddOnEnabled("ElvUI_WindTools") then
        E.private["WT"]["maps"]["instanceDifficulty"]["enable"] = true
        E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 2
        E.private["WT"]["maps"]["minimapButtons"]["buttonSize"] = 25
        E.private["WT"]["maps"]["minimapButtons"]["buttonsPerRow"] = 2
        E.private["WT"]["maps"]["minimapButtons"]["mouseOver"] = true
        E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 5
        E.private["WT"]["maps"]["superTracker"]["enable"] = false
        E.private["WT"]["maps"]["worldMap"]["enable"] = false
        E.private["WT"]["maps"]["worldMap"]["scale"]["enable"] = false
        E.private["WT"]["misc"]["moveBlizzardFrames"] = true
        E.private["WT"]["quest"]["objectiveTracker"]["header"]["name"] = "- Big Noodle Titling"
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorHighlight"]["b"] = 0.41960784313725
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorHighlight"]["g"] = 0.82745098039216
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorHighlight"]["r"] = 1
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorNormal"]["b"] = 0.1921568627451
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorNormal"]["g"] = 0.78039215686275
        E.private["WT"]["quest"]["objectiveTracker"]["titleColor"]["customColorNormal"]["r"] = 1
        E.private["WT"]["skins"]["elvui"]["enable"] = false
        E.private["WT"]["skins"]["blizzard"]["enable"] = false
        E.private["WT"]["skins"]["addons"]["weakAuras"] = false
        E.private["WT"]["skins"]["errorMessage"]["size"] = 20
        E.private["WT"]["skins"]["removeParchment"] = false
        E.private["WT"]["skins"]["shadow"] = false
        E.private["WT"]["unitFrames"]["quickFocus"]["enable"] = false
        E.private["WT"]["unitFrames"]["roleIcon"]["enable"] = false
    end
end
