local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local ReloadUI = ReloadUI

function TXUI:HandleDevProfiles(arg1)
    -- Command help
    local printUsage = function()
        self:Print("Usage: /tx profile dps||healer||private||bw||dbm||plater||details")
    end

    -- If no parameter was given
    if (not arg1) then
        printUsage()
        return
    end

    -- Set layout if not set
    E.db.TXUI.installer.layout = E.db.TXUI.installer.layout and E.db.TXUI.installer.layout or I.Enum.Layouts.DPS

    if (arg1 == "dps") then
        E.db.TXUI.installer.layout = I.Enum.Layouts.DPS
        self:Print("Applying " .. F.StringElvUI("ElvUI") .. " DPS Profile ...")
        TXUI:GetModule("Installer"):ElvUI()
    elseif (arg1 == "healer") then
        E.db.TXUI.installer.layout = I.Enum.Layouts.HEALER
        self:Print("Applying " .. F.StringElvUI("ElvUI") .. " Healer Profile ...")
        TXUI:GetModule("Installer"):ElvUI()
    elseif (arg1 == "private") then
        self:Print("Applying all Privates ...")
        TXUI:GetModule("Installer"):Privates()
    elseif (arg1 == "details") then
        self:Print("Applying Details Profile ...")
        TXUI:GetModule("Profiles"):Details()
    elseif (arg1 == "plater") then
        self:Print("Applying Plater Profile ...")
        TXUI:GetModule("Profiles"):Plater()
    elseif (arg1 == "bw") then
        self:Print("Applying BigWigs Profile ...")
        TXUI:GetModule("Profiles"):BigWigs()
    elseif (arg1 == "dbm") then
        self:Print("Applying DBM Profile ...")
        TXUI:GetModule("Profiles"):DBM()
    else -- if wrong parameter given
        printUsage()
    end
end

function TXUI:HandleDevExports(arg1, arg2)
    -- Command help
    local printUsage = function()
        self:Print("Usage: /tx dev export bw||dbm||xiv <dps||healer>")
        self:Print("Example: /tx dev export bw healer")
    end

    if not arg1 then -- Command Usage
        printUsage()

    elseif (arg1 == "bw") then -- BigWigs export
        if not arg2 then
            printUsage()
        elseif (arg2 == "dps") then
            self:Print("Exporting BigWigs DPS Profile ...")
            TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.DPS])
        elseif (arg2 == "healer") then
            self:Print("Exporting BigWigs Healer Profile ...")
            TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.HEALER])
        else
            printUsage()
        end

    elseif (arg1 == "dbm") then -- BigWigs export
        if not arg2 then
            printUsage()
        elseif (arg2 == "dps") then
            self:Print("Exporting DBM DPS Profile ...")
            TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.DPS])
        elseif (arg2 == "healer") then
            self:Print("Exporting DBM Healer Profile ...")
            TXUI:ExportProfile(arg1, I.ProfileNames[I.Enum.Layouts.HEALER])
        else
            printUsage()
        end

    elseif (arg1 == "names") then -- Names import
        TXUI:ExportProfile("import_names", I.NameImportData)
    else
        printUsage()
    end
end

function TXUI:HandleDevCommand(category, arg1, arg2)
    -- Command help
    local printUsage = function()
        self:Print("Usage: /tx dev profile||reset||cvar||anchor||chat||export||wb <arg1> <arg2>")
    end

    if (not category) then
        printUsage()
    elseif (category == "profile") then
        self:HandleDevProfiles(arg1)
    elseif (category == "cvar") then
        self:Print("Applying all CVars ...")
        TXUI:GetModule("Profiles"):ElvUICVars()
    elseif (category == "anchor") then
        self:Print("Applying all anchors ...")
        TXUI:GetModule("Profiles"):ElvUIAnchors()
        E:StaggeredUpdateAll(nil, true)
    elseif (category == "chat") then
        self:Print("Resetting chat & applying new chat Profile ...")
        TXUI:GetModule("Profiles"):ElvUIChat()
        E:StaggeredUpdateAll(nil, true)
    elseif (category == "export") then
        self:HandleDevExports(arg1, arg2)
    elseif (category == "wb") then
        self:Print("Activating WunderBar Debug Mode, ReloadUI to disable ...")
        TXUI:GetModule("WunderBar"):EnableDebugMode()
    elseif (category == "toggle") then
        E.db.TXUI.general.overrideDevMode = not E.db.TXUI.general.overrideDevMode
        ReloadUI()
    else
        printUsage()
    end
end

function TXUI:ShowStatusReport()
    if not F.IsTXUIProfile() then
        self:Print("You are not using a ToxiUI Profile")
        return
    end

    self:GetModule("Misc"):StatusReportShow()
end

function TXUI:HandleChatCommand(msg)
    -- Parse category
    local category = self:GetArgs(msg)

    if (not category) then
        E:ToggleOptionsUI("TXUI")
    elseif (category == "changelog") then
        E:ToggleOptionsUI("TXUI,information,changelog")
    elseif (category == "settings") then
        E:ToggleOptionsUI("TXUI")
    elseif (category == "export") then
        local arg1 = self:GetArgs(msg, 6, 7)
        if (arg1 == "names") then
            self:Print("Exporting Names ...")
            TXUI:ExportProfile("names")
        end
    elseif (category == "wb" or category == "wunderbar") then
        E:ToggleOptionsUI("TXUI,wunderbar")
    elseif (category == "dev") and TXUI.DevRelease then
        self:HandleDevCommand(self:GetArgs(msg, 3, 4))
    elseif (category == "reset") and F.IsTXUIProfile() then
        E:StaticPopup_Show("TXUI_RESET_TXUI_PROFILE")
    elseif (category == "status" or category == "info") and F.IsTXUIProfile() then
        self:ShowStatusReport()
    elseif (category == "install") then
        E:ToggleOptionsUI("TXUI,information,general")
    elseif F.IsTXUIProfile() then
        self:Print("Usage: /tx changelog||install||settings||status||wb")
    else
        self:Print("Usage: /tx changelog||install||settings")
    end
end

function TXUI:LoadCommands()
    self:RegisterChatCommand("tx", "HandleChatCommand")
    self:RegisterChatCommand("txui", "HandleChatCommand")
    self:RegisterChatCommand("toxui", "HandleChatCommand")
    self:RegisterChatCommand("toxiui", "HandleChatCommand")

    -- TROLOLOL
    if F.IsTXUIProfile() then
        E:UnregisterChatCommand("estatus")
        self:RegisterChatCommand("estatus", "ShowStatusReport")
    end
end
