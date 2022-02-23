local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local VB = TXUI:NewModule("VehicleBar", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local LAB = _G.LibStub("LibActionButton-1.0-ElvUI")

-- Globals
local GetOverrideBarIndex = GetOverrideBarIndex
local GetVehicleBarIndex = GetVehicleBarIndex
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local split = string.split
local format = string.format
local UnregisterStateDriver = UnregisterStateDriver

-- Vars
local AB

function VB:StopAllAnimations()
    if (self.bar.SlideIn) and (self.bar.SlideIn.SlideIn:IsPlaying()) then self.bar.SlideIn.SlideIn:Finish() end

    for _, button in ipairs(self.bar.buttons) do
        if (button.FadeIn) and (button.FadeIn:IsPlaying()) then
            button.FadeIn:Stop()
            button:SetAlpha(1)
        end
    end
end

function VB:SetupButtonAnim(button, index)
    local iconFade = (1 * self.db.animationsMult)
    local iconHold = (index * 0.10) * self.db.animationsMult

    button.FadeIn = button.FadeIn or TXUI:CreateAnimationGroup(button)

    button.FadeIn.ResetFade = button.FadeIn.ResetFade or button.FadeIn:CreateAnimation("Fade")
    button.FadeIn.ResetFade:SetDuration(0)
    button.FadeIn.ResetFade:SetChange(0)
    button.FadeIn.ResetFade:SetOrder(1)

    button.FadeIn.Hold = button.FadeIn.Hold or button.FadeIn:CreateAnimation("Sleep")
    button.FadeIn.Hold:SetDuration(iconHold)
    button.FadeIn.Hold:SetOrder(2)

    button.FadeIn.Fade = button.FadeIn.Fade or button.FadeIn:CreateAnimation("Fade")
    button.FadeIn.Fade:SetEasing("out-quintic")
    button.FadeIn.Fade:SetChange(1)
    button.FadeIn.Fade:SetDuration(iconFade)
    button.FadeIn.Fade:SetOrder(3)
end

function VB:SetupBarAnim()
    local iconFade = ((7 * 0.10) * self.db.animationsMult) + (1 * self.db.animationsMult)

    self.bar.SlideIn = self.bar.SlideIn or {}

    self.bar.SlideIn.ResetOffset = self.bar.SlideIn.ResetOffset or
                                       TXUI:CreateAnimationGroup(self.bar):CreateAnimation("Move")
    self.bar.SlideIn.ResetOffset:SetDuration(0)
    self.bar.SlideIn.ResetOffset:SetOffset(0, -60)
    self.bar.SlideIn.ResetOffset:SetScript("OnFinished", function(anim)
        anim:GetParent().SlideIn.SlideIn:SetOffset(0, 60)
        anim:GetParent().SlideIn.SlideIn:Play()
    end)

    self.bar.SlideIn.SlideIn = self.bar.SlideIn.SlideIn or TXUI:CreateAnimationGroup(self.bar):CreateAnimation("Move")
    self.bar.SlideIn.SlideIn:SetEasing("out-quintic")
    self.bar.SlideIn.SlideIn:SetDuration(iconFade)
end

function VB:OnShowEvent()
    self:StopAllAnimations()

    local animationsAllowed = (self.db.animations) and (not InCombatLockdown()) and (not self.combatLock)

    if (animationsAllowed) then
        self:SetupBarAnim()
        self.bar.SlideIn.ResetOffset:Play()

        for i, button in ipairs(self.bar.buttons) do self:SetupButtonAnim(button, i) end
    end

    for _, button in ipairs(self.bar.buttons) do
        if (animationsAllowed) then
            button:SetAlpha(0)
            button.FadeIn:Play()
        else
            button:SetAlpha(1)
        end
    end
end

function VB:UpdateBar()
    AB = AB or E:GetModule("ActionBars")

    -- Vars
    local size = 40
    local spacing = 2

    -- Create or get bar
    local bar = self.bar or
                    CreateFrame("Frame", "TXUIVehicleBar", E.UIParent, "SecureHandlerStateTemplate, BackdropTemplate")

    -- Default position
    local point, anchor, attachTo, x, y = split(",", self.db.position)
    bar:Point(point, anchor, attachTo, x, y)

    -- Set bar vars
    self.bar = bar
    self.bar.id = 1

    -- Page Handling
    bar:SetAttribute("_onstate-page", [[
        if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
            newstate = GetTempShapeshiftBarIndex() or newstate
        end

        if newstate ~= 0 then
            self:SetAttribute("state", newstate)
            control:ChildUpdate("state", newstate)
        else
            local newCondition = self:GetAttribute("newCondition")
            if newCondition then
                newstate = SecureCmdOptionParse(newCondition)
                self:SetAttribute("state", newstate)
                control:ChildUpdate("state", newstate)
            end
        end
    ]])

    -- Create Buttons
    if (not bar.buttons) then
        bar.buttons = {}

        for i = 1, 7 do
            local buttonIndex = (i == 7) and 12 or i

            -- Create button
            local button = LAB:CreateButton(buttonIndex, "TXUIVehicleBarButton" .. buttonIndex, bar, nil)

            -- Set state aka actions
            button:SetState(0, "action", buttonIndex)
            for k = 1, 14 do button:SetState(k, "action", (k - 1) * 12 + buttonIndex) end
            if (buttonIndex == 12) then button:SetState(12, "custom", AB.customExitButton) end

            -- Style
            AB:StyleButton(button, nil, nil)
            button:SetTemplate("Transparent")
            button:SetCheckedTexture("")

            -- Add to array
            bar.buttons[i] = button
        end
    end

    -- Calculate Bar Width/Height
    bar:SetWidth((size * 7) + (spacing * (7 - 1)) + 4)
    bar:SetHeight(size + 4)

    -- Update button position and size
    for i, button in ipairs(bar.buttons) do
        button:Size(size)
        button:ClearAllPoints()

        if (i == 1) then
            button:SetPoint("BOTTOMLEFT", 2, 2)
        else
            button:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", spacing, 0)
        end
    end

    -- Update Paging
    local pageAttribute = AB:GetPage("bar1", 1,
                                     format("[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;",
                                            GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex()))
    RegisterStateDriver(bar, "page", pageAttribute)
    self.bar:SetAttribute("page", pageAttribute)

    -- ElvUI Bar config
    AB:UpdateButtonConfig("bar1", "ACTIONBUTTON")
    AB:PositionAndSizeBar("bar1")

    -- Hook for animation
    self:SecureHookScript(bar, "OnShow", "OnShowEvent")

    -- Hide
    bar:Hide()
end

function VB:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self.regenEnabledInit = true
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function VB:PLAYER_REGEN_DISABLED()
    self.combatLock = true
    self:StopAllAnimations()
end

function VB:PLAYER_REGEN_ENABLED()
    self.combatLock = false

    if (self.regenEnabledInit) then
        self.regenEnabledInit = false
        self:ProfileUpdate()
    end
end

function VB:Disable()
    self:CancelAllTimers()
    self:UnregisterAllEvents()
    self:UnhookAll()

    if (self.Initialized) then
        self:StopAllAnimations()
        UnregisterStateDriver(self.bar, "visibility")
        UnregisterStateDriver(AB["handledBars"]["bar1"], "visibility")
        RegisterStateDriver(AB["handledBars"]["bar1"], "visibility", E.db.actionbar["bar1"].visibility)
        self.bar:Hide()
    end
end

function VB:Enable()
    self:UnregisterAllEvents()

    -- Update or create bar
    self:UpdateBar()

    -- Overwrite default bar visibility
    AB = AB or E:GetModule("ActionBars")
    local visibility = "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] hide;"

    self:Hook(AB, "PositionAndSizeBar", function(_, barName)
        local bar = AB["handledBars"][barName]
        if (E.db.actionbar[barName].enabled) and (barName == "bar1") then
            UnregisterStateDriver(bar, "visibility")
            RegisterStateDriver(bar, "visibility", visibility .. E.db.actionbar[barName].visibility)
        end
    end)

    -- Unregister/Register State Driver
    UnregisterStateDriver(self.bar, "visibility")
    UnregisterStateDriver(AB["handledBars"]["bar1"], "visibility")

    RegisterStateDriver(self.bar, "visibility",
                        "[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide")
    RegisterStateDriver(AB["handledBars"]["bar1"], "visibility", visibility .. E.db.actionbar["bar1"].visibility)

    -- Register Events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function VB:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.vehicleBar

    if TXUI:HasRequirements(I.Requirements.VehicleBar) and (self.db and self.db.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

--[[ Initialization ]] --
function VB:Initialize(worldInit)
    -- Get db
    self.db = E.db.TXUI.vehicleBar

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.VehicleBar)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Register start events
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Wait for construction after combat
    if InCombatLockdown() then
        self.regenEnabledInit = true
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- We stop here if we are not from a entered world call
    if (not worldInit) then return end

    -- Vars
    self.combatLock = false

    -- Create & Enable
    self:Enable()

    -- Create Mover
    E:CreateMover(self.bar, "ToxiUIVehicleBar", TXUI.Title .. " Vehicle Bar")

    -- Force update
    for _, button in pairs(self.bar.buttons) do button:UpdateAction() end

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(VB:GetName())
