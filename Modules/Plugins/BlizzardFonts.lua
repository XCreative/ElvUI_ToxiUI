local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local BF = TXUI:NewModule("BlizzardFonts", "AceHook-3.0", "AceEvent-3.0")

local _G = _G

function BF:UpdateFont(obj, font, multi)
    if (not obj) then return self:DebugPrint("UpdateFont > obj is nil") end

    F.SetFontFromDB(E.db.TXUI.blizzardFonts, font, obj, false)

    if multi ~= nil then
        local fontPath, fontSize, fontOutline = obj:GetFont()
        obj:SetFont(fontPath, fontSize * multi, fontOutline)
    end
end

function BF:UpdateSettings()
    local enormous = 1.9
    local mega = 1.7
    local huge = 1.5
    local large = 1.3
    local medium = 1.1
    local small = 0.9

    -- Zone Text
    self:UpdateFont(_G.ZoneTextString, "zone")
    self:UpdateFont(_G.SubZoneTextString, "subZone")
    self:UpdateFont(_G.PVPArenaTextString, "pvpZone")
    self:UpdateFont(_G.PVPInfoTextString, "pvpZone")

    -- Mail Text
    self:UpdateFont(_G.SendMailBodyEditBox, "mail")
    self:UpdateFont(_G.OpenMailBodyText, "mail")
    self:UpdateFont(_G.InvoiceFont_Med, "mail", medium)
    self:UpdateFont(_G.InvoiceFont_Small, "mail", small)
    self:UpdateFont(_G.MailFont_Large, "mail", large)

    -- Gossip Text
    self:UpdateFont(_G.QuestFont, "gossip")
    self:UpdateFont(_G.QuestFont_Enormous, "gossip", enormous)
    self:UpdateFont(_G.QuestFont_Huge, "gossip", huge)
    self:UpdateFont(_G.QuestFont_Large, "gossip", large)
    self:UpdateFont(_G.QuestFont_Shadow_Huge, "gossip", huge)
    self:UpdateFont(_G.QuestFont_Shadow_Small, "gossip")
    self:UpdateFont(_G.QuestFont_Super_Huge, "gossip", mega)
end

function BF:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function BF:Disable()
    self:UnregisterAllEvents()
    self:UnhookAll()
end

function BF:Enable()
    self:UpdateSettings()
    self:UnregisterAllEvents()

    if (not self:IsHooked(E, "UpdateBlizzardFonts")) then
        self:SecureHook(E, "UpdateBlizzardFonts", function()
            self:UpdateSettings()
        end)
    end
end

function BF:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.blizzardFonts

    if TXUI:HasRequirements(I.Requirements.BlizzardFonts) and (self.db and self.db.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize()
        end
    end
end

function BF:Initialize()
    -- Set db
    self.db = E.db.TXUI.blizzardFonts

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.BlizzardFonts)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(BF:GetName())
