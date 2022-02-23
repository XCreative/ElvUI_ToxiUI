local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local RI = TXUI:NewModule("RoleIcons", "AceHook-3.0", "AceEvent-3.0")

-- Globals
local UnitIsConnected = UnitIsConnected
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

-- Vars
local UF

function RI:GetUnitFrameType(frame)
    if frame then
        if frame.unitframeType then
            return frame.unitframeType
        else
            local parent = frame:GetParent()
            if parent and parent.unitframeType then return parent.unitframeType end
        end
    end
end

function RI:SetRoleIcon(frame, event)
    if (not self.db) or (not self.db.enabled) then return end
    if (not frame.db) or (not frame.db.roleIcon) then return end

    -- Get type of unit, raid, party, focus etc
    local unitType = self:GetUnitFrameType(frame)
    if (not unitType) then return self:DebugPrint("UnitFrame Type was empty for frame", unitType) end

    -- Vars
    local roleIcon = frame.GroupRoleIndicator
    local roleDB = frame.db.roleIcon

    -- Hide if disabled
    if (not roleDB) or (not roleDB.enable) then
        roleIcon:Hide()
        return
    end

    -- Get role from unit
    local role = UnitGroupRolesAssigned(frame.unit)

    -- Get random role if no roles are assigned and we are in test mode
    if frame.isForced and (role == "NONE") then
        local rnd = random(1, 3)
        role = (rnd == 1) and "TANK" or ((rnd == 2) and "HEALER" or ((rnd == 3) and "DAMAGER"))
    end

    -- Check if we should hide
    local shouldHide = ((event == "PLAYER_REGEN_DISABLED" and roleDB.combatHide and true) or false)

    -- Only apply changes if player is connected (or in test mode)
    if (frame.isForced or UnitIsConnected(frame.unit)) and
        ((role == "DAMAGER" and roleDB.damager) or (role == "HEALER" and roleDB.healer) or
            (role == "TANK" and roleDB.tank)) then

        -- Get role icon
        local roleTexture = I.ElvUIIcons.Role[self.db.theme][unitType] and
                                I.ElvUIIcons.Role[self.db.theme][unitType][role]

        -- Fallback
        if (not roleTexture) then roleTexture = I.ElvUIIcons.Role[self.db.theme]["default"][role] end

        -- Set texture
        roleIcon:SetTexture(I.Media.RoleIcons[roleTexture])

        if (not shouldHide) then
            roleIcon:Show()
        else
            roleIcon:Hide()
        end
    else
        roleIcon:Hide()
    end
end

function RI:ConfigureRoleIcon(_, frame)
    if (not self.db) then return end

    local roleIcon = frame.GroupRoleIndicator
    local frameDB = frame.db

    if (not frameDB) or (not frameDB.roleIcon) or (not frameDB.roleIcon.enable) then return end

    -- If enabled overwrite, if not restore original function
    if (self.db.enabled) then
        roleIcon.Override = function(...)
            RI:SetRoleIcon(...)
        end

        -- Remove connection event
        frame:UnregisterEvent("UNIT_CONNECTION", UF.UpdateRoleIcon)

        -- Register new connection event
        frame:RegisterEvent("UNIT_CONNECTION", roleIcon.Override)

        -- Unregister default events
        E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
        E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)

        -- Register new events
        if frameDB.roleIcon.combatHide then
            E:RegisterEventForObject("PLAYER_REGEN_ENABLED", frame, roleIcon.Override)
            E:RegisterEventForObject("PLAYER_REGEN_DISABLED", frame, roleIcon.Override)
        else
            E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, roleIcon.Override)
            E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, roleIcon.Override)
        end
    else
        -- Remove hooked connection event
        frame:UnregisterEvent("UNIT_CONNECTION", roleIcon.Override)

        -- Restore connection event
        frame:RegisterEvent("UNIT_CONNECTION", UF.UpdateRoleIcon)

        -- Unregister hooked events
        E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, roleIcon.Override)
        E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, roleIcon.Override)

        -- Restore events
        if frameDB.roleIcon.combatHide then
            E:RegisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
            E:RegisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)
        else
            E:UnregisterEventForObject("PLAYER_REGEN_ENABLED", frame, UF.UpdateRoleIcon)
            E:UnregisterEventForObject("PLAYER_REGEN_DISABLED", frame, UF.UpdateRoleIcon)
        end

        -- Restore original update function
        roleIcon.Override = UF.UpdateRoleIcon
    end
end

function RI:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function RI:Disable()
    self:UnregisterAllEvents()

    -- We call an update before unhooking, in case we are active and hooked to replace the old override
    if (UF) then UF:Update_AllFrames() end

    -- Unhook
    self:UnhookAll()

    -- Update all ElvUI Frames
    E:GetModule("UnitFrames"):Update_AllFrames()
end

function RI:Enable()
    self:UnregisterAllEvents()

    -- Hook functions
    self:SecureHook(UF, "Configure_RoleIcon", "ConfigureRoleIcon")

    -- Update Chat Icons
    TXUI:GetModule("Misc"):ChatIcon_ForceUpdate()

    -- Update all ElvUI Frames
    UF:Update_AllFrames()
end

function RI:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.elvUIIcons.roleIcons

    if (self.db and self.db.enabled) and TXUI:HasRequirements(I.Requirements.RoleIcons) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function RI:Initialize()
    -- Set db
    self.db = E.db.TXUI.elvUIIcons.roleIcons

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

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(RI:GetName())
