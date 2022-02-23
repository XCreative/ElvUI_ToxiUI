local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local FP = TXUI:NewModule("FadePersist", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

function FP:OnEvent(parent, event)
    -- If disabled but still hooked, call original method
    if (not self.db.enabled) or (self.db.mode == "ELVUI") then
        self.hooks[parent].OnEvent(parent, event)
        return
    end

    local fadeIn = self.fadeOverride

    if (not fadeIn) then
        if (self.db.mode == "ALWAYS") then
            fadeIn = true
        elseif (self.db.mode == "IN_COMBAT") then
            fadeIn = (UnitAffectingCombat("player")) or (event == "PLAYER_REGEN_DISABLED")
        elseif (self.db.mode == "NO_COMBAT") then
            fadeIn = (not UnitAffectingCombat("player")) and (event ~= "PLAYER_REGEN_DISABLED")
        end
    end

    if (fadeIn) then
        parent.mouseLock = true
        E:UIFrameFadeIn(parent, 0.2, parent:GetAlpha(), 1)
        self.ab:FadeBlings(1)
    else
        parent.mouseLock = false
        E:UIFrameFadeOut(parent, 0.2, parent:GetAlpha(), 0)
        self.ab:FadeBlings(0)
    end
end

function FP:ToggleOverride(enabled)
    self.fadeOverride = enabled
    self:OnEvent(self.ab.fadeParent, "FADE_OVERRIDE")
end

function FP:Disable()
    self:CancelAllTimers()
    self:UnregisterAllEvents()
    self:UnhookAll()

    if (self.ab) then
        self.ab.fadeParent:GetScript("OnEvent")(self.ab.fadeParent)
        self.ab.fadeParent:RegisterEvent("PLAYER_REGEN_DISABLED")
        self.ab.fadeParent:RegisterEvent("PLAYER_REGEN_ENABLED")
        self.ab.fadeParent:RegisterEvent("PLAYER_TARGET_CHANGED")
        self.ab.fadeParent:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
        self.ab.fadeParent:RegisterEvent("UPDATE_POSSESS_BAR")
        self.ab.fadeParent:RegisterEvent("VEHICLE_UPDATE")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
        self.ab.fadeParent:RegisterUnitEvent("UNIT_HEALTH", "player")
        self.ab.fadeParent:RegisterEvent("PLAYER_FOCUS_CHANGED")
    end
end

function FP:Enable()
    -- Don't unregister for combat or ElvUI mode
    if (self.db.mode ~= "IN_COMBAT") and (self.db.mode ~= "NO_COMBAT") and (self.db.mode ~= "ELVUI") then
        self.ab.fadeParent:UnregisterEvent("PLAYER_REGEN_DISABLED")
        self.ab.fadeParent:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end

    -- Don't unregister for default ElvUI mode
    if (self.db.mode ~= "ELVUI") then
        self.ab.fadeParent:UnregisterEvent("PLAYER_TARGET_CHANGED")
        self.ab.fadeParent:UnregisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
        self.ab.fadeParent:UnregisterEvent("UPDATE_POSSESS_BAR")
        self.ab.fadeParent:UnregisterEvent("VEHICLE_UPDATE")
        self.ab.fadeParent:UnregisterEvent("UNIT_ENTERED_VEHICLE")
        self.ab.fadeParent:UnregisterEvent("UNIT_EXITED_VEHICLE")
        self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_START")
        self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_STOP")
        self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
        self.ab.fadeParent:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
        self.ab.fadeParent:UnregisterEvent("UNIT_HEALTH")
        self.ab.fadeParent:UnregisterEvent("PLAYER_FOCUS_CHANGED")
    end

    -- Hook main event script if not hooked already
    self:RawHookScript(self.ab.fadeParent, "OnEvent", function(...)
        self:OnEvent(...)
    end)

    -- Hook Keybind Mode
    self:SecureHook(self.ab, "ActivateBindMode", function()
        self:ToggleOverride(true)
    end)

    self:SecureHook(self.ab, "DeactivateBindMode", function()
        self:ToggleOverride(false)
    end)

    -- Re-register so command gets updated with new reference
    E:UnregisterChatCommand("kb")
    E:RegisterChatCommand("kb", self.ab.ActivateBindMode)

    -- Force refresh
    self:OnEvent(self.ab.fadeParent)
end

function FP:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.addons.fadePersist

    if TXUI:HasRequirements(I.Requirements.FadePersist) and (self.db) and (self.db.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

function FP:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function FP:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function FP:Initialize(worldInit)
    -- Set db
    self.db = E.db.TXUI.addons.fadePersist

    -- Don't init second time
    if self.Initialized then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.FadePersist)) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return

        -- Register start events
    elseif (not worldInit) then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        return
    end

    -- Get ActionBars
    self.ab = E:GetModule("ActionBars")

    -- Vars
    self.fadeOverride = false

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(FP:GetName())
