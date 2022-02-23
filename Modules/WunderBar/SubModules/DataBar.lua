local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local DB = WB:NewModule("DataBar")

-- Globals
local abs = math.abs
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestWatchType = C_QuestLog.GetQuestWatchType
local C_QuestLog_ReadyForTurnIn = C_QuestLog.ReadyForTurnIn
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local CreateFrame = CreateFrame
local GetFriendshipReputation = GetFriendshipReputation
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetXPExhaustion = GetXPExhaustion
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local IsXPUserDisabled = IsXPUserDisabled
local min = math.min
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax

-- Vars
DB.const = { mode = { ["rep"] = 0, ["exp"] = 1 } }

function DB:GetValues(curValue, minValue, maxValue)
    local maximum = maxValue - minValue
    local current, diff = curValue - minValue, maximum

    if diff == 0 then diff = 1 end -- prevent a division by zero

    if current == maximum then
        return 1, 1, 100, true
    else
        return current, maximum, E:Round(current / diff * 100)
    end
end

function DB:OnEvent(event)
    -- If smart mode changes, force update
    if (self:UpdateSmartMode()) then event = "ELVUI_FORCE_UPDATE" end

    -- Reputation
    if (self.mode == DB.const.mode.rep) and
        ((event == "ELVUI_FORCE_UPDATE") or (event == "UPDATE_FACTION") or (event == "COMBAT_TEXT_UPDATE")) then
        local name, _, minValue, maxValue, curValue, factionID = GetWatchedFactionInfo()

        if not name then
            self.noData = true
            self:UpdateBar()
            return
        end

        self.noData = false

        local friendshipID, _, _, _, _, _, _, _, nextThreshold = GetFriendshipReputation(factionID)

        if friendshipID then
            if not nextThreshold then minValue, maxValue, curValue = 0, 1, 1 end
        elseif C_Reputation_IsFactionParagon(factionID) then
            local current, threshold
            current, threshold, _, _ = C_Reputation_GetFactionParagonInfo(factionID)

            if current and threshold then minValue, maxValue, curValue = 0, threshold, current % threshold end
        end

        local _, _, percent, _ = self:GetValues(curValue, minValue, maxValue)
        self.data.repPercentage = percent

        self:UpdateTooltip()
        self:UpdateBar()

        -- Experience
    elseif (self.mode == DB.const.mode.exp) and
        ((event == "ELVUI_FORCE_UPDATE") or (event == "PLAYER_XP_UPDATE") or (event == "DISABLE_XP_GAIN") or
            (event == "ENABLE_XP_GAIN") or (event == "QUEST_LOG_UPDATE") or (event == "SUPER_TRACKING_CHANGED") or
            (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") or (event == "UPDATE_EXHAUSTION")) then
        if (IsXPUserDisabled()) or (IsPlayerAtEffectiveMaxLevel()) then
            self.data.expRestPercentage = 0
            self.data.expCompletedPercentage = 0
            self.data.expPercentage = 100
        else
            local currentXP, xpToLevel, restedXP = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
            if xpToLevel <= 0 then xpToLevel = 1 end

            if (self.db.showCompletedXP) and (event ~= "PLAYER_XP_UPDATE") then
                self.data.expCompletedPercentage = self:GetCompletedPercentage(currentXP, xpToLevel)
            end

            self.data.expRestPercentage =
                (restedXP and restedXP > 0) and ((min(restedXP, xpToLevel) / xpToLevel) * 100) or 0
            self.data.expPercentage = (currentXP / xpToLevel) * 100
        end

        self:UpdateTooltip()
        self:UpdateBar()
    end
end

function DB:UpdateTooltip()
    if (not self.mouseover) then return end

    if (self.mode == DB.const.mode.exp) then
        local dtModule = WB:GetElvUIDataText("Experience")
        if dtModule then
            dtModule.eventFunc(WB:GetElvUIDummy(), "ELVUI_FORCE_UPDATE")
            dtModule.onEnter()
        end
    elseif (self.mode == DB.const.mode.rep) then
        local dtModule = WB:GetElvUIDataText("Reputation")
        if dtModule then
            dtModule.eventFunc(WB:GetElvUIDummy(), "ELVUI_FORCE_UPDATE")
            dtModule.onEnter()
        end
    end
end

function DB:OnEnter()
    self.mouseover = true
    self:UpdateTooltip()

    WB:SetAccentColorFunc(self.bar, "statusbar")
    WB:SetAccentColorFunc(self.bar.background, "vertex", 0.33)

    if self.db.showIcon then WB:SetFontAccentColor(self.barIcon) end
end

function DB:OnLeave()
    self.mouseover = false

    WB:SetNormalColorFunc(self.bar, "statusbar")
    WB:SetNormalColorFunc(self.bar.background, "vertex", 0.33)

    if self.db.showIcon then WB:SetFontIconColor(self.barIcon) end
end

function DB:OnClick()
    if (self.mode ~= DB.const.mode.rep) then return end

    local dtModule = WB:GetElvUIDataText("Reputation")
    if dtModule then dtModule.onClick() end
end

function DB:OnWunderBarUpdate()
    self:UpdateSmartMode()
    self:UpdateElements()
    self:UpdateBar()
    self:UpdatePosition()
    self:OnEvent("ELVUI_FORCE_UPDATE")
end

function DB:UpdateBar()
    if self.noData then
        self.barFrame:Hide()
        return
    else
        self.barFrame:Show()
    end

    local barProgress
    if (self.mode == DB.const.mode.rep) then
        barProgress = self.data.repPercentage
    else
        barProgress = self.data.expPercentage
    end

    if (self.db.showIcon) and (abs(barProgress - self.bar:GetValue()) > 0.1) then
        WB:FlashFontOnEvent(self.barIcon, true)
        WB:FlashFade(self.bar.spark)
    end

    WB:SetBarProgress(self.bar, barProgress)

    if (self.db.showCompletedXP) and (self.mode == DB.const.mode.exp) then
        self.bar.completedOverlay:Show()
        WB:SetBarProgress(self.bar.completedOverlay, self.data.expCompletedPercentage)
    else
        self.bar.completedOverlay:Hide()
    end

    self:UpdateInfoText()
end

function DB:UpdatePosition()
    local anchorPoint = WB:GetGrowDirection(self.Module, true)
    local maxWidth = WB:GetMaxWidth(self.Module)
    local iconSize = self.db.showIcon and self.db.iconFontSize or 0.01
    local barOffset = self.db.barOffset

    local iconOffset = 2
    local iconPadding = 5
    local iconSpace = iconSize + (iconPadding * 2)

    self.bar:ClearAllPoints()
    self.bar:SetSize(maxWidth - iconSpace - iconPadding, self.db.barHeight)
    self.bar.spark:SetSize(20, self.db.barHeight * 4)

    if anchorPoint == "RIGHT" then
        self.bar:SetPoint(anchorPoint, self.frame, anchorPoint, 0, barOffset)
    else
        self.bar:SetPoint(anchorPoint, self.frame, anchorPoint, iconSpace, barOffset)
    end

    self.barFrame:ClearAllPoints()
    self.barFrame:SetAllPoints()

    self.barIcon:ClearAllPoints()
    self.barIcon:Point("RIGHT", self.bar, "LEFT", -iconPadding, iconOffset)

    self.infoText:ClearAllPoints()
    self.infoText:SetPoint("CENTER", self.bar, "CENTER", 0, self.db.infoOffset)

    self.bar.completedOverlay:ClearAllPoints()
    self.bar.completedOverlay:SetAllPoints(self.bar)
end

function DB:GetCompletedPercentage(currentXP, xpToLevel)
    local totalCompletedXP = 0

    for i = 1, C_QuestLog_GetNumQuestLogEntries() do
        local questInfo = C_QuestLog_GetInfo(i)
        if (questInfo) and (not questInfo.isHidden) and (questInfo.isOnMap) and
            C_QuestLog_GetQuestWatchType(questInfo.questID) and C_QuestLog_ReadyForTurnIn(questInfo.questID) then
            totalCompletedXP = totalCompletedXP + GetQuestLogRewardXP(questInfo.questID)
        end
    end

    return (min(currentXP + totalCompletedXP, xpToLevel) / xpToLevel) * 100
end

function DB:UpdateSmartMode(init)
    local mode = ((self.db.mode == "auto") and (not IsPlayerAtEffectiveMaxLevel()) and (not IsXPUserDisabled())) and
                     self.const.mode.exp or self.const.mode.rep

    if (not init) and (mode ~= self.mode) then
        self.mode = mode
        return true
    elseif (init) then
        self.mode = mode
        return true
    end

    return false
end

function DB:UpdateElements()
    WB:SetIconFromDB(self.db, "icon", self.barIcon)
    self.barIcon:SetText(self.db.icon)

    WB:SetNormalColorFunc(self.bar, "statusbar", 1, false)
    WB:SetNormalColorFunc(self.bar.background, "vertex", 0.33, false)

    WB:SetAccentColorFunc(self.bar.completedOverlay, "statusbar", 0.33, false)
    WB:SetAccentColorFunc(self.bar.spark, "vertex", 0.33, false)

    if (self.db.showIcon) then
        self.barIcon:Show()
    else
        self.barIcon:Hide()
    end

    WB:SetFontFromDB(self.db, "info", self.infoText, true, self.db.infoUseAccent)
end

function DB:UpdateInfoText()

    if (self.db.infoEnabled) then
        self.infoText:SetText(E:Round((self.mode == DB.const.mode.exp) and (self.data.expPercentage) or
                                          (self.data.repPercentage)) .. "%")
    else
        self.infoText:SetText("")
    end
end

function DB:CreateBar()
    -- Frames
    local barFrame = CreateFrame("BUTTON", nil, self.frame)

    barFrame:Point("CENTER")

    local onEnter = function(...)
        WB:ModuleOnEnter(self, ...)
    end

    local onLeave = function(...)
        WB:ModuleOnLeave(self, ...)
    end

    local onClick = function(...)
        WB:ModuleOnClick(self, ...)
    end

    -- Frame
    barFrame:SetScript("OnEnter", onEnter)
    barFrame:SetScript("OnLeave", onLeave)

    barFrame:RegisterForClicks("AnyUp")
    barFrame:SetScript("OnClick", onClick)

    self.barFrame = barFrame

    -- Bar
    local bar = CreateFrame("STATUSBAR", nil, barFrame)
    bar:SetStatusBarTexture(1, 1, 1)
    bar:SetMinMaxValues(0, 100)
    bar.barTexture = bar:GetStatusBarTexture()
    bar.barTexture:SetDrawLayer("ARTWORK", 3)

    bar.spark = bar:CreateTexture(nil, "OVERLAY")
    bar.spark:SetDrawLayer("OVERLAY", 7)
    bar.spark:SetBlendMode("ADD")
    bar.spark:SetSnapToPixelGrid(false)
    bar.spark:SetPoint("LEFT", bar:GetStatusBarTexture(), "RIGHT", -10, 0)
    bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    bar.spark:SetAlpha(0)

    bar.completedOverlay = CreateFrame("STATUSBAR", nil, barFrame)
    bar.completedOverlay:SetStatusBarTexture(1, 1, 1)
    bar.completedOverlay:SetMinMaxValues(0, 100)
    bar.completedOverlay:EnableMouse(false)
    bar.completedOverlay.barTexture = bar.completedOverlay:GetStatusBarTexture()
    bar.completedOverlay.barTexture:SetDrawLayer("ARTWORK", 2)

    bar.background = bar:CreateTexture(nil, "BACKGROUND")
    bar.background:SetColorTexture(1, 1, 1)
    bar.background:SetAllPoints()

    self.bar = bar

    -- Info Text
    local infoText = bar:CreateFontString(nil, "OVERLAY")
    self.infoText = infoText

    -- Icon
    local barIcon = bar:CreateFontString(nil, "OVERLAY")
    barIcon:Point("CENTER")

    self.barIcon = barIcon
end

function DB:OnInit()
    -- Get our settings DB
    self.db = WB:GetSubModuleDB(self:GetName())

    -- Don't init second time
    if self.Initialized then return end

    -- Vars
    self.frame = self.SubModuleHolder
    self.noData = false
    self.data = {
        ["repPercentage"] = 0,
        ["expPercentage"] = 0,
        ["expRestPercentage"] = 0,
        ["expCompletedPercentage"] = 0
    }

    self:CreateBar()
    self:UpdateSmartMode(true)
    self:OnWunderBarUpdate()

    -- We are done, hooray!
    self.Initialized = true
end

WB:RegisterSubModule(DB, {
    "PLAYER_XP_UPDATE", "QUEST_LOG_UPDATE", "SUPER_TRACKING_CHANGED", "ZONE_CHANGED", "ZONE_CHANGED_NEW_AREA",
    "UPDATE_EXPANSION_LEVEL", "DISABLE_XP_GAIN", "ENABLE_XP_GAIN", "UPDATE_EXHAUSTION", "UPDATE_FACTION",
    "COMBAT_TEXT_UPDATE"
})
