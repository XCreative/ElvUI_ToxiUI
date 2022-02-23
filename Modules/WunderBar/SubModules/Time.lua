local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local TI = WB:NewModule("Time")

local _G = _G
local date = date
local format = string.format
local FormatShortDate = FormatShortDate
local GetGameTime = GetGameTime
local HasNewMail = HasNewMail
local max = math.max
local tonumber = tonumber
local wipe = table.wipe

function TI:ConvertTime(hour, minute)
    -- Convert to weird format
    if (not self.db.twentyFour) then
        if (hour == 0) then
            hour = 12
        elseif (hour > 12) then
            hour = hour - 12
        end
    end

    -- format correctly
    if (self.db.timeFormat == "HH:MM") then
        return format("%02d", hour), format("%02d", minute)
    elseif (self.db.timeFormat == "H:MM") then
        return format("%d", hour), format("%02d", minute)
    elseif (self.db.timeFormat == "HH:M") then
        return format("%02d", hour), format("%d", minute)
    end

    return format("%d", hour), format("%d", minute)
end

function TI:GetTime()
    local hour, minute

    if (self.db.localTime) then
        hour, minute = tonumber(date("%H")), tonumber(date("%M"));
    else
        hour, minute = GetGameTime();
    end

    return self:ConvertTime(hour, minute)
end

function TI:OnUpdate(t)
    -- default to 5 or reduce time by time taken from the last OnUpdate call
    self.timeLastUpdate = (self.timeLastUpdate or 5) - t

    -- if time is still bigger than 0, skip update
    if self.timeLastUpdate > 0 then return end

    -- reset last update timer
    self.timeLastUpdate = 5

    -- flash if calendar has pending invite
    if self.db.flashOnInvite and (self.hasInvite ~= _G.GameTimeFrame.flashInvite) then
        self.hasInvite = _G.GameTimeFrame.flashInvite
        self:UpdateColor()
    end

    local hour, min = self:GetTime()

    self.colon:SetText(":")
    self.hour:SetText(hour)
    self.minutes:SetText(min)
end

function TI:OnClick(...)
    local dtModule = WB:GetElvUIDataText("Time")

    if dtModule then
        self:UpdateTooltip(dtModule)
        dtModule.onClick(...)
    end
end

function TI:OnEnter()
    WB:SetFontAccentColor(self.hour)
    WB:SetFontAccentColor(self.minutes)

    local dtModule = WB:GetElvUIDataText("Time")

    if dtModule then
        self:UpdateTooltip(dtModule)
        dtModule.onEnter()
    end
end

function TI:OnLeave()
    WB:SetFontColorFromDB(self.db, "main", self.hour)
    WB:SetFontColorFromDB(self.db, "main", self.minutes)

    local dtModule = WB:GetElvUIDataText("Time")
    if dtModule then dtModule.onLeave() end
end

function TI:OnEvent(event)
    if (event == "UPDATE_INSTANCE_INFO") then
        self:UpdateTooltip()
        return
    end

    if (event == "CALENDAR_EVENT_ALARM") then
        WB:FlashFontOnEvent(self.hour)
        WB:FlashFontOnEvent(self.minutes)
        return
    end

    if (event == "ELVUI_FORCE_UPDATE") or (event == "MAIL_INBOX_UPDATE") or (event == "UPDATE_PENDING_MAIL") or
        (event == "MAIL_CLOSED") or (event == "MAIL_SHOW") then
        if not self.db.infoTextDisplayed["mail"] then return end

        self:UpdateInfoText()

        local hasMail = HasNewMail()
        if self.hasMail ~= hasMail then
            self.hasMail = hasMail

            if hasMail then
                WB:FlashFontOnEvent(self.hour)
                WB:FlashFontOnEvent(self.minutes)
            end
        end

        return
    end
end

function TI:OnSizeCalculation()
    if not self.db.experimentalDynamicSize then return end

    local clockSize = self.colon:GetStringWidth() + E:Scale(5)
    clockSize = clockSize + self.hour:GetStringWidth()
    clockSize = clockSize + self.minutes:GetStringWidth()

    return (self.db.infoEnabled) and max(clockSize, self.infoText:GetStringWidth()) or clockSize
end

function TI:OnWunderBarUpdate()
    self:UpdateClock()
    self:UpdateColor()
    self:UpdateInfoText()
end

function TI:CycleInfoText(index)
    local category = self.activeInfoText[index]
    if category == "mail" then
        self.infoText:SetText(F.Uppercase("You've Got Mail!"))
    elseif category == "date" then
        local dateTime = date("*t")
        self.infoText:SetText(FormatShortDate(dateTime.day, dateTime.month, dateTime.year))
    elseif category == "ampm" then
        local dateTime = date("%p")
        self.infoText:SetText(F.Uppercase(dateTime))
    end

    self.infoText:Show()
end

function TI:UpdateInfoText()
    if not self.db.infoEnabled then
        self.infoText:Hide()
        WB:StopAnimations(self.infoText)
        return
    end

    wipe(self.activeInfoText)

    if self.db.infoTextDisplayed["date"] then table.insert(self.activeInfoText, "date") end
    if self.db.infoTextDisplayed["ampm"] then table.insert(self.activeInfoText, "ampm") end
    if self.db.infoTextDisplayed["mail"] and HasNewMail() then table.insert(self.activeInfoText, "mail") end

    if (#self.activeInfoText > 1) then
        if (not WB:IsTextTransitionPlaying(self.infoText)) then
            local cycleIndex = 0

            self:CycleInfoText(#self.activeInfoText)

            WB:StartTextTransition(self.infoText, 5, function(anim)
                if (anim.LoopCounter > #self.activeInfoText or cycleIndex == 0) then anim.LoopCounter = 1 end
                cycleIndex = anim.LoopCounter
                self:CycleInfoText(cycleIndex)
            end)
        end
    else
        WB:StopAnimations(self.infoText)
        self.infoText:SetAlpha(1)

        if (#self.activeInfoText == 0) then
            self.infoText:Hide()
        else
            self:CycleInfoText(1)
        end
    end
end

function TI:UpdateColor()
    if self.db.infoUseAccent then
        WB:SetFontAccentColor(self.infoText, false)
    else
        WB:SetFontNormalColor(self.infoText, false)
    end

    if self.db.flashColon then
        WB:StartColorFlash(self.colon, 1, WB:GetFontNormalColor(), WB:GetFontAccentColor())
    elseif (self.db.useAccent) then
        WB:SetFontAccentColor(self.colon)
    else
        WB:SetFontNormalColor(self.colon)
    end

    if self.db.flashOnInvite and self.hasInvite then
        WB:StartColorFlash(self.hour, 1, WB:GetFontNormalColor(), WB:GetFontAccentColor())
        WB:StartColorFlash(self.minutes, 1, WB:GetFontNormalColor(), WB:GetFontAccentColor())
        return
    end

    WB:SetFontNormalColor(self.hour)
    WB:SetFontNormalColor(self.minutes)
end

function TI:UpdateTooltip(dataText)
    local dtModule = dataText or WB:GetElvUIDataText("Time")
    if dtModule then dtModule.eventFunc(WB:GetElvUIDummy(), "UPDATE_INSTANCE_INFO") end
end

function TI:UpdateClock()
    WB:SetFontFromDB(self.db, "main", self.colon, false)
    WB:SetFontFromDB(self.db, "main", self.hour, false)
    WB:SetFontFromDB(self.db, "main", self.minutes, false)
    WB:SetFontFromDB(self.db, "info", self.infoText, false)

    self.colon:ClearAllPoints()
    self.colon:Point("CENTER", self.frame, "CENTER", 0, self.db.textOffset)

    self.infoText:ClearAllPoints()
    self.infoText:Point("CENTER", self.colon, "CENTER", 0, self.db.infoOffset)
end

function TI:CreateClock()
    local colon = self.frame:CreateFontString(nil, "ARTWORK")
    self.colon = colon

    local hour = self.frame:CreateFontString(nil, "ARTWORK")
    hour:Point("RIGHT", colon, "LEFT", -3, 0)
    hour:SetJustifyH("RIGHT")
    self.hour = hour

    local minutes = self.frame:CreateFontString(nil, "ARTWORK")
    minutes:Point("LEFT", colon, "RIGHT", 2, 0)
    minutes:SetJustifyH("LEFT")
    self.minutes = minutes

    local infoText = self.frame:CreateFontString(nil, "OVERLAY")
    self.infoText = infoText
end

function TI:OnInit()
    -- Get our settings DB
    self.db = WB:GetSubModuleDB(self:GetName())

    -- Don't init second time
    if self.Initialized then return end

    -- Vars
    self.frame = self.SubModuleHolder
    self.hasInvite = false
    self.hasMail = false
    self.activeInfoText = {}

    self:CreateClock()
    self:OnWunderBarUpdate()

    -- We are done, hooray!
    self.Initialized = true
end

WB:RegisterSubModule(TI, {
    "UPDATE_INSTANCE_INFO", "CALENDAR_EVENT_ALARM", "MAIL_INBOX_UPDATE", "UPDATE_PENDING_MAIL", "MAIL_CLOSED",
    "MAIL_SHOW"
})
