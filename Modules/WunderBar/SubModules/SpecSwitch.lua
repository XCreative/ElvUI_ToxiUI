local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local SS = WB:NewModule("SpecSwitch")
local DT = E:GetModule("DataTexts")

local CreateFrame = CreateFrame
local GetLootSpecialization = GetLootSpecialization
local GetSpecialization = GetSpecialization

function SS:OnEvent()
    self:OnWunderBarUpdate()
end

function SS:OnClick(...)
    local dtModule = WB:GetElvUIDataText("Talent/Loot Specialization")

    if dtModule then
        dtModule.eventFunc(WB:GetElvUIDummy(), "PLAYER_LOOT_SPEC_UPDATED")
        dtModule.onClick(...)
    end
end

function SS:OnEnter()
    WB:SetFontAccentColor(self.spec1Text)
    WB:SetFontAccentColor(self.spec1Icon)

    if self.spec2Frame:IsShown() then
        WB:SetFontAccentColor(self.spec2Text)
        WB:SetFontAccentColor(self.spec2Icon)
    end

    local dtModule = WB:GetElvUIDataText("Talent/Loot Specialization")

    if dtModule then
        dtModule.eventFunc(WB:GetElvUIDummy(), "PLAYER_LOOT_SPEC_UPDATED")
        dtModule.onEnter()
    end
end

function SS:OnLeave()
    WB:SetFontIconColor(self.spec1Icon)
    WB:SetFontNormalColor(self.spec1Text)

    if self.spec2Frame:IsShown() then
        WB:SetFontNormalColor(self.spec2Text)
        WB:SetFontIconColor(self.spec2Icon)
    end
end

function SS:OnWunderBarUpdate()
    self:UpdateSpecialization()
    self:UpdateSwitch()
    self:UpdateElements()
    self:UpdatePosition()
    self:UpdateInfoText()
end

function SS:UpdateSpecialization()
    local spec1, spec2 = GetSpecialization(), GetLootSpecialization()

    self.spec1 = nil
    self.spec2 = nil
    self.infoSpec = nil

    if (spec1 and self.db.general.showSpec1) then self.spec1 = spec1 end
    if (spec2 and self.db.general.showSpec2) then self.spec2 = (spec2 ~= 0) and spec2 or spec1 end

    if (not self.spec1 and self.spec2) then
        self.spec1 = (spec2 ~= 0) and spec2 or spec1
        self.spec2 = nil
    end

    if (self.spec1 == spec1) then
        self.infoSpec = (spec2 ~= 0) and spec2 or nil
    else
        self.infoSpec = spec1
    end
end

function SS:UpdatePosition()
    local anchorPoint = WB:GetGrowDirection(self.Module, true)
    local maxWidth = WB:GetMaxWidth(self.Module)
    local iconSize = self.db.general.showIcons and self.db.general.iconFontSize or 0.01

    local iconOffset = 3
    local iconPadding = 5
    local iconSpace = iconSize + (iconPadding * 2)

    local showBoth = (self.spec1 and self.spec2)
    local primaryText = showBoth and self.spec1Text or self.spec2Text
    local primaryIcon = showBoth and self.spec1Icon or self.spec2Icon
    local secondaryText = showBoth and self.spec2Text or self.spec1Text
    local secondaryIcon = showBoth and self.spec2Icon or self.spec1Icon

    primaryText:ClearAllPoints()
    secondaryText:ClearAllPoints()

    primaryIcon:ClearAllPoints()
    secondaryIcon:ClearAllPoints()

    primaryIcon:SetJustifyH("RIGHT")
    secondaryText:SetJustifyH("RIGHT")

    local primaryOffset, secondaryOffset = 0, 0

    if (not self.forceHideSpec2) and showBoth then
        if anchorPoint == "RIGHT" then
            primaryOffset = -(secondaryText:GetStringWidth() + iconSize + (iconPadding * 4))
        else
            primaryOffset = iconSpace
            secondaryOffset = (primaryText:GetStringWidth() + (iconSpace * 2) + (iconPadding * 2))
        end
    else
        if anchorPoint == "LEFT" then secondaryOffset = iconSpace end
    end

    primaryText:SetJustifyH(anchorPoint)
    secondaryText:SetJustifyH(anchorPoint)

    primaryText:SetPoint(anchorPoint, self.frame, anchorPoint, primaryOffset, 0)
    secondaryText:SetPoint(anchorPoint, self.frame, anchorPoint, secondaryOffset, 0)

    primaryIcon:Point("RIGHT", primaryText, "LEFT", -iconPadding, iconOffset - 0)
    secondaryIcon:Point("RIGHT", secondaryText, "LEFT", -iconPadding, iconOffset - 0)

    self.infoText:ClearAllPoints()
    self.infoText:SetPoint("CENTER", secondaryText, "CENTER", 0, self.db.general.infoOffset)

    if (not self.forceHideSpec2) and showBoth then
        local totalWidth = (primaryText:GetStringWidth() + iconSpace)
        totalWidth = totalWidth + (secondaryText:GetStringWidth() + iconSpace)

        if totalWidth > maxWidth then
            self.forceHideSpec2 = true
            self.spec2Frame:Hide()
            self:UpdatePosition()
        end
    end
end

function SS:UpdateInfoText()
    if (self.db.general.infoEnabled and not (self.db.general.showSpec1 and self.db.general.showSpec2) and self.infoSpec) then
        if (self.db.general.infoShowIcon and not self.db.general.showSpec2) then
            WB:SetFontFromDB(self.db.general, "info", self.infoText, false, false, WB.db.general.iconFont)

            if (not self.db.general.infoUseAccent) then
                WB:SetFontIconColor(self.infoText)
            else
                WB:SetFontAccentColor(self.infoText)
            end

            self.infoText:SetText(self.db.general.infoIcon)
        else
            local info = DT.SPECIALIZATION_CACHE[self.infoSpec]

            if (info and info.name) then
                WB:SetFontFromDB(self.db.general, "info", self.infoText, true, self.db.general.infoUseAccent)
                self.infoText:SetText(self.db.general.useUppercase and F.Uppercase(info.name) or info.name)
            end
        end
    else
        WB:SetFontFromDB(self.db.general, "info", self.infoText, true, self.db.general.infoUseAccent)
        self.infoText:SetText("")
    end
end

function SS:UpdateElement(spec, frame, icon, text)
    local info = DT.SPECIALIZATION_CACHE[spec]

    if (info and info.name) then
        frame:Show()
        text:SetText(self.db.general.useUppercase and F.Uppercase(info.name) or info.name)

        if self.db.general.showIcons then
            icon:Show()
            icon:SetText(self.db.icons[info.id or spec])
        else
            icon:Hide()
        end
    else
        frame:Hide()
    end
end

function SS:UpdateElements()
    self:UpdateElement(self.spec1, self.spec1Frame, self.spec1Icon, self.spec1Text)
    self:UpdateElement(self.spec2, self.spec2Frame, self.spec2Icon, self.spec2Text)
    self.forceHideSpec2 = false
end

function SS:UpdateSwitch()
    WB:SetFontFromDB(self.db.general, "main", self.spec1Text)
    WB:SetFontFromDB(self.db.general, "main", self.spec2Text)

    WB:SetIconFromDB(self.db.general, "icon", self.spec1Icon)
    WB:SetIconFromDB(self.db.general, "icon", self.spec2Icon)
end

function SS:CreateSwitch()
    -- Frames
    local spec1Frame = CreateFrame("Frame", nil, self.frame)
    local spec2Frame = CreateFrame("Frame", nil, self.frame)

    spec1Frame:Point("CENTER")
    spec2Frame:Point("CENTER")

    self.spec1Frame = spec1Frame
    self.spec2Frame = spec2Frame

    -- Font Strings
    local spec1Text = spec1Frame:CreateFontString(nil, "OVERLAY")
    local spec1Icon = spec1Frame:CreateFontString(nil, "OVERLAY")
    local spec2Text = spec2Frame:CreateFontString(nil, "OVERLAY")
    local spec2Icon = spec2Frame:CreateFontString(nil, "OVERLAY")

    spec1Text:Point("CENTER")
    spec1Icon:Point("CENTER")
    spec2Text:Point("CENTER")
    spec2Icon:Point("CENTER")

    self.spec1Text = spec1Text
    self.spec1Icon = spec1Icon
    self.spec2Text = spec2Text
    self.spec2Icon = spec2Icon

    local infoText = spec1Frame:CreateFontString(nil, "OVERLAY")
    self.infoText = infoText
end

function SS:OnInit()
    -- Get our settings DB
    self.db = WB:GetSubModuleDB(self:GetName())

    -- Reuqest to extend
    WB:RequestToExtend(self.Module)

    -- Don't init second time
    if self.Initialized then return end

    -- Vars
    self.frame = self.SubModuleHolder
    self.spec1 = nil
    self.spec2 = nil
    self.infoSpec = nil
    self.forceHideSpec2 = false

    self:CreateSwitch()
    self:OnWunderBarUpdate()

    -- We are done, hooray!
    self.Initialized = true
end

WB:RegisterSubModule(SS, {
    "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_LOOT_SPEC_UPDATED"
})
