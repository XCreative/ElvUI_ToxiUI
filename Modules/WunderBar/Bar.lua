local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local LSM = E.Libs.LSM

-- Globals
local C_PetBattles_IsInBattle = C_PetBattles.IsInBattle
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsResting = IsResting

function WB:BarFadeIn()
    if (not self.isEnabled) then return end

    self:FadeIn(self.bar, 1)
end

function WB:BarFadeOut()
    if (not self.isEnabled) then return end

    self:FadeOut(self.bar, 1)
end

function WB:CheckVisibility(event)
    if (not self.isEnabled) then return end

    local isVisible = true

    -- Always hide for pokemon
    if (self.isVisible) and (C_PetBattles_IsInBattle()) then isVisible = false end

    -- Only visible on mouseover
    if (isVisible) and (self.db.general.barMouseOverOnly) and (not self.isMouseOver) then isVisible = false end

    -- Check if not overwritten by mouseover
    if (isVisible) then
        if (self.db.general.barVisibility == "ALWAYS") then
            isVisible = true
        elseif (self.db.general.barVisibility == "RESTING") then
            isVisible = IsResting()
        elseif (self.db.general.barVisibility == "NO_COMBAT") then
            if (event) then
                if (event == "PLAYER_REGEN_DISABLED") then isVisible = false end
            else
                isVisible = not InCombatLockdown()
            end
        end
    end

    if (not self.isVisible) and (isVisible) then
        self:BarFadeIn()
    elseif (self.isVisible) and (not isVisible) then
        self:BarFadeOut()
    end

    self.isVisible = isVisible
end

function WB:BarOnEnter()
    self.isMouseOver = true
    if (self.db.general.barMouseOverOnly) then
        if (self.mouseOverTimer) then self:CancelTimer(self.mouseOverTimer) end
        self:CheckVisibility()
    end
end

function WB:BarOnLeave()
    if (self.db.general.barMouseOverOnly) then
        if (self.mouseOverTimer) then self:CancelTimer(self.mouseOverTimer) end

        self.mouseOverTimer = self:ScheduleTimer(function()
            self.isMouseOver = false
            self:CheckVisibility()
        end, 2)
    else
        self.isMouseOver = false
    end
end

function WB:BarOnUpdate(_, elapsed)
    if (not self.isVisible) then return end
    self:HandleModuleOnUpdate(elapsed)
end

function WB:UpdateBar()
    -- Size for bar
    local barHeight = E:Scale(self.db.general.barHeight)
    self.bar:SetSize(F.PerfectScale(self.db.general.barWidth), barHeight)
    self.bar:ClearAllPoints()
    self.bar:Point("BOTTOM", 0, 0)

    -- Size for modules
    local panelSize = F.PerfectScale(self:CalculateEqualWidth(self.db.general.barWidth,
                                                              E:Scale(self.db.general.barSpacing)))
    self.bar.leftPanel:SetSize(panelSize, barHeight)
    self.bar.middlePanel:SetSize(panelSize, barHeight)
    self.bar.rightPanel:SetSize(panelSize, barHeight)

    -- Set Background
    local lsmTexture = LSM:Fetch("statusbar", self.db.general.backgroundTexture)
    if not lsmTexture then lsmTexture = E.media.blankTex end -- backup to elvui texture if not found
    self.bar.barBackground:SetTexture(lsmTexture)

    -- Revert 1st April RGB mode
    if (self.db.general.backgroundColor == "RGB") then self.db.general.backgroundColor = "CLASS" end

    -- Get color from func
    local color = F.GetFontColorFromDB({
        FontColor = self.db.general.backgroundColor,
        FontCustomColor = self.db.general.backgroundCustomColor
    })

    -- Custom handling for ElvUI & Class Color
    if (self.db.general.backgroundColor == "CLASS") then
        color.a = 0.6
    elseif (self.db.general.backgroundColor == "VALUE") then
        color = E.db.general.backdropfadecolor
    end

    -- Set Fade
    if self.db.general.backgroundGradient then
        self.bar.barBackground:SetGradientAlpha("VERTICAL", color.r, color.g, color.b, color.a, color.r, color.g,
                                                color.b, color.a * (1 - self.db.general.backgroundGradientAlpha))
    else
        self.bar.barBackground:SetGradientAlpha("VERTICAL", color.r, color.g, color.b, color.a, color.r, color.g,
                                                color.b, color.a)
    end

    self:UpdatePanelModules()
    self:CheckVisibility()
end

function WB:ConstructBar()
    if self.bar then return end

    local bar = CreateFrame("Frame", "TXUIWunderBar", E.UIParent)
    bar:SetFrameStrata("MEDIUM")

    local barBackground = bar:CreateTexture(nil, "BACKGROUND")
    barBackground:SetAllPoints()

    local leftPanel = CreateFrame("Frame", "TXUIWunderBarLeftPanel", bar)
    local middlePanel = CreateFrame("Frame", "TXUIWunderBarMiddlePanel", bar)
    local rightPanel = CreateFrame("Frame", "TXUIWunderBarRightPanel", bar)

    leftPanel:Point("RIGHT", middlePanel, "LEFT", 0, 0)
    middlePanel:Point("CENTER", bar, "CENTER", 0, 0)
    rightPanel:Point("LEFT", middlePanel, "RIGHT", 0, 0)

    leftPanel.panelName = "LeftPanel"
    middlePanel.panelName = "MiddlePanel"
    rightPanel.panelName = "RightPanel"

    bar.leftPanel = leftPanel
    bar.middlePanel = middlePanel
    bar.rightPanel = rightPanel
    bar.barBackground = barBackground

    self.bar = bar
end
