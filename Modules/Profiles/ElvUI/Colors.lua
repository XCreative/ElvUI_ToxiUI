local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local pairs = pairs
local ipairs = ipairs
local find = string.find
local gsub = string.gsub

local function addNameColors(darkMode, unit)
    local customText = E.db["unitframe"]["units"][unit]["customTexts"]

    for name, options in pairs(customText) do
        if (name == "!Health" or name == "!Name") and options["text_format"] then
            if darkMode and (not find(options["text_format"], "%[namecolor%]")) then
                options["text_format"] = "[namecolor]" .. options["text_format"]
            elseif (not darkMode) and find(options["text_format"], "%[namecolor%]") then
                options["text_format"] = gsub(options["text_format"], "%[namecolor%]", "")
            end
        end
    end
end

function PF:ElvUIColors()
    local darkMode = E.db.TXUI.themes.darkMode.enabled and TXUI:HasRequirements(I.Requirements.DarkMode)
    local nameColorUnits = { "arena", "focus", "player", "party", "raid", "raid40", "target", "targettarget" }

    for _, unit in ipairs(nameColorUnits) do addNameColors(darkMode, unit) end

    if darkMode then
        E.db["unitframe"]["colors"]["customhealthbackdrop"] = true
        E.db["unitframe"]["colors"]["health_backdrop"]["b"] = 0.31372549019608
        E.db["unitframe"]["colors"]["health_backdrop"]["g"] = 0.31372549019608
        E.db["unitframe"]["colors"]["health_backdrop"]["r"] = 0.31372549019608
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["b"] = 0
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["g"] = 0.047058823529412
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["r"] = 0.61176470588235
        E.db["unitframe"]["colors"]["health"]["b"] = 0.11372549019608
        E.db["unitframe"]["colors"]["health"]["g"] = 0.11372549019608
        E.db["unitframe"]["colors"]["health"]["r"] = 0.11372549019608
        E.db["unitframe"]["colors"]["healthclass"] = false
        E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["arena"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["arena"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["yOffset"] = 25
        E.db["unitframe"]["units"]["boss"]["customTexts"]["!Name"]["yOffset"] = 25
        E.db["unitframe"]["units"]["focus"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["focus"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["target"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["pet"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["pet"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["targettarget"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["player"]["height"] = 40
        E.db["unitframe"]["units"]["pet"]["height"] = 20
        E.db["unitframe"]["units"]["target"]["height"] = 40
        E.db["unitframe"]["units"]["targettarget"]["height"] = 20
        E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 18
    else
        E.db["unitframe"]["colors"]["customhealthbackdrop"] = false
        E.db["unitframe"]["colors"]["health_backdrop"]["b"] = 0.2078431372549
        E.db["unitframe"]["colors"]["health_backdrop"]["g"] = 0.1921568627451
        E.db["unitframe"]["colors"]["health_backdrop"]["r"] = 0.29411764705882
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["b"] = 0
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["g"] = 0
        E.db["unitframe"]["colors"]["health_backdrop_dead"]["r"] = 0
        E.db["unitframe"]["colors"]["health"]["b"] = 0.1
        E.db["unitframe"]["colors"]["health"]["g"] = 0.1
        E.db["unitframe"]["colors"]["health"]["r"] = 0.1
        E.db["unitframe"]["colors"]["healthclass"] = true
        E.db["unitframe"]["units"]["player"]["customTexts"]["!Health"]["yOffset"] = 27
        E.db["unitframe"]["units"]["player"]["customTexts"]["!Name"]["yOffset"] = 27
        E.db["unitframe"]["units"]["arena"]["customTexts"]["!Health"]["yOffset"] = 27
        E.db["unitframe"]["units"]["arena"]["customTexts"]["!Name"]["yOffset"] = 27
        E.db["unitframe"]["units"]["boss"]["customTexts"]["!Health"]["yOffset"] = 25
        E.db["unitframe"]["units"]["boss"]["customTexts"]["!Name"]["yOffset"] = 25
        E.db["unitframe"]["units"]["focus"]["customTexts"]["!Health"]["yOffset"] = 25
        E.db["unitframe"]["units"]["focus"]["customTexts"]["!Name"]["yOffset"] = 25
        E.db["unitframe"]["units"]["target"]["customTexts"]["!Health"]["yOffset"] = 27
        E.db["unitframe"]["units"]["target"]["customTexts"]["!Name"]["yOffset"] = 27
        E.db["unitframe"]["units"]["pet"]["customTexts"]["!Health"]["yOffset"] = 15
        E.db["unitframe"]["units"]["pet"]["customTexts"]["!Name"]["yOffset"] = 15
        E.db["unitframe"]["units"]["targettarget"]["customTexts"]["!Name"]["yOffset"] = 15
        E.db["unitframe"]["units"]["player"]["height"] = 30
        E.db["unitframe"]["units"]["pet"]["height"] = 15
        E.db["unitframe"]["units"]["target"]["height"] = 30
        E.db["unitframe"]["units"]["targettarget"]["height"] = 15
        E.db["unitframe"]["units"]["player"]["RestIcon"]["yOffset"] = 40
    end
end
