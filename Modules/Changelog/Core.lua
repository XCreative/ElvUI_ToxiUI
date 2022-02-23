local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local CL = TXUI:GetModule("Changelog")

local InCombatLockdown = InCombatLockdown
local print = print
local select = select
local UnitName = UnitName

--[[ Version Check ]] --
function CL:CheckVersion()
    if not F.IsTXUIProfile() then
        E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
    elseif self:HasUpdates(E.db.TXUI.changelog.releaseVersion) then
        E:StaticPopup_Show("TXUI_OPEN_UPDATER")
    end
end

--[[ Version Check for the character specific profile ]] --
function CL:CheckPrivateProfileVersion()
    if F.IsTXUIProfile() and self:IsSame(E.db.TXUI.changelog.releaseVersion, TXUI.ReleaseVersion) and -- latest version installed
        ((not E.private.TXUI.changelog.releaseVersion or E.private.TXUI.changelog.releaseVersion == 0) or
            self:HasUpdates(E.private.TXUI.changelog.releaseVersion)) then -- profile version dosen't match our version
        E:StaticPopup_Show("TXUI_OPEN_PRIVATE_UPDATER")
    end
end

--[[ Has seen changelog popup ]] --
function CL:CheckChangelogSeen()
    if TXUI:GetModule("WunderBar").ToxiUIShown() then return end -- Don't show when we use the toxi icon
    if not self:HasSeenChangelog() then E:StaticPopup_Show("TXUI_OPEN_CHANGELOG") end
end

--[[ Has seen changelog check ]] --
function CL:HasSeenChangelog()
    if F.IsTXUIProfile() and self:IsSame(E.db.TXUI.changelog.releaseVersion, TXUI.ReleaseVersion) and -- latest version installed
        ((not E.db.TXUI.changelog.seenVersion or E.db.TXUI.changelog.seenVersion == 0) or
            self:HasUpdates(E.db.TXUI.changelog.seenVersion)) then -- not asked before on this version
        return false
    end
    return true
end

--[[ Has seen changelog check ]] --
function CL:HasRequiredVersion(version)
    if F.IsTXUIProfile() and self:IsSameOrNewer(E.db.TXUI.changelog.releaseVersion, version) and
        (E.private.TXUI.changelog.releaseVersion and E.private.TXUI.changelog.releaseVersion ~= 0 and
            self:IsSameOrNewer(E.private.TXUI.changelog.releaseVersion, version)) and
        (E.db.TXUI.changelog.lastLayoutVersion and E.db.TXUI.changelog.lastLayoutVersion ~= 0 and
            self:IsSameOrNewer(E.db.TXUI.changelog.lastLayoutVersion, version)) then return true end

    return false
end

--[[ Check for all our profiles ]] --
function CL:ProfileChecks()
    -- Check if a new release is avaible, if not in combat
    self:CheckVersion()

    -- Check if the private profile is on the same version as ours
    self:CheckPrivateProfileVersion()

    -- Check if the user has not seen a changelog yet
    self:CheckChangelogSeen()

    -- Fix bug from 5.0.0
    if (F.IsTXUIProfile() and (not E.db.TXUI.changelog.lastLayoutVersion or E.db.TXUI.changelog.lastLayoutVersion == 0) and
        (E.private.TXUI.changelog.lastLayoutVersion and E.private.TXUI.changelog.lastLayoutVersion ~= 0)) then
        E.db.TXUI.changelog.lastLayoutVersion = E.private.TXUI.changelog.lastLayoutVersion
    end
end

--[[ ProfileUpdate ]] --
function CL:ProfileUpdate()
    -- Check if the private profile is on the same version as ours
    self:CheckPrivateProfileVersion()
end

--[[ After combat if player was in combat during load ]] --
function CL:PLAYER_REGEN_ENABLED()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:ProfileChecks()
end

--[[ After Addons have loaded ]] --
function CL:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileChecks()
        end
    end, 10)
end

--[[ Initialization ]] --
function CL:Initialize()
    -- Don't init second time
    if self.Initialized then return end

    -- Read version from changelog
    TXUI.ReleaseVersion = self:GetVersion()

    -- Check for empty git hash
    if (TXUI.GitHash == "DEV") then TXUI.GitHash = TXUI.ReleaseVersion end

    -- Get formatted current version
    local versionString = self:FormattedVersion()

    -- Login Message
    if E.db.general.loginmessage then
        local msg =
            "Hello, " .. UnitName("Player") .. ". Welcome to " .. TXUI.Title .. " " .. versionString .. " by " ..
                F.StringToxiUI("Toxi") .. ", please visit https://toxiui.com for updates. Thank you."

        -- Convert URL to clickable if chat is loaded
        if E:GetModule("Chat").Initialized then
            msg = select(2, E:GetModule("Chat"):FindURL("CHAT_MSG_DUMMY", msg))
        end

        print(msg) -- we do not use TXUI:Print since its already formatted
    end

    -- Load all changelog/updater/private check popups
    self:LoadPopups()

    -- Register events for checks
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- We are done hooray!
    self.Initialized = true
end

TXUI:RegisterModule(CL:GetName())
