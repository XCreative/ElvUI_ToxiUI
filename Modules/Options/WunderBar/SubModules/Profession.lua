local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")
local ACH = LibStub("LibAceConfigHelper")

function O:WunderBar_SubModules_Profession()
    local dbEntry = "Profession"
    local options = self.options.wunderbar.args.submodules.args

    options.profession = ACH:Group("Profession", nil, self:GetOrder(), nil, function(info)
        return E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]]
    end, function(info, value)
        E.db.TXUI.wunderbar.subModules[dbEntry].general[info[#info]] = value
        TXUI:GetModule("WunderBar"):UpdateBar()
    end)

    local tab = options.profession.args
    local iconDisabled = function()
        return not E.db.TXUI.wunderbar.subModules[dbEntry].general.showIcons
    end

    -- General
    tab.generalGroup = ACH:Group("General", nil, 1)
    tab.generalGroup.inline = true

    tab.generalGroup.args.showIcons = ACH:Toggle("Show Icons", nil, 1)
    tab.generalGroup.args.iconFontSize = ACH:Range("Icon Size", nil, 2, { min = 1, max = 100, step = 1 }, nil, nil, nil,
                                                   iconDisabled)

    tab.generalGroup.args.spacer1 = ACH:Spacer(3)

    tab.generalGroup.args.useUppercase = ACH:Toggle("Uppercase Names", nil, 4)

    tab.generalGroup.args.spacer2 = ACH:Spacer(5)

    local professionValues = function(number)
        return function()
            local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
            local mainProfName

            if (number == 1) then
                mainProfName = prof1 and GetProfessionInfo(prof1) or "Profession " .. number
            else
                mainProfName = prof2 and GetProfessionInfo(prof2) or "Profession " .. number
            end

            local values = { [0] = "Hide", [1] = mainProfName }

            if (archaeology) then values[archaeology] = GetProfessionInfo(archaeology) end
            if (fishing) then values[fishing] = GetProfessionInfo(fishing) end
            if (cooking) then values[cooking] = GetProfessionInfo(cooking) end

            return values
        end
    end

    tab.generalGroup.args.selectedProf1 = ACH:Select("Profession 1", nil, 6, professionValues(1), nil, 2)
    tab.generalGroup.args.selectedProf2 = ACH:Select("Profession 2", nil, 7, professionValues(2), nil, 2)

    tab.barGroup = ACH:Group("Bars", nil, 2)
    tab.barGroup.inline = true

    local barsDisabled = function()
        return not E.db.TXUI.wunderbar.subModules[dbEntry].general.showBars
    end

    tab.barGroup.args.showBars = ACH:Toggle(function()
        return barsDisabled() and "Disabled" or "Enabled"
    end, nil, 1)

    tab.barGroup.args.barHeight = ACH:Range("Bar Height", nil, 2, { min = 1, max = 20, step = 1 }, nil, nil, nil,
                                            barsDisabled)

    tab.barGroup.args.barOffset = ACH:Range("Vertical Offset", nil, 3, { min = -10, max = 10, step = 1 }, nil, nil, nil,
                                            barsDisabled)

    tab.barGroup.args.barSpacing = ACH:Range("Vertical Spacing", nil, 4, { min = 0, max = 10, step = 1 }, nil, nil, nil,
                                             barsDisabled)
end
