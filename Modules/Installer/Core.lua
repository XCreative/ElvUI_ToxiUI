local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local IS = TXUI:NewModule("Installer", "AceHook-3.0")
local PF = TXUI:GetModule("Profiles")

local _G = _G
local PlaySound = PlaySound
local ReloadUI = ReloadUI

local CANCEL = CANCEL
local OKAY = OKAY

IS.reloadRequired = false

function IS:ShowStepCompleteHook()
    local stepComplete = _G.PluginInstallStepComplete

    if not self:IsHooked(stepComplete, "OnShow") then

        -- Change colors
        stepComplete.bg:SetVertexColor(0, 0, 0, 0.75)
        stepComplete.lineTop:SetVertexColor(0, 0, 0, 1)
        stepComplete.lineBottom:SetVertexColor(0, 0, 0, 1)

        -- Hook script, for better animations and bug fixes
        self:RawHookScript(stepComplete, "OnShow", function(frame)
            if frame.message then
                -- LevelUp Sound
                PlaySound(888)

                -- Set Text
                frame.text:SetText(frame.message)

                -- Reset fade timer
                E:UIFrameFadeOut(frame, 0.25, 0, 1)

                -- Start fading out later but hide quicker
                E:Delay(2.5, function()
                    E:UIFrameFadeOut(frame, 0.25, 1, 0)
                end)

                -- Hide after 4 seconds if no other message was shown
                E:Delay(4, function()
                    if frame:GetAlpha() <= 0 then frame:Hide() end
                end)

                -- Empty message
                frame.message = nil
            else
                frame:Hide()
            end
        end)
    end
end

function IS:ShowStepComplete(step, clean)
    -- Modify message if no clean attri is set
    if not clean then step = step .. " has been set." end
    step = "|cccffffff" .. step .. "|r"

    -- Hook if needed
    self:ShowStepCompleteHook()

    -- Show banner
    _G.PluginInstallStepComplete:Hide()
    _G.PluginInstallStepComplete.message = step
    _G.PluginInstallStepComplete:Show()

    -- Show in chat
    TXUI:Print(step)
end

--[[ Layout Settings ]] --
function IS:ElvUI()
    -- Set right versions, we do this here cause of IsTXUIProfile checks
    E.db.TXUI.changelog.lastLayoutVersion = TXUI.ReleaseVersion
    E.db.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion
    E.private.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion

    -- Setup CVars
    PF:ElvUICVars()

    -- Force DB layout update before making changes
    E:UpdateDB()

    -- ElvUI: Profile
    PF:ElvUIProfile()
    PF:ElvUIProfilePrivate()

    -- Apply Layout
    PF:ElvUILayout()

    -- ElvUI: Colors
    PF:ElvUIColors()

    -- ElvUI: Textures
    PF:ElvUITextures()
    PF:ElvUITexturesPrivate()

    -- ElvUI: Fonts
    PF:ElvUIFont()
    PF:ElvUIFontSize()
    PF:ElvUIFontPrivates()
    PF:ElvUIFontSizePrivates()

    -- Apply other Additonal Addons
    PF:ElvUIAdditional()
    PF:ElvUIAdditionalPrivate()

    -- Apply AddOnSkins settings
    PF:AddOnSkins()

    -- Force UIScale
    E:UIScale(true)
    E:UIScale()
    E:PixelScaleChanged("UI_SCALE_CHANGED")

    -- Force Update
    E:UpdateMoverPositions()
    E:UpdateUnitFrames()

    -- Apply Anchors
    PF:ElvUIAnchors()

    -- Apply chat settings --[[ DISABLED FOR NOW ]]
    -- PF:ElvUIChat()

    -- Apply chat font, dosen't needed if PF:ElvUIChat is called
    PF:ElvUIChatFont()

    -- Update ElvUI
    E:StaggeredUpdateAll(nil, true)

    -- Customize message
    local msg = TXUI.Title .. " " ..
                    (E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER and F.StringClass("Healer", "MONK") or
                        F.StringToxiUI("DPS/Tank") .. " layout")

    -- Show success message
    self:ShowStepComplete(msg)
end

function IS:Privates()
    -- ElvUI
    PF:ElvUIProfilePrivate()
    PF:ElvUIAdditionalPrivate()
    PF:ElvUITexturesPrivate()
    PF:ElvUIFontPrivates()
    PF:ElvUIFontSizePrivates()

    -- AddOns
    PF:AddOnSkins_Private()
    PF:DBM_Private()
    PF:BigWigs_Private()
    PF:Details_Private()
    PF:Plater_Private()

    self:Complete()
end

--[[ Installer Complete ]] --
function IS:Complete(noReload)
    E.db.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion
    E.private.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion

    if not noReload then ReloadUI() end
end

--[[ Profile Check ]] --
function IS:ElvUIProfileDialog()
    E.PopupDialogs.TXUI_CreateProfileNameNew = {
        text = "Name for the new profile",
        hasEditBox = 1,
        whileDead = 1,
        hideOnEscape = 1,
        OnShow = function(frame)
            frame.editBox:SetAutoFocus(false)
            frame.editBox.width = frame.editBox:GetWidth()
            frame.editBox:Width(220)
            frame.editBox:SetText(I.ProfileNames.Default)
            frame.editBox:HighlightText()
        end,
        OnHide = function(frame)
            frame.editBox:Width(frame.editBox.width or 50)
            frame.editBox.width = nil
        end,
        button1 = OKAY,
        button2 = CANCEL,
        OnAccept = function(frame)
            local text = frame.editBox:GetText()
            E.data:SetProfile(text)
            E:StaticPopup_Hide("INCOMPATIBLE_ADDON")
            IS:ShowStepComplete("Profile Created", true)
            _G.PluginInstallFrame.Desc3:SetText("Your currently active profile is: " ..
                                                    F.StringToxiUI(E.data:GetCurrentProfile()))
        end,
        EditBoxOnEnterPressed = function(frame)
            frame:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(frame)
            frame:GetParent():Hide()
        end,
        EditBoxOnTextChanged = E.noop,
        OnEditFocusGained = function(frame)
            frame:HighlightText()
        end
    }

    E:StaticPopup_Show("TXUI_CreateProfileNameNew")
end

--[[ Initialization ]] --
function IS:Initialize()
    -- Don't init second time
    if self.Initialized then return end

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(IS:GetName())
