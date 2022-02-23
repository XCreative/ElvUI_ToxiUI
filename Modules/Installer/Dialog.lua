local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local IS = TXUI:GetModule("Installer")
local PF = TXUI:GetModule("Profiles")

local _G = _G

--[[ Installer Dialog Table ]] --
function IS:Dialog()
    local installer = E:GetModule("PluginInstaller")

    -- force complete otherwise setup dosen't show
    E.private.install_complete = E.version

    -- if an elvui installation is up, hide it
    if _G.ElvUIInstallFrame and _G.ElvUIInstallFrame:IsShown() then _G.ElvUIInstallFrame:Hide() end

    -- if an another addon (lol the fuck?) is open, close it
    installer:CloseInstall()

    -- Custom close frame handler
    _G.PluginInstallFrame:SetScript("OnHide", function()
        if self.reloadRequired or F.IsTXUIProfile() then
            IS:Complete(not self.reloadRequired)
        else
            installer:CloseInstall()
        end
    end)

    -- Hide PLATER addon compatible popup
    E:StaticPopup_Hide("INCOMPATIBLE_ADDON")

    -- return our Installer
    return {
        Title = TXUI.Title .. " Installation",
        Name = TXUI.Title,
        tutorialImage = I.Media.Logos.Logo,
        Pages = {
            -- Welcome Page or Shared Media warning
            [1] = function()
                if F.IsAddOnEnabled("SharedMedia_ToxiUI") then
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringInstallerWarning("WARNING!"))
                    _G.PluginInstallFrame.Desc1:SetText("Oops, looks like you have " ..
                                                            F.StringToxiUI("SharedMedia: ToxiUI") .. " installed!")
                    _G.PluginInstallFrame.Desc2:SetText("Please disable " .. F.StringToxiUI("SharedMedia: ToxiUI") ..
                                                            " and reset the installation process!")
                    _G.PluginInstallFrame.Desc3:SetText(
                        "If you don't disable " .. F.StringToxiUI("SharedMedia: ToxiUI") .. " it will cause problems!")
                    _G.PluginInstallFrame.Next:Disable()
                elseif not TXUI:HasRequirements({ I.Enum.Requirements.WT_ENABLED }, true) then
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringInstallerWarning("WARNING!"))
                    _G.PluginInstallFrame.Desc1:SetText(F.StringToxiUI("ElvUI WindTools") .. " couldn't be detected.")
                    _G.PluginInstallFrame.Desc2:SetText(
                        "This could mean that the addon isn't installed or isn't enabled. Please ensure " ..
                            F.StringToxiUI("ElvUI WindTools") ..
                            " is installed and enabled in your AddOns menu, and then restart the ToxiUI installation process.")
                    _G.PluginInstallFrame.Next:Disable()
                else
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Welcome") .. " to the installation for " ..
                                                               TXUI.Title)
                    _G.PluginInstallFrame.Desc1:SetText(
                        "This installation process will guide you through a few steps and apply the " .. TXUI.Title ..
                            " profile.")
                    _G.PluginInstallFrame.Desc2:SetText(
                        "Please press the 'Install' button to begin the installation process.")
                    _G.PluginInstallFrame.Desc3:SetText(F.StringInstallerWarning(
                                                            "You will need to do this every time ToxiUI is updated."))
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        _G.PluginInstallFrame.Next:Click()
                    end)
                    _G.PluginInstallFrame.Option1:SetText("Install")
                end
            end,

            -- Profile Page
            [2] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Profile"))
                _G.PluginInstallFrame.Desc1:SetText("You can either create a new profile for " .. TXUI.Title ..
                                                        " or you can use your current profile")
                _G.PluginInstallFrame.Desc2:SetText("Importance: " .. F.StringToxiUI("Medium"))
                _G.PluginInstallFrame.Desc3:SetText("Your currently active profile is: " ..
                                                        F.StringToxiUI(E.data:GetCurrentProfile()))
                _G.PluginInstallFrame.Option1:Show()
                _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                    self:ElvUIProfileDialog()
                end)
                _G.PluginInstallFrame.Option1:SetText("Create New")
            end,

            -- Layout Page
            [3] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Core Settings"))
                _G.PluginInstallFrame.Desc1:SetText("This will install " .. TXUI.Title .. " depending if you want a " ..
                                                        F.StringToxiUI("DPS/Tank") .. " or " ..
                                                        F.StringClass("Healer", "MONK") .. " layout.")
                _G.PluginInstallFrame.Desc2:SetText("This will also enable core functions of ToxiUI.")
                _G.PluginInstallFrame.Desc3:SetText(F.StringInstallerWarning(
                                                        "This part is the most important in the whole installer - not selecting a layout will result in an unfinished UI!"))
                _G.PluginInstallFrame.Option1:Show()
                _G.PluginInstallFrame.Option1:SetText(F.StringToxiUI("DPS/Tank"))
                _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                    E.db.TXUI.installer.layout = I.Enum.Layouts.DPS
                    self:ElvUI()
                    self.reloadRequired = true
                    _G.PluginInstallFrame.Next:Click()
                end)
                _G.PluginInstallFrame.Option2:Show()
                _G.PluginInstallFrame.Option2:SetText(F.StringClass("Healer", "MONK"))
                _G.PluginInstallFrame.Option2:SetScript("OnClick", function()
                    E.db.TXUI.installer.layout = I.Enum.Layouts.HEALER
                    self:ElvUI()
                    self.reloadRequired = true
                    _G.PluginInstallFrame.Next:Click()
                end)
            end,

            -- Details Page
            [4] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Details"))

                if F.IsAddOnEnabled("Details") then
                    _G.PluginInstallFrame.Desc1:SetText("This will import Details profile.")
                    _G.PluginInstallFrame.Desc2:SetText("Importance: " .. F.StringInstallerWarning("HIGH"))
                    _G.PluginInstallFrame.Desc3:SetText(
                        "Details is an AddOn that displays information like damage & healing meters.")
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        PF:Details()
                        self.reloadRequired = true
                        self:ShowStepComplete("'Details' profile")
                        _G.PluginInstallFrame.Next:Click()
                    end)
                    _G.PluginInstallFrame.Option1:SetText("Details")
                else
                    _G.PluginInstallFrame.Desc1:SetText(F.StringInstallerWarning(
                                                            "Oops, looks like you don't have Details installed!"))
                    _G.PluginInstallFrame.Desc2:SetText("Please install Details and reset the installer!")
                end
            end,

            -- Plater Page
            [5] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Plater"))

                if F.IsAddOnEnabled("Plater") then
                    _G.PluginInstallFrame.Desc1:SetText("This will import Plater profile.")
                    _G.PluginInstallFrame.Desc2:SetText("Importance: " .. F.StringInstallerWarning("HIGH"))
                    _G.PluginInstallFrame.Desc3:SetText(
                        "Plater is an AddOn responsible for Nameplates - the Health bars above your enemies.")
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        PF:Plater()
                        self.reloadRequired = true
                        self:ShowStepComplete("'Plater' profile")
                        _G.PluginInstallFrame.Next:Click()
                    end)
                    _G.PluginInstallFrame.Option1:SetText("Plater")
                else
                    _G.PluginInstallFrame.Desc1:SetText(F.StringInstallerWarning(
                                                            "Oops, looks like you don't have Plater installed!"))
                    _G.PluginInstallFrame.Desc2:SetText("Please install Plater and reset the installer!")
                end
            end,

            -- Boss Mod Page
            [6] = function()
                if F.IsAddOnEnabled("BigWigs") then
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("BigWigs"))
                    _G.PluginInstallFrame.Desc1:SetText("This will import BigWigs profile.")
                    _G.PluginInstallFrame.Desc2:SetText("Importance: |cff12b83eLow|r")
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        PF:BigWigs()
                        self:ShowStepComplete("'BigWigs' profile")
                        _G.PluginInstallFrame.Next:Click()
                    end)
                    _G.PluginInstallFrame.Option1:SetText("BigWigs")
                elseif F.IsAddOnEnabled("DBM-Core") then
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Deadly Boss Mods"))
                    _G.PluginInstallFrame.Desc1:SetText("This will import DBM profile.")
                    _G.PluginInstallFrame.Desc2:SetText("Importance: |cff12b83eLow|r")
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        PF:DBM()
                        self:ShowStepComplete("'DBM' profile")
                        _G.PluginInstallFrame.Next:Click()
                    end)
                    _G.PluginInstallFrame.Option1:SetText("DBM")
                else
                    _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Boss Mods"))
                    _G.PluginInstallFrame.Desc1:SetText(F.StringInstallerWarning(
                                                            "Oops, looks like you don't have any of the Boss Mods installed!"))
                    _G.PluginInstallFrame.Desc2:SetText(
                        "If you're a new player, we recommend installing either BigWigs or DBM!")
                end
            end,

            -- WeakAuras recommendations
            [7] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("WeakAuras"))

                if F.IsAddOnEnabled("WeakAuras") then
                    _G.PluginInstallFrame.Desc1:SetText("This will give you links to install important WeakAuras")
                    _G.PluginInstallFrame.Desc2:SetText(F.StringLuxthos("Luxthos") ..
                                                            " has WeakAuras packages for every single class and specialization combination making them very versatile and easy to use! They are also very helpful for new players!")
                    _G.PluginInstallFrame.Option1:Show()
                    _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                        self:PopupWALink()
                    end)
                    _G.PluginInstallFrame.Option1:SetText(F.StringLuxthos("Luxthos") .. " WA")
                else
                    _G.PluginInstallFrame.Desc1:SetText(F.StringInstallerWarning(
                                                            "Oops, looks like you don't have WeakAuras installed!|r"))
                    _G.PluginInstallFrame.Desc2:SetText("For full experience, we highly recommend having WeakAuras!")
                end
            end,

            -- Completed Page
            [8] = function()
                _G.PluginInstallFrame.SubTitle:SetText(F.StringToxiUI("Installation Complete"))
                _G.PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
                _G.PluginInstallFrame.Desc2:SetText(
                    "Please click the button below in order to finalize the process and automatically reload your UI.")
                _G.PluginInstallFrame.Desc3:SetText("If you have any questions/issues please join Discord for support!")
                _G.PluginInstallFrame.Option1:Show()
                _G.PluginInstallFrame.Option1:SetScript("OnClick", function()
                    _G.PluginInstallFrame:Hide()
                end)
                _G.PluginInstallFrame.Option1:SetText("Finish")
                _G.PluginInstallFrame.Option2:Show()
                _G.PluginInstallFrame.Option2:SetScript("OnClick", function()
                    self:PopupDiscordLink()
                end)
                _G.PluginInstallFrame.Option2:SetText("Discord")
            end
        },

        -- Installation Steps
        StepTitles = {
            [1] = "Welcome",
            [2] = "Profile",
            [3] = "Core Settings",
            [4] = "Details",
            [5] = "Plater",
            [6] = "Boss Mods",
            [7] = "WeakAuras",
            [8] = "Installation Complete"
        },

        -- Customize colors
        StepTitlesColor = { 1, 1, 1 },
        StepTitlesColorSelected = TXUI.AddOnColorRGB,
        StepTitleWidth = 200,
        StepTitleButtonWidth = 180,
        StepTitleTextJustification = "RIGHT"
    }
end
