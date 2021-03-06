local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local PR = WB:NewModule("Profession")
local DT = E:GetModule("DataTexts")

local _G = _G
local C_TradeSkillUI = C_TradeSkillUI
local CreateFrame = CreateFrame
local format = string.format
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local next = next
local select = select
local tinsert = table.insert

function PR:OnEvent()
    self:OnWunderBarUpdate()
end

function PR:OnEnter(frame)
    if frame and frame.prof and frame:IsShown() then
        if frame.prof == "prof1" then
            self:ProfessionEnter(self.prof1Text, self.prof1Icon, self.prof1Bar)
        elseif frame.prof == "prof2" then
            self:ProfessionEnter(self.prof2Text, self.prof2Icon, self.prof2Bar)
        end
    end
end

function PR:OnLeave(frame)
    if frame and frame.prof and frame:IsShown() then
        if frame.prof == "prof1" then
            self:ProfessionLeave(self.prof1Text, self.prof1Icon, self.prof1Bar)
        elseif frame.prof == "prof2" then
            self:ProfessionLeave(self.prof2Text, self.prof2Icon, self.prof2Bar)
        end
    end
end

function PR:OnClick(frame, button)
    if frame and frame.prof and frame:IsShown() then
        if button == "RightButton" then
            self:ShowEasyMenu(frame)
        else
            if frame.prof == "prof1" then
                self:ProfessionClick(self.prof1)
            elseif frame.prof == "prof2" then
                self:ProfessionClick(self.prof2)
            end
        end
    end
end

function PR:ProfessionEnter(text, icon, bar)
    WB:SetFontAccentColor(text)
    WB:SetFontAccentColor(icon)

    WB:SetAccentColorFunc(bar, "statusbar")
    WB:SetAccentColorFunc(bar.background, "vertex", 0.33)

    self:ProfessionTooltip()
end

function PR:ProfessionLeave(text, icon, bar)
    WB:SetFontNormalColor(text)
    WB:SetFontIconColor(icon)

    WB:SetNormalColorFunc(bar, "statusbar")
    WB:SetNormalColorFunc(bar.background, "vertex", 0.33)
end

function PR:ShowEasyMenu(frame)
    local menuList = {}

    for index, _ in next, self.others do
        local profId = self.others[index]
        local skillLine, name, _, _, icon = self:GetProfessionInfo(profId)

        if skillLine then
            local menuEntry = {}

            menuEntry.notCheckable = true
            menuEntry.text = format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t ", icon) .. name
            menuEntry.func = function()
                self:ProfessionClick(profId)
            end

            tinsert(menuList, menuEntry)
        end
    end

    DT:SetEasyMenuAnchor(DT.EasyMenu, frame)
    _G.EasyMenu(menuList, DT.EasyMenu, nil, nil, nil, "MENU")
end

function PR:ProfessionClick(prof)
    local skillLine = self:GetProfessionInfo(prof)

    if select(6, C_TradeSkillUI.GetTradeSkillLine()) == skillLine then
        C_TradeSkillUI.CloseTradeSkill()
        return
    end

    C_TradeSkillUI.OpenTradeSkill(skillLine)
end

function PR:ProfessionTooltip()
    DT.tooltip:AddLine("Professions")
    DT.tooltip:AddLine(" ")

    for index, _ in next, self.others do
        local skillLine, name, rank, maxRank, icon = self:GetProfessionInfo(self.others[index])

        if skillLine then
            local texture = format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t ", icon)
            local r, g, b = F.SlowColorGradient(rank / maxRank, 1, .1, .1, 1, 1, .1, .1, 1, .1)
            DT.tooltip:AddDoubleLine(texture .. name, rank .. "/" .. maxRank, 1, 1, 1, r, g, b)
        end
    end

    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Toggle Profession Window")
    DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Show all Professions")
    DT.tooltip:Show()
end

function PR:OnWunderBarUpdate()
    self:UpdateProfession()
    self:UpdateColors()
    self:UpdateElements()
    self:UpdatePosition()
end

function PR:GetProfessionInfo(prof)
    local name, icon, rank, maxRank, skillLine

    if (prof) then
        name, icon, rank, maxRank = GetProfessionInfo(prof)
        skillLine = select(7, GetProfessionInfo(prof))
    end

    return skillLine, name, rank, maxRank, icon
end

function PR:UpdateProfession()
    local prof1, prof2, archaeology, fishing, cooking = GetProfessions()

    self.prof1 = nil
    self.prof2 = nil
    self.others = {}

    -- Prof1
    if (self.db.general.selectedProf1 == 1) then
        self.prof1 = prof1
    elseif (self.db.general.selectedProf1 ~= 0) then
        local skillLineLearned = self:GetProfessionInfo(self.db.general.selectedProf1)

        if (skillLineLearned) then
            self.prof1 = self.db.general.selectedProf1
        else
            self.prof1 = prof1
        end
    end

    -- Prof2
    if (self.db.general.selectedProf2 == 1) then
        self.prof2 = prof2
    elseif (self.db.general.selectedProf2 ~= 0) then
        local skillLineLearned = self:GetProfessionInfo(self.db.general.selectedProf2)

        if (skillLineLearned) then
            self.prof2 = self.db.general.selectedProf2
        else
            self.prof2 = prof2
        end
    end

    -- Set Prof2 as Prof1 when Prof1 was not found
    if (not self.prof1 and self.prof2) then
        self.prof1 = prof2
        self.prof2 = nil
    end

    self.others = { prof1, prof2, cooking, fishing, archaeology }
end

function PR:UpdatePosition()
    if (not self.prof1 and not self.prof2) then return end

    local anchorPoint = WB:GetGrowDirection(self.Module, true)
    local maxWidth = WB:GetMaxWidth(self.Module)
    local iconSize = self.db.general.showIcons and self.db.general.iconFontSize or 0.01
    local barOffset = self.db.general.showBars and (-self.db.general.barSpacing + self.db.general.barOffset) or 0
    local barTextOffset = self.db.general.showBars and
                              (self.db.general.barSpacing + self.db.general.barOffset + self.db.general.barHeight) or 0

    local iconOffset = 3
    local iconPadding = 5
    local iconSpace = iconSize + (iconPadding * 2)

    local showBoth = ((self.prof1 and self.prof2) and (not self.forceHideProf2))
    local primaryFrame = showBoth and self.prof1Frame or self.prof2Frame
    local primaryText = showBoth and self.prof1Text or self.prof2Text
    local primaryIcon = showBoth and self.prof1Icon or self.prof2Icon
    local primaryBar = showBoth and self.prof1Bar or self.prof2Bar
    local secondaryFrame = showBoth and self.prof2Frame or self.prof1Frame
    local secondaryText = showBoth and self.prof2Text or self.prof1Text
    local secondaryIcon = showBoth and self.prof2Icon or self.prof1Icon
    local secondaryBar = showBoth and self.prof2Bar or self.prof1Bar

    primaryFrame:ClearAllPoints()
    secondaryFrame:ClearAllPoints()

    primaryText:ClearAllPoints()
    secondaryText:ClearAllPoints()

    primaryIcon:ClearAllPoints()
    secondaryIcon:ClearAllPoints()

    primaryBar:ClearAllPoints()
    secondaryBar:ClearAllPoints()

    primaryIcon:SetJustifyH("RIGHT")
    secondaryText:SetJustifyH("RIGHT")

    primaryBar:SetSize(primaryText:GetStringWidth(), self.db.general.barHeight)
    secondaryBar:SetSize(secondaryText:GetStringWidth(), self.db.general.barHeight)

    local primaryOffset, secondaryOffset, primaryFrameOffset, secondaryFrameOffset = 0, 0, 0, 0

    if showBoth then
        if anchorPoint == "RIGHT" then
            primaryOffset = -(secondaryText:GetStringWidth() + iconSize + (iconPadding * 4))
            primaryFrameOffset = primaryOffset
        else
            primaryOffset = iconSpace
            secondaryOffset = (primaryText:GetStringWidth() + (iconSpace * 2) + (iconPadding * 2))
            secondaryFrameOffset = (primaryText:GetStringWidth() + iconSpace + (iconPadding * 2))
        end
    else
        if anchorPoint == "LEFT" then secondaryOffset = iconSpace end
    end

    primaryText:SetJustifyH(anchorPoint)
    secondaryText:SetJustifyH(anchorPoint)

    primaryFrame:SetSize(primaryText:GetStringWidth() + iconSpace, self.frame:GetHeight())
    secondaryFrame:SetSize(secondaryText:GetStringWidth() + iconSpace, self.frame:GetHeight())

    primaryFrame:SetPoint(anchorPoint, self.frame, anchorPoint, primaryFrameOffset, 0)
    primaryText:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, barTextOffset)
    primaryBar:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, barOffset)

    secondaryFrame:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryFrameOffset, 0)
    secondaryText:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, barTextOffset)
    secondaryBar:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, barOffset)

    primaryIcon:Point("RIGHT", primaryText, "LEFT", -iconPadding, iconOffset - barTextOffset)
    secondaryIcon:Point("RIGHT", secondaryText, "LEFT", -iconPadding, iconOffset - barTextOffset)

    if (not self.forceHideProf2) and (self.prof1 and self.prof2) then
        local totalWidth = (primaryText:GetStringWidth() + iconSpace)
        totalWidth = totalWidth + (secondaryText:GetStringWidth() + iconSpace)

        if totalWidth > maxWidth then
            self.forceHideProf2 = true
            secondaryFrame:Hide()
            self:UpdatePosition()
        end
    end
end

function PR:UpdateElement(prof, frame, icon, text, bar)
    local skillLine, name, rank, maxRank = self:GetProfessionInfo(prof)

    if (skillLine) then
        frame:Show()
        text:SetText(self.db.general.useUppercase and F.Uppercase(name) or name)

        if self.db.general.showIcons then
            icon:Show()
            icon:SetText(self.db.icons[skillLine])
        else
            icon:Hide()
        end

        if self.db.general.showBars then
            bar:Show()
            bar:SetMinMaxValues(0, maxRank)
            bar:SetValue(rank)
        else
            bar:Hide()
        end
    else
        frame:Hide()
    end
end

function PR:UpdateElements()
    self:UpdateElement(self.prof1, self.prof1Frame, self.prof1Icon, self.prof1Text, self.prof1Bar)
    self:UpdateElement(self.prof2, self.prof2Frame, self.prof2Icon, self.prof2Text, self.prof2Bar)
    self.forceHideProf2 = false
end

function PR:UpdateColors()
    WB:SetFontFromDB(nil, nil, self.prof1Text)
    WB:SetFontFromDB(nil, nil, self.prof2Text)

    WB:SetIconFromDB(self.db.general, "icon", self.prof1Icon)
    WB:SetIconFromDB(self.db.general, "icon", self.prof2Icon)

    local fontColor = WB:GetFontNormalColor()
    self.prof1Bar:SetStatusBarColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
    self.prof2Bar:SetStatusBarColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
    self.prof1Bar.background:SetColorTexture(fontColor.r, fontColor.g, fontColor.b, fontColor.a * 0.35)
    self.prof2Bar.background:SetColorTexture(fontColor.r, fontColor.g, fontColor.b, fontColor.a * 0.35)
end

function PR:CreateProfessions()

    -- Frames
    local prof1Frame = CreateFrame("BUTTON", nil, self.frame)
    local prof2Frame = CreateFrame("BUTTON", nil, self.frame)
    prof1Frame.prof = "prof1"
    prof2Frame.prof = "prof2"

    prof1Frame:Point("CENTER")
    prof2Frame:Point("CENTER")

    local onEnter = function(...)
        WB:ModuleOnEnter(self, ...)
    end

    local onLeave = function(...)
        WB:ModuleOnLeave(self, ...)
    end

    local onClick = function(...)
        WB:ModuleOnClick(self, ...)
    end

    prof1Frame:SetScript("OnEnter", onEnter)
    prof2Frame:SetScript("OnEnter", onEnter)

    prof1Frame:SetScript("OnLeave", onLeave)
    prof2Frame:SetScript("OnLeave", onLeave)

    prof1Frame:RegisterForClicks("AnyUp")
    prof2Frame:RegisterForClicks("AnyUp")

    prof1Frame:SetScript("OnClick", onClick)
    prof2Frame:SetScript("OnClick", onClick)

    self.prof1Frame = prof1Frame
    self.prof2Frame = prof2Frame

    -- Font Strings
    local prof1Text = prof1Frame:CreateFontString(nil, "OVERLAY")
    local prof1Icon = prof1Frame:CreateFontString(nil, "OVERLAY")
    local prof2Text = prof2Frame:CreateFontString(nil, "OVERLAY")
    local prof2Icon = prof2Frame:CreateFontString(nil, "OVERLAY")

    prof1Text:Point("CENTER")
    prof1Icon:Point("CENTER")
    prof2Text:Point("CENTER")
    prof2Icon:Point("CENTER")

    self.prof1Text = prof1Text
    self.prof1Icon = prof1Icon
    self.prof2Text = prof2Text
    self.prof2Icon = prof2Icon

    -- Bars
    local prof1Bar = CreateFrame("STATUSBAR", nil, prof1Frame)
    local prof2Bar = CreateFrame("STATUSBAR", nil, prof2Frame)

    prof1Bar:SetStatusBarTexture(1, 1, 1)
    prof2Bar:SetStatusBarTexture(1, 1, 1)

    prof1Bar.background = prof1Bar:CreateTexture(nil, "BACKGROUND")
    prof2Bar.background = prof2Bar:CreateTexture(nil, "BACKGROUND")

    prof1Bar.background:SetAllPoints()
    prof2Bar.background:SetAllPoints()

    self.prof1Bar = prof1Bar
    self.prof2Bar = prof2Bar
end

function PR:OnInit()
    -- Get our settings DB
    self.db = WB:GetSubModuleDB(self:GetName())

    -- Reuqest to extend
    WB:RequestToExtend(self.Module)

    -- Don't init second time
    if self.Initialized then return end

    -- Vars
    self.frame = self.SubModuleHolder
    self.prof1 = nil
    self.prof2 = nil
    self.others = {}

    self:CreateProfessions()
    self:OnWunderBarUpdate()

    -- We are done, hooray!
    self.Initialized = true
end

WB:RegisterSubModule(PR, { "TRADE_SKILL_NAME_UPDATE", "SKILL_LINES_CHANGED", "TRIAL_STATUS_UPDATE" })
