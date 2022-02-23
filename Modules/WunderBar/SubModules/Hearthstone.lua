local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local WB = TXUI:GetModule("WunderBar")
local HS = WB:NewModule("Hearthstone", "AceHook-3.0")
local DT = E:GetModule("DataTexts")

local _G = _G
local CreateFrame = CreateFrame
local FindFlyoutSlotBySpellID = FindFlyoutSlotBySpellID
local floor = math.floor
local format = string.format
local GetBindLocation = GetBindLocation
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetItemIcon = GetItemIcon
local GetSpellCooldown = GetSpellCooldown
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local mod = mod

local BOOKTYPE_SPELL = _G.BOOKTYPE_SPELL

function HS:OnUpdate(elapsed)
    self.updateWait = self.updateWait - elapsed
    if self.updateWait > 0 then return end

    if self.dataLoaded then
        if self.db.cooldownEnabled then self:UpdateCooldownText() end
        if self.mouseOver then self:UpdateTooltip() end
    elseif (self.dataLoaded ~= I.HearthstoneDataLoaded) then
        self.dataLoaded = I.HearthstoneDataLoaded
        self:OnWunderBarUpdate()
    end

    self.updateWait = 1
end

function HS:OnEvent()
    local hsLocation = GetBindLocation() or "Unknown"

    if (hsLocation ~= self.hsLocation) then
        self.hsLocation = hsLocation
        self:UpdateText()
        self:UpdateColor()
        self:UpdateElements()
    end
end

function HS:GetCooldownForItem(itemInfo)
    -- Check if everything is loaded
    if (not self.dataLoaded) then return end

    if (not itemInfo) or (not itemInfo.id) then
        return self:DebugPrint("HS:GetCooldownForItem > Item could not be found in DB")
    end

    local _, gcd = GetSpellCooldown(61304)
    if gcd == nil then return self:DebugPrint("HS:GetCooldownForItem > GetSpellCooldown returned nil for gcd") end

    local startTime, duration

    if (itemInfo.type == "toy") or (itemInfo.type == "item") then
        startTime, duration = GetItemCooldown(itemInfo.id)
    elseif (itemInfo.type == "spell") then
        startTime, duration = GetSpellCooldown(itemInfo.id)
    end

    if startTime == nil or duration == nil then
        return self:DebugPrint("HS:GetCooldownForItem > GetItemCooldown returned nil for item")
    end

    local cooldownTime = startTime + duration - GetTime()
    local ready = (duration - gcd <= 0) or cooldownTime <= 0

    if (not ready) then
        local min = floor(cooldownTime / 60)
        local sec = floor(mod(cooldownTime, 60))
        return false, format("%02d:%02d", min, sec)
    end

    return true, "Ready"
end

function HS:AddHearthstoneLine(itemInfo)
    -- Check if everything is loaded
    if (not self.dataLoaded) then return end

    if (not itemInfo) or (not itemInfo.id) then
        return self:DebugPrint("HS:AddHearthstoneLine > Item could not be found in DB")
    end

    local name = format(itemInfo.name)
    local texture = (itemInfo.type == "spell") and GetSpellTexture(itemInfo.id) or GetItemIcon(itemInfo.id)

    -- Debug
    if texture == nil or texture == "" then
        return self:DebugPrint("HS:AddHearthstoneLine > GetItemIcon returned nil")
    end

    -- Get cooldown
    local ready, readyString = self:GetCooldownForItem(itemInfo)

    -- maw cypher
    if itemInfo.id == 180817 then
        local charge = GetItemCount(itemInfo.id, nil, true)
        name = name .. format(" (%d)", charge)
    end

    -- Good format blizzard, there was no easier way
    local icon = format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t ", texture)
    DT.tooltip:AddDoubleLine(icon .. name, readyString, 1, 1, 1, ready and 0 or 1, ready and 1 or 0, 0)
end

function HS:GetClassTeleport()
    for _, option in pairs(I.HearthstoneData) do
        if (option.known) and (option.class and option.class == E.myclass) then return option end
    end

    return {}
end

function HS:GetMageLovePortals(teleport)
    local flyoutID

    for _, option in pairs(I.HearthstoneData) do
        if (option.known) and (((not teleport) and option.portal) or ((teleport) and option.teleport)) then
            local slot = FindFlyoutSlotBySpellID(option.id)
            if (slot and slot ~= 0) then
                local flyout = select(2, GetSpellBookItemInfo(slot, BOOKTYPE_SPELL))
                if (flyout) then
                    flyoutID = flyout
                    break
                end
            end
        end
    end

    return flyoutID
end

function HS:UpdateSelected()
    -- Check if everything is loaded
    if (not self.dataLoaded) then return end

    -- Check if spell is in DB
    self.hsPrimary = I.HearthstoneData[self.db.primaryHS] or
                         I.HearthstoneData[P.wunderbar.subModules.Hearthstone.primaryHS]
    if (not self.hsPrimary) then
        return self:DebugPrint("HS:UpdateSelected > Item could not be found in DB for hsPrimary")
    end

    -- Check if spell is in DB
    self.hsSecondary = I.HearthstoneData[self.db.secondaryHS] or
                           I.HearthstoneData[P.wunderbar.subModules.Hearthstone.secondaryHS]
    if (not self.hsSecondary) then
        return self:DebugPrint("HS:UpdateSelected > Item could not be found in DB for hsSecondary")
    end

    -- Check if any ids could be found
    if (not self.hsPrimary.id) or (not self.hsSecondary.id) then
        return self:DebugPrint("HS:UpdateSelected > Main IDs and Fallback could not be found")
    end

    -- Fallback to default if spell is not known
    if (not self.hsPrimary.known) then
        self:DebugPrint("HS:UpdateSelected > Overwriting unlearned spell: " .. self.hsPrimary.id .. " for primaryHS")
        self.hsPrimary = I.HearthstoneData[P.wunderbar.subModules.Hearthstone.primaryHS]
    end

    -- Fallback to default if spell is not known
    if (not self.hsSecondary.known) then
        self:DebugPrint("HS:UpdateSelected > Overwriting unlearned spell: " .. self.hsSecondary.id .. " for secondaryHS")
        self.hsSecondary = I.HearthstoneData[P.wunderbar.subModules.Hearthstone.secondaryHS]
    end

    -- Get class teleport for non mages
    if (E.myclass ~= "MAGE") then self.hsClass = self:GetClassTeleport() end

    -- Set Types
    self.secureFrame:SetAttribute("type1", self.hsPrimary.type)
    self.secureFrame:SetAttribute("type2", self.hsSecondary.type)

    -- Set Type IDs
    self.secureFrame:SetAttribute(self.hsPrimary.type .. "1", self.hsPrimary.name)
    self.secureFrame:SetAttribute(self.hsSecondary.type .. "2", self.hsSecondary.name)

    -- Class spells
    if (self.hsClass.name) then
        self.secureFrame:SetAttribute("shift-type2", self.hsClass.type)
        self.secureFrame:SetAttribute("shift-" .. self.hsClass.type .. "2", self.hsClass.name)
    end

    -- Mage Love <3
    if (E.myclass == "MAGE") then
        -- Portal
        local portalFlyOut = self:GetMageLovePortals(false)
        if (portalFlyOut) then
            self.hasPortals = true
            self.secureFrame:SetAttribute("shift-type1", "flyout")
            self.secureFrame:SetAttribute("shift-spell1", portalFlyOut)
            self.secureFrame:SetAttribute("shift-flyoutDirection1", "UP")
        else
            self:DebugPrint("Could not find portal flyout")
        end

        -- Teleport
        local teleportFlyOut = self:GetMageLovePortals(true)
        if (teleportFlyOut) then
            self.hasTeleports = true
            self.secureFrame:SetAttribute("shift-type2", "flyout")
            self.secureFrame:SetAttribute("shift-spell2", teleportFlyOut)
            self.secureFrame:SetAttribute("shift-flyoutDirection2", "UP")
        else
            self:DebugPrint("Could not find teleport flyout")
        end
    end
end

function HS:UpdateTooltip()
    -- Check if everything is loaded
    if (not self.dataLoaded) then return end

    DT.tooltip:ClearLines()
    DT.tooltip:SetText("Hearthstone")
    DT.tooltip:AddLine(" ")

    self:AddHearthstoneLine(self.hsPrimary)
    self:AddHearthstoneLine(self.hsSecondary)

    DT.tooltip:AddLine(" ")

    local additionalAdded = false
    for index, enabled in pairs(self.db.additionaHS) do
        if (enabled) then
            local data = I.HearthstoneData[index]
            if (data and data.known and (not data.hearthstone) and (not data.class) and (not data.portal) and
                (not data.teleport)) then
                if (not additionalAdded) then
                    DT.tooltip:AddLine("Additional")
                    DT.tooltip:AddLine(" ")
                end
                self:AddHearthstoneLine(data)
                additionalAdded = true
            end
        end
    end

    if (additionalAdded) then DT.tooltip:AddLine(" ") end

    local classAdded = false
    if (self.hsClass.name) then
        DT.tooltip:AddLine("Class")
        DT.tooltip:AddLine(" ")
        self:AddHearthstoneLine(self.hsClass)
        DT.tooltip:AddLine(" ")
        classAdded = true
    end

    -- Primary
    if (self.hsPrimary and self.hsPrimary.name) then
        DT.tooltip:AddLine("|cffFFFFFFLeft Click:|r Cast " .. self.hsPrimary.name)
    end

    -- Secondary
    if (self.hsSecondary and self.hsSecondary.name) then
        DT.tooltip:AddLine("|cffFFFFFFRight Click:|r Cast " .. self.hsSecondary.name)
    end

    -- Shift-Secondary for Class Travel other than Mages
    if (classAdded) then DT.tooltip:AddLine("|cffFFFFFFShift-Right Click:|r Cast " .. self.hsClass.name) end

    -- Shift-Primary for Mages
    if (self.hasPortals) then DT.tooltip:AddLine("|cffFFFFFFShift-Left Click:|r Open Mage Portal Menu") end

    -- Shift-Secondary for Mages
    if (self.hasTeleports) then DT.tooltip:AddLine("|cffFFFFFFShift-Right Click:|r Open Mage Teleport Menu") end

    DT.tooltip:Show()
end

function HS:OnEnter()
    WB:SetFontAccentColor(self.hearthstoneText)
    if self.db.showIcon then WB:SetFontAccentColor(self.hearthstoneIcon) end

    self:UpdateTooltip()
    self.mouseOver = true
end

function HS:OnLeave()
    self.mouseOver = false

    WB:SetFontNormalColor(self.hearthstoneText)
    if self.db.showIcon then WB:SetFontIconColor(self.hearthstoneIcon) end
end

function HS:OnWunderBarUpdate()
    if self.dataLoaded then self:UpdateSelected() end

    self:UpdateFonts()
    self:UpdateText()
    self:UpdateColor()
    self:UpdateElements()
end

function HS:UpdateColor()
    WB:SetFontNormalColor(self.hearthstoneText)
    WB:SetFontIconColor(self.hearthstoneIcon)

    if self.db.cooldownUseAccent then
        WB:SetFontAccentColor(self.hearthstoneText.cooldownText, false)
    else
        WB:SetFontNormalColor(self.hearthstoneText.cooldownText, false)
    end
end

function HS:UpdateFonts()
    WB:SetFontFromDB(nil, nil, self.hearthstoneText)
    WB:SetFontFromDB(self.db, "cooldown", self.hearthstoneText.cooldownText, false, self.db.cooldownUseAccent)
    WB:SetIconFromDB(self.db, "icon", self.hearthstoneIcon)
end

function HS:UpdateText()
    self.hearthstoneText:SetText(self.db.useUppercase and F.Uppercase(self.hsLocation) or self.hsLocation)
    self.hearthstoneIcon:SetText(self.db.icon)
end

function HS:UpdateCooldownText()
    local primaryReady, primaryReadyText = self:GetCooldownForItem(self.hsPrimary)
    local secondaryReady, secondaryReadyText = self:GetCooldownForItem(self.hsSecondary)

    if (not primaryReady) and (not secondaryReady) then
        if (not WB:IsTextTransitionPlaying(self.hearthstoneText.cooldownText)) then
            self.hearthstoneText.cooldownLoop = 0

            WB:StartTextTransition(self.hearthstoneText.cooldownText, 5, function(anim)
                if (self.hearthstoneText.cooldownLoop == 0) then
                    anim.LoopCounter = 2
                elseif (anim.LoopCounter > 2) then
                    anim.LoopCounter = 1
                end

                self.hearthstoneText.cooldownLoop = anim.LoopCounter
            end)
        end

        if self.hearthstoneText.cooldownLoop == 1 then
            self.hearthstoneText.cooldownText:SetText(primaryReadyText)
        elseif self.hearthstoneText.cooldownLoop == 2 then
            self.hearthstoneText.cooldownText:SetText(secondaryReadyText)
        else
            self.hearthstoneText.cooldownText:SetText("")
        end
    else
        WB:StopAnimations(self.hearthstoneText.cooldownText)

        if (not primaryReady) then
            self.hearthstoneText.cooldownText:SetText(primaryReadyText)
        elseif (not secondaryReady) then
            self.hearthstoneText.cooldownText:SetText(secondaryReadyText)
        else
            self.hearthstoneText.cooldownText:SetText("")
        end
    end
end

function HS:UpdateElements()
    local anchorPoint = WB:GetGrowDirection(self.Module, true)
    local iconSize = self.db.showIcon and self.db.iconFontSize or 1

    self.hearthstoneText:ClearAllPoints()
    self.hearthstoneIcon:ClearAllPoints()
    self.hearthstoneIcon:SetJustifyH("RIGHT")

    if anchorPoint == "RIGHT" then
        self.hearthstoneText:SetJustifyH("RIGHT")
        self.hearthstoneText:SetPoint("RIGHT", self.frame, "RIGHT", 0, 0)
    else
        self.hearthstoneText:SetJustifyH("LEFT")
        self.hearthstoneText:SetPoint("LEFT", self.frame, "LEFT", (iconSize + 5), 0)
    end

    self.hearthstoneIcon:Point("RIGHT", self.hearthstoneText, "LEFT", -5, 3)
    self.hearthstoneText.cooldownText:SetPoint("CENTER", self.hearthstoneText, "CENTER", 0, self.db.cooldownOffset)

    if (self.db.showIcon) then
        self.hearthstoneIcon:Show()
    else
        self.hearthstoneIcon:Hide()
    end
end

function HS:CreateText()
    local secureFrameHolder = CreateFrame("Button", nil, self.frame, "SecureActionButtonTemplate")
    secureFrameHolder:ClearAllPoints()
    secureFrameHolder:SetAllPoints()
    secureFrameHolder:EnableMouse(true)
    secureFrameHolder:RegisterForClicks("AnyUp")

    self:HookScript(secureFrameHolder, "OnEnter", function(...)
        WB:ModuleOnEnter(self, ...)
    end)

    self:HookScript(secureFrameHolder, "OnLeave", function(...)
        WB:ModuleOnLeave(self, ...)
    end)

    self.secureFrame = secureFrameHolder

    local hearthstoneIcon = secureFrameHolder:CreateFontString(nil, "OVERLAY")
    local hearthstoneText = secureFrameHolder:CreateFontString(nil, "OVERLAY")
    hearthstoneText.cooldownText = secureFrameHolder:CreateFontString(nil, "OVERLAY")
    hearthstoneText.cooldownLoop = 0

    hearthstoneIcon:Point("CENTER")
    hearthstoneText:Point("CENTER")

    self.hearthstoneIcon = hearthstoneIcon
    self.hearthstoneText = hearthstoneText
end

function HS:OnInit()
    -- Get our settings DB
    self.db = WB:GetSubModuleDB(self:GetName())

    -- Don't init second time
    if self.Initialized then return end

    -- Vars
    self.frame = self.SubModuleHolder
    self.updateWait = 0
    self.mouseOver = false
    self.dataLoaded = false
    self.hsLocation = ""
    self.hsPrimary = {}
    self.hsSecondary = {}
    self.hsClass = {}
    self.hasTeleports = false
    self.hasPortals = false

    -- Create stuff
    self:CreateText()
    self:OnWunderBarUpdate()

    -- We are done, hooray!
    self.Initialized = true
end

WB:RegisterSubModule(HS, { "HEARTHSTONE_BOUND" })
