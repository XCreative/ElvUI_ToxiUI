local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local AFK = TXUI:NewModule("AFK", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Globals
local _G = _G
local random = random
local CloseAllWindows = CloseAllWindows
local CreateFrame = CreateFrame
local GetTime = GetTime
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame

-- Vars
AFK.timerText = "AWAY FOR "
AFK.randomAnimations = {
    [60] = true, -- EmoteTalk
    [66] = true, -- EmoteBow
    [67] = true, -- EmoteWave
    [68] = true, -- EmoteCheer
    [69] = true, -- EmoteDance
    [70] = true, -- EmoteLaugh
    [71] = true, -- EmoteSleep
    [73] = true, -- EmoteRude
    [74] = true, -- EmoteRoar
    [75] = true, -- EmoteKneel
    [76] = true, -- EmoteKiss
    [77] = true, -- EmoteCry
    [78] = true, -- EmoteChicken
    [79] = true, -- EmoteBeg
    [80] = true, -- EmoteApplaud
    [81] = true, -- EmoteShout
    [82] = true, -- EmoteFlex
    [83] = true, -- EmoteShy
    [84] = true, -- EmotePoint
    [113] = true, -- EmoteSalute
    [185] = true, -- EmoteYes
    [186] = true, -- EmoteNo
    [195] = true, -- EmoteTrain
    [196] = true, -- EmoteDead
    [506] = true -- EmoteSniff
}

function AFK:ResetPlayedAnimations()
    for animation, _ in pairs(self.randomAnimations) do self.randomAnimations[animation] = true end
end

function AFK:GetAnimationCount(remaining)
    local count = 0
    for _, enabled in pairs(AFK.randomAnimations) do
        if (not remaining) or (remaining and enabled) then count = count + 1 end
    end
    return count
end

function AFK:GetAvaibleAnimations()
    local avaibleAnimation = {}

    for randomAnimation, enabled in pairs(self.randomAnimations) do
        if (enabled) and (self.frame.bottom.model:HasAnimation(randomAnimation)) then
            tinsert(avaibleAnimation, randomAnimation)
        end
    end

    return avaibleAnimation
end

function AFK:PlayRandomAnimation()
    if (not self.elvUIAfk.isAFK) then return end

    -- Get not played and animations that the model supports
    local avaibleAnimation = self:GetAvaibleAnimations()

    -- No Animations avaible, reset all used ones
    if (#avaibleAnimation == 0) then
        self:ResetPlayedAnimations()
        avaibleAnimation = self:GetAvaibleAnimations()
    end

    -- Still no Animation avaible, don't do anything, try next time
    if (#avaibleAnimation == 0) then
        self:StartAnimationCycle()
        return
    end

    -- Get random animations from the once avaible
    local newAnimation = avaibleAnimation[random(1, #avaibleAnimation)]

    -- Mark animation as played
    self.randomAnimations[newAnimation] = false

    -- Set Animation!
    self.frame.bottom.model:SetAnimation(newAnimation)

    -- Start Timer for next animation
    self:StartAnimationCycle()
end

function AFK:StartAnimationCycle()
    if (not self.elvUIAfk.isAFK) then return end

    self:CancelTimer(self.animationTimer)
    self.animationTimer = self:ScheduleTimer("PlayRandomAnimation", random(15, 30))
end

function AFK:PlayIdleAnimation()
    self.frame.bottom.model:SetAnimation(0, random(1, 4), 1)
end

function AFK:UpdateTimer()
    local time = GetTime() - self.startTime
    self.frame.bottom.logoText:SetFormattedText("%s %02d:%02d", self.timerText, floor(time / 60), time % 60)
end

function AFK:SetAFK(_, status)
    self.screenActive = status

    self:CancelAllTimers()

    if (status) and (not self.elvUIAfk.isAFK) then
        self.elvUIAfk.isAFK = true

        if (self.db.turnCamera) then
            MoveViewLeftStart(0.035) -- Turns camera smoothly
        end

        self.frame:Show()
        CloseAllWindows()
        _G.UIParent:Hide()

        self.frame.bottom:Height(0)
        self.frame.bottom.anim:Play()

        self.startTime = GetTime()
        self.timerUpdate = self:ScheduleRepeatingTimer("UpdateTimer", 0.32)

        self.frame.chat:RegisterEvent("CHAT_MSG_WHISPER")
        self.frame.chat:RegisterEvent("CHAT_MSG_BN_WHISPER")
        self.frame.chat:RegisterEvent("CHAT_MSG_GUILD")

        self.frame.bottom.model:SetUnit("player")
        self.frame.bottom.model:SetScript("OnAnimFinished", function()
            self:PlayIdleAnimation()
        end)

        if (self.db.playEmotes) then
            self:ResetPlayedAnimations()
            self:PlayRandomAnimation()
        else
            self:PlayIdleAnimation()
        end

    elseif (not status) and (self.elvUIAfk.isAFK) then
        self.elvUIAfk.isAFK = false

        _G.UIParent:Show()
        self.frame:Hide()

        if (self.db.turnCamera) then
            MoveViewLeftStop() -- turn off camera movement
        end

        self.frame.bottom.model:SetScript("OnAnimFinished", nil)
        self.frame.bottom.model:SetAnimation(0, 0, 1)
        self.frame.bottom.logoText:SetText(" ")

        self.frame.chat:UnregisterAllEvents()
        self.frame.chat:Clear()

        if _G.PVEFrame:IsShown() then
            PVEFrame_ToggleFrame()
            PVEFrame_ToggleFrame()
        end
    end
end

function AFK:SetupFrames()
    -- Vars
    local bottomHeight = E.physicalHeight * (1 / 9)
    self.frame = self.elvUIAfk.AFKMode

    -- Cancel ElvUI timers
    self.elvUIAfk:CancelAllTimers()

    -- Move the chat lower
    self.frame.chat:ClearAllPoints()
    self.frame.chat:Point("TOPLEFT", self.frame.bottom, "BOTTOMLEFT", 4, -10)

    -- Bottom Frame Animation
    self.frame.bottom.anim = TXUI:CreateAnimationGroup(self.frame.bottom):CreateAnimation("Height")
    self.frame.bottom.anim:SetChange(bottomHeight)
    self.frame.bottom.anim:SetDuration(1)
    self.frame.bottom.anim:SetEasing("out-bounce")

    -- ToxiUI logo
    self.frame.bottom.logoBackground = CreateFrame("Frame", nil, self.frame)
    self.frame.bottom.logoBackground:Point("BOTTOM", self.frame.bottom, "TOP", 0, -120)
    self.frame.bottom.logoBackground:SetFrameStrata("MEDIUM")
    self.frame.bottom.logoBackground:SetFrameLevel(10)
    self.frame.bottom.logoBackground:Size(220, 120)
    self.frame.bottom.faction:SetTexture(I.Media.Logos.Logo)
    self.frame.bottom.faction:ClearAllPoints()
    self.frame.bottom.faction:SetParent(self.frame.bottom.logoBackground)
    self.frame.bottom.faction:SetInside()

    -- Add ElvUI name
    self.frame.bottom.logoText = self.frame.bottom:CreateFontString(nil, "OVERLAY")
    self.frame.bottom.logoText:Point("LEFT", self.frame.bottom, "LEFT", 25, 0)
    self.frame.bottom.logoText:SetFont(self.mainFont, 40)
    self.frame.bottom.logoText:SetTextColor(1, 1, 1, 1)
    self.frame.bottom.logoText:SetText(" ")

    -- Player Model
    self.frame.bottom.model:Point("CENTER", self.frame.bottom.modelHolder, "CENTER", -50, 150)
    self.frame.bottom.model:SetCamDistanceScale(3) -- Lower number => bigger model. Higher number => smaller model.
    self.frame.bottom.model:SetScript("OnUpdate", nil)

    -- Sush
    F.CreateSoftShadow(self.frame.bottom, bottomHeight)

    -- Hide Stuff
    self.frame.bottom.time:Kill()
    self.frame.bottom.name:Kill()
    self.frame.bottom.LogoTop:Kill()
    self.frame.bottom.LogoBottom:Kill()
    self.frame.bottom.guild:Kill()
end

function AFK:Disable()
    self:CancelAllTimers()
    self:UnregisterAllEvents()
    self:UnhookAll()
end

function AFK:Enable()
    -- Force set settings
    E.db["general"]["afk"] = E.db.TXUI.addons.afkMode.enabled

    -- Get ElvUI Module
    self.elvUIAfk = E:GetModule("AFK")

    -- Hook SetAFK
    self:RawHook(self.elvUIAfk, "SetAFK", "SetAFK")

    -- Call setup if elvui already ran
    if (self.elvUIAfk.Initialized) then
        self:SetupFrames()
    else
        self:SecureHook(self.elvUIAfk, "Initialize", "SetupFrames")
    end
end

function AFK:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.addons.afkMode

    if self.db and self.db.enabled then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

function AFK:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function AFK:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function AFK:Initialize(worldInit)
    -- Set db
    self.db = E.db.TXUI.addons.afkMode

    -- Don't init second time
    if self.Initialized then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return

        -- Register start events
    elseif (not worldInit) then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        return
    end

    -- Get font
    self.mainFont = E.Libs.LSM:Fetch("font", "- Big Noodle Titling")

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(AFK:GetName())
