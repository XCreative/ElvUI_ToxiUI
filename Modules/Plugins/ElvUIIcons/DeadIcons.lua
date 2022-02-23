local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local DI = TXUI:NewModule("DeadIcons", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local _G = _G
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost

-- Vars
local UF
local OUF

function DI.ElementUpdate(frame, _, unit)
    local element = frame.Dead
    if (not element) then return end

    if (unit and unit ~= frame.unit) then return end
    if (not unit) then unit = frame.unit end

    local isDead = frame.isForced or UnitIsDead(unit) or UnitIsGhost(unit)

    if isDead then
        element:Show()
    else
        element:Hide()
    end
end

function DI.ElementEnable(frame)
    local element = frame.Dead
    if (not element) then return end

    element.__owner = frame

    frame:RegisterEvent("UNIT_HEALTH", DI.ElementUpdate)
    element:Hide()

    DI.ElementUpdate(frame)

    return true
end

function DI.ElementDisable(frame)
    local element = frame.Dead
    if (not element) then return end

    frame:UnregisterEvent("UNIT_HEALTH", DI.ElementUpdate)
    element:Hide()
end

function DI:UpdateDeadIcon(frame)
    frame.Dead:SetSize(self.db.size, self.db.size)
    frame.Dead:SetPoint("CENTER", frame, "CENTER", self.db.xOffset, self.db.yOffset)
    frame.Dead:SetTexture(F.GetMedia(I.Media.StateIcons, I.ElvUIIcons.Dead[self.db.theme]))
end

function DI:UpdatePartyFrames(_, frame)
    -- Update Element
    if (self.db.enabled) then
        -- Construct Dead Icon if needed
        if (not frame.Dead) then
            frame.Dead = frame.RaisedElementParent.TextureParent:CreateTexture(frame:GetName() .. "DeadIcon", "OVERLAY")
        end

        -- Enable element
        if (not frame:IsElementEnabled("TXDead")) then frame:EnableElement("TXDead") end

        -- Set settings
        self:UpdateDeadIcon(frame)
    elseif (frame:IsElementEnabled("TXDead")) then
        frame:DisableElement("TXDead")
    end
end

function DI:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function DI:Disable()
    self:UnregisterAllEvents()

    -- We call an update before unhooking, in case we are active and hooked to replace the old override
    if (UF) then UF:Update_AllFrames() end

    self:UnhookAll()

    E:GetModule("UnitFrames"):Update_AllFrames()
end

function DI:Enable()
    self:UnregisterAllEvents()

    self:SecureHook(UF, "Update_PartyFrames", "UpdatePartyFrames")

    UF:Update_AllFrames()
end

function DI:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.elvUIIcons.deadIcons

    if (self.db and self.db.enabled) and TXUI:HasRequirements(I.Requirements.RoleIcons) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function DI:Initialize()
    -- Set db
    self.db = E.db.TXUI.elvUIIcons.deadIcons

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.RoleIcons)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- Get Frameworks
    UF = E:GetModule("UnitFrames")
    OUF = E.oUF or _G.oUF

    -- Register ourself
    OUF:AddElement("TXDead", self.ElementUpdate, self.ElementEnable, self.ElementDisable)

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(DI:GetName())
